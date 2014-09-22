# Provides a nice DSL for interacting with the standard CMMotionManager from
# CoreMotion
module BubbleWrap
  # These module methods provide the main interface.  It uses a shared manager
  # (per Apple's recommendation), and they all have a common set of supported
  # methods:
  #     available?
  #     active?
  #     repeat(opts)
  #     once(opts)
  #     every(time_interval, opts)
  #
  # @example
  #     if BW::Motion.accelerometer.available?
  #       BW::Motion.accelerometer.every(5) do |result|
  #         # see the README for the keys that are available in result.
  #       end
  #     end
  #
  # If you insist on using your own manager, or you want more than one
  # BW::Motion::Whatever running at the same time, you'll need to instantiate
  # them yourself.
  #
  # @example
  #     mgr = CMMotionManager.alloc.init
  #     accel = BW::Motion::Accelerometer.new(mgr)
  #     accel.once do |result_data|
  #     end
  #     # => BW::Motion::accelerometer.once do |result_data| ... end
  module Motion
    module_function

    def manager
      @manager ||= CMMotionManager.alloc.init
    end

    def accelerometer
      @accelerometer ||= Accelerometer.new(self.manager)
    end

    def gyroscope
      @gyroscope ||= Gyroscope.new(self.manager)
    end

    def magnetometer
      @magnetometer ||= Magnetometer.new(self.manager)
    end

    def device
      @device ||= DeviceMotion.new(self.manager)
    end
  end


  module Motion
    module Error
    end

    class GenericMotionInterface

      def initialize(manager)
        @manager = manager
      end

      def repeat(options={}, &blk)
        raise "A block is required" unless blk
        blk.weak! if BubbleWrap.use_weak_callbacks?

        self.start(options, &blk)
        return self
      end

      def every(time=nil, options={}, &blk)
        raise "A block is required" unless blk
        blk.weak! if BubbleWrap.use_weak_callbacks?

        if time.is_a?(NSDictionary)
          options = time
        elsif time
          options = options.merge(interval: time)
        end

        self.start(options, &blk)
        return self
      end

      def once(options={}, &blk)
        raise "A block is required" unless blk
        blk.weak! if BubbleWrap.use_weak_callbacks?

        every(options) do |result|
          blk.call(result)
          self.stop
        end

        return self
      end

      private def convert_queue(queue_name)
        case queue_name
        when :main, nil
          return NSOperationQueue.mainQueue
        when :background
          queue = NSOperationQueue.new
          queue.name = 'com.bubble-wrap.core-motion.background-queue'
          return queue
        when :current
          return NSOperationQueue.currentQueue
        when String
          queue = NSOperationQueue.new
          queue.name = queue_name
          return queue
        else
          queue_name
        end
      end

      private def internal_handler(handler)
        retval = -> (result_data, error) do
          handle_result(result_data, error, handler)
        end
        retval.weak! if BubbleWrap.use_weak_callbacks?
        retval
      end

    end

    class Accelerometer < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.accelerometerUpdateInterval = options[:interval]
        end

        if handler
          queue = convert_queue(options[:queue])
          @manager.startAccelerometerUpdatesToQueue(queue, withHandler: internal_handler(handler))
        else
          @manager.startAccelerometerUpdates
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            acceleration: result_data.acceleration,
            x: result_data.acceleration.x,
            y: result_data.acceleration.y,
            z: result_data.acceleration.z,
          }
        else
          result = nil
        end

        handler.call(result, error)
      end

      def available?
        @manager.accelerometerAvailable?
      end

      def active?
        @manager.accelerometerActive?
      end

      def data
        @manager.accelerometerData
      end

      def stop
        @manager.stopAccelerometerUpdates
      end

    end

    class Gyroscope < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.gyroUpdateInterval = options[:interval]
        end

        if handler
          queue = convert_queue(options[:queue])
          @manager.startGyroUpdatesToQueue(queue, withHandler: internal_handler(handler))
        else
          @manager.startGyroUpdates
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            rotation: result_data.rotationRate,
            x: result_data.rotationRate.x,
            y: result_data.rotationRate.y,
            z: result_data.rotationRate.z,
          }
        else
          result = nil
        end

        handler.call(result, error)
      end

      def available?
        @manager.gyroAvailable?
      end

      def active?
        @manager.gyroActive?
      end

      def data
        @manager.gyroData
      end

      def stop
        @manager.stopGyroUpdates
      end

    end

    class Magnetometer < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.magnetometerUpdateInterval = options[:interval]
        end

        if handler
          queue = convert_queue(options[:queue])
          @manager.startMagnetometerUpdatesToQueue(queue, withHandler: internal_handler(handler))
        else
          @manager.startMagnetometerUpdates
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            field: result_data.magneticField,
            x: result_data.magneticField.x,
            y: result_data.magneticField.y,
            z: result_data.magneticField.z,
          }
        else
          result = nil
        end

        handler.call(result, error)
      end

      def available?
        @manager.magnetometerAvailable?
      end

      def active?
        @manager.magnetometerActive?
      end

      def data
        @manager.magnetometerData
      end

      def stop
        @manager.stopMagnetometerUpdates
      end

    end

    class DeviceMotion < GenericMotionInterface

      def start(options={}, &handler)
        if options.key?(:interval)
          @manager.deviceMotionUpdateInterval = options[:interval]
        end

        if options.key?(:reference)
          reference_frame = convert_reference_frame(options[:reference])
        else
          reference_frame = nil
        end

        if handler
          queue = convert_queue(options[:queue])

          if reference_frame
              @manager.startDeviceMotionUpdatesUsingReferenceFrame(reference_frame, toQueue: queue, withHandler: internal_handler(handler))
          else
              @manager.startDeviceMotionUpdatesToQueue(queue, withHandler: internal_handler(handler))
          end
        else
          if reference_frame
            @manager.startDeviceMotionUpdatesUsingReferenceFrame(reference_frame)
          else
            @manager.startDeviceMotionUpdates
          end
        end

        return self
      end

      private def handle_result(result_data, error, handler)
        if result_data
          result = {
            data: result_data,
            attitude: result_data.attitude,
            rotation: result_data.rotationRate,
            gravity: result_data.gravity,
            acceleration: result_data.userAcceleration,
            magnetic: result_data.magneticField,
          }

          if result_data.attitude
            result.merge!({
              roll: result_data.attitude.roll,
              pitch: result_data.attitude.pitch,
              yaw: result_data.attitude.yaw,
              matrix: result_data.attitude.rotationMatrix,
              quaternion: result_data.attitude.quaternion,
            })
          end

          if result_data.rotationRate
            result.merge!({
              rotation_x: result_data.rotationRate.x,
              rotation_y: result_data.rotationRate.y,
              rotation_z: result_data.rotationRate.z,
            })
          end

          if result_data.gravity
            result.merge!({
              gravity_x: result_data.gravity.x,
              gravity_y: result_data.gravity.y,
              gravity_z: result_data.gravity.z,
            })
          end

          if result_data.userAcceleration
            result.merge!({
              acceleration_x: result_data.userAcceleration.x,
              acceleration_y: result_data.userAcceleration.y,
              acceleration_z: result_data.userAcceleration.z,
            })
          end

          if result_data.magneticField
            case result_data.magneticField.accuracy
            when CMMagneticFieldCalibrationAccuracyLow
              accuracy = :low
            when CMMagneticFieldCalibrationAccuracyMedium
              accuracy = :medium
            when CMMagneticFieldCalibrationAccuracyHigh
              accuracy = :high
            end

            result.merge!({
              field: result_data.magneticField.field,
              magnetic_x: result_data.magneticField.field.x,
              magnetic_y: result_data.magneticField.field.y,
              magnetic_z: result_data.magneticField.field.z,
              magnetic_accuracy: accuracy,
            })
          end
        else
          result = nil
        end

        handler.call(result, error)
      end

      def convert_reference_frame(reference_frame)
        case reference_frame
        when :arbitrary_z
          CMAttitudeReferenceFrameXArbitraryZVertical
        when :corrected_z
          CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
        when :magnetic_north
          CMAttitudeReferenceFrameXMagneticNorthZVertical
        when :true_north
          CMAttitudeReferenceFrameXTrueNorthZVertical
        else
          reference_frame
        end
      end

      def available?
        @manager.deviceMotionAvailable?
      end

      def active?
        @manager.deviceMotionActive?
      end

      def data
        @manager.deviceMotion
      end

      def stop
        @manager.stopDeviceMotionUpdates
      end

    end

  end
end
