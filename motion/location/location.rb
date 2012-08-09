# Provides a nice DSL for interacting with the standard
# CLLocationManager
#
module BubbleWrap
  module CLLocationWrap

    def latitude
      self.coordinate.latitude
    end

    def longitude
      self.coordinate.longitude
    end
  end

  module Location
    module Error
      DISABLED=0
      PERMISSION_DENIED=1
      NETWORK_FAILURE=2
      LOCATION_UNKNOWN=3
    end

    module_function
    # Start getting locations
    # @param [Hash] options = {
    #   significant: true/false; whether to listen for significant location changes or
    #     all location changes (see Apple docs for info); default == false
    #   distance_filter:  minimum change in distance to be updated about, in meters;
    #     default == uses KCLDistanceFilterNone,
    #   desired_accuracy: minimum accuracy for updates to arrive; 
    #     any of :best_for_navigation, :best, :nearest_ten_meters,
    #     :hundred_meters, :kilometer, or :three_kilometers; default == :best
    #   purpose: string to display when the system asks user for location,
    #   retries: if location cant be found. how many errors do we retry; default == 5
    # }
    # @block for callback. takes one argument, `result`.
    #   - On error or cancelled, is called with a hash {error: BW::Location::Error::<Type>}
    #   - On success, is called with a hash {to: #<CLLocation>, from: #<CLLocation>}
    # 
    # Example
    # BW::Location.get(distance_filter: 10, desired_accuracy: :nearest_ten_meters) do |result|
    #   result[:to].class == CLLocation
    #   result[:from].class == CLLocation
    #   p "Lat #{result[:to].latitude}, Long #{result[:to].longitude}"
    # end
    def get(options = {}, &block)
      @callback = block
      @options = options

      @options[:significant] = false if @options[:significant].nil?
      @options[:distance_filter] ||= KCLDistanceFilterNone
      @options[:desired_accuracy] ||= KCLLocationAccuracyBest
      @options[:retries] ||= 5
      @retries = 0

      if not enabled?
        error(Error::DISABLED) and return
      end

      self.location_manager.distanceFilter = @options[:distance_filter]
      self.location_manager.desiredAccuracy = const_int_get("KCLLocationAccuracy", @options[:desired_accuracy])
      self.location_manager.purpose = @options[:purpose] if @options[:purpose]

      if @options[:significant]
        self.location_manager.startMonitoringSignificantLocationChanges
      else
        self.location_manager.startUpdatingLocation
      end
    end

    def get_significant(options = {}, &block)
      get(options.merge(significant: true), &block)
    end

    # Stop getting locations
    def stop
      if @options[:significant]
        self.location_manager.stopMonitoringSignificantLocationChanges
      else
        self.location_manager.stopUpdatingLocation
      end
    end

    def location_manager
      @location_manager ||= CLLocationManager.alloc.init
      @location_manager.delegate ||= self
      @location_manager
    end

    # returns true/false whether services are enabled for the _device_
    def enabled?
      CLLocationManager.locationServicesEnabled
    end

    def error(type)
      @callback && @callback.call({ error: type })
      @callback = nil
      self.location_manager.stopUpdatingLocation
    end

    ##########
    # CLLocationManagerDelegate Methods
    def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation)
      @callback.call({to: newLocation, from: oldLocation})
    end

    def locationManager(manager, didFailWithError:error)
      if error.domain == KCLErrorDomain
        case error.code
        when KCLErrorDenied
          error(Error::PERMISSION_DENIED)
        when KCLErrorLocationUnknown
          # Docs specify that this is a temporary error,
          # so we stop/start updating to try again.
          @retries += 1
          if @retries > @options[:retries]
            error(Error::LOCATION_UNKNOWN)
          else
            self.location_manager.stopUpdatingLocation
            self.location_manager.startUpdatingLocation
          end
        when KCLErrorNetwork
          error(Error::NETWORK_FAILURE)
        end
      end
    end

    def locationManager(manager, didChangeAuthorizationStatus:status)
      case status
      when KCLAuthorizationStatusRestricted
        error(Error::PERMISSION_DENIED)
      when KCLAuthorizationStatusDenied
        error(Error::PERMISSION_DENIED)
      end
    end

    def const_int_get(base, value)
      return value if value.is_a? Numeric
      value = value.to_s.camelize
      Kernel.const_get("#{base}#{value}")
    end

    def load_constants_hack
      [KCLLocationAccuracyBestForNavigation, KCLLocationAccuracyBest,
        KCLLocationAccuracyNearestTenMeters, KCLLocationAccuracyHundredMeters,
        KCLLocationAccuracyKilometer, KCLLocationAccuracyThreeKilometers,
      ]
    end
  end
end
::Location = BubbleWrap::Location