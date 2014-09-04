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

    Constants.register KCLLocationAccuracyBestForNavigation, KCLLocationAccuracyBest,
        KCLLocationAccuracyNearestTenMeters, KCLLocationAccuracyHundredMeters,
        KCLLocationAccuracyKilometer, KCLLocationAccuracyThreeKilometers

    module_function
    # Start getting locations
    # @param [Hash] options = {
    #   authorization_type: :always/:when_in_use to trigger the type of authorization you want
    #     default == uses :always
    #   significant: true/false; whether to listen for significant location changes or
    #     all location changes (see Apple docs for info); default == false
    #   distance_filter:  minimum change in distance to be updated about, in meters;
    #     default == uses KCLDistanceFilterNone,
    #   desired_accuracy: minimum accuracy for updates to arrive;
    #     any of :best_for_navigation, :best, :nearest_ten_meters,
    #     :hundred_meters, :kilometer, or :three_kilometers; default == :best
    #   purpose: string to display when the system asks user for location,
    #   retries: if location cant be found. how many errors do we retry; default == 5
    #   calibration: if the OS should display the heading calibration to the user; default == false
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
      @callback.weak! if @callback && BubbleWrap.use_weak_callbacks?
      @options = {
        authorization_type: :always,
        significant: false,
        distance_filter: KCLDistanceFilterNone,
        desired_accuracy: KCLLocationAccuracyBest,
        retries: 5,
        once: false,
        calibration: false
      }.merge(options)

      @options[:significant] = false if @options[:significant].nil?
      @retries = 0

      if not enabled?
        error(Error::DISABLED) and return
      end

      self.location_manager

      if self.location_manager.respondsToSelector('requestAlwaysAuthorization')
        @options[:authorization_type] == :always ? self.location_manager.requestAlwaysAuthorization : self.location_manager.requestWhenInUseAuthorization
      end


      self.location_manager.distanceFilter = @options[:distance_filter]
      self.location_manager.desiredAccuracy = Constants.get("KCLLocationAccuracy", @options[:desired_accuracy])
      self.location_manager.purpose = @options[:purpose] if @options[:purpose]

      if @options[:significant]
        self.location_manager.startMonitoringSignificantLocationChanges
      elsif @options[:compass]
        self.location_manager.startUpdatingHeading
      else
        self.location_manager.startUpdatingLocation
      end
    end

    def get_significant(options = {}, &block)
      get(options.merge(significant: true), &block)
    end

    # Get the first returned location based on your options
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
    #   - On success, it returns a CLLocation
    #
    #
    # Example
    # BW::Location.get_once(desired_accuracy: :three_kilometers, purpose: 'We need to use your GPS to show you how fun RM is') do |result|
    #   if result.is_a?(CLLocation)
    #     p "Lat #{result.latitude}, Long #{result.longitude}"
    #   else
    #     p "ERROR: #{result[:error]"
    #   end
    # end
    def get_once(options = {}, &block)
      get(options.merge(once: true), &block)
    end

    def get_compass(options = {}, &block)
      get(options.merge(compass: true), &block)
    end

    def get_compass_once(options = {}, &block)
      get_compass(options.merge(once: true), &block)
    end

    # Stop getting locations
    def stop
      return unless @options
      if @options[:significant]
        self.location_manager.stopMonitoringSignificantLocationChanges
      elsif @options[:compass]
        self.location_manager.stopUpdatingHeading
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

    # returns true/false whether services are enabled for the _app_
    def authorized?
      CLLocationManager.authorizationStatus == KCLAuthorizationStatusAuthorized
    end

    def error(type)
      @callback && @callback.call({ error: type })
      @callback = nil
      self.location_manager.stopUpdatingLocation
    end

    ##########
    # CLLocationManagerDelegate Methods
    def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation)
      if @options[:once]
        @callback && @callback.call(newLocation)
        @callback = proc { |result| }
        stop
      else
        @callback && @callback.call({to: newLocation, from: oldLocation})
      end
    end

    def locationManager(manager, didUpdateHeading:newHeading)
      heading = {
        magnetic_heading: newHeading.magneticHeading,
        true_heading: newHeading.trueHeading,
        accuracy: newHeading.headingAccuracy,
        timestamp: newHeading.timestamp,
      }

      if @options[:once]
        @callback && @callback.call(heading)
        @callback = proc { |result| }
        stop
      else
        @callback && @callback.call(heading)
      end
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

    def locationManagerShouldDisplayHeadingCalibration(manager)
      @options[:calibration] ? @options[:calibration] : false
    end
  end
end
::Location = BubbleWrap::Location unless defined?(::Location)
