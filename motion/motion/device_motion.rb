module BubbleWrap
  module Motion
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
