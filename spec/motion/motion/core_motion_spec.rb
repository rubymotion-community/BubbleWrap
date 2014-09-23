describe BubbleWrap::Motion do

  it 'should be able to instantiate all the things' do
    mgr = CMMotionManager.alloc.init
    mgr.should.be.kind_of(CMMotionManager)

    accelerometer = BubbleWrap::Motion::Accelerometer.new(mgr)
    accelerometer.should.be.kind_of(BubbleWrap::Motion::Accelerometer)

    gyroscope = BubbleWrap::Motion::Gyroscope.new(mgr)
    gyroscope.should.be.kind_of(BubbleWrap::Motion::Gyroscope)

    magnetometer = BubbleWrap::Motion::Magnetometer.new(mgr)
    magnetometer.should.be.kind_of(BubbleWrap::Motion::Magnetometer)

    devicemotion = BubbleWrap::Motion::DeviceMotion.new(mgr)
    devicemotion.should.be.kind_of(BubbleWrap::Motion::DeviceMotion)
  end

  describe 'BubbleWrap::Motion.manager' do
    it 'should return a CMMotionManager' do
      BubbleWrap::Motion.manager.should.be.kind_of(CMMotionManager)
    end
    it 'should be a shared instance' do
      mgr1 = BubbleWrap::Motion.manager
      mgr2 = BubbleWrap::Motion.manager
      mgr1.should.equal? mgr2
    end
  end

  describe 'BubbleWrap::Motion.accelerometer' do
    it 'should be a BubbleWrap::Motion::Accelerometer' do
      BubbleWrap::Motion.accelerometer.should.be.kind_of(BubbleWrap::Motion::Accelerometer)
    end
    it 'should be shared instanceAccelerometer' do
      obj1 = BubbleWrap::Motion.accelerometer
      obj2 = BubbleWrap::Motion.accelerometer
      obj1.should.equal? obj2
    end
    it 'should not be available in the simulator' do
      BubbleWrap::Motion.accelerometer.available?.should == false
    end
    it 'should not be active in the simulator' do
      BubbleWrap::Motion.accelerometer.active?.should == false
    end
    it 'should not have data' do
      BubbleWrap::Motion.accelerometer.data.should == nil
    end
    it 'should be able to start with a block' do
      -> do
        BubbleWrap::Motion.accelerometer.start {}
        BubbleWrap::Motion.accelerometer.stop
      end.should.not.raise
    end
    it 'should be able to start without a block' do
      -> do
        BubbleWrap::Motion.accelerometer.start
        BubbleWrap::Motion.accelerometer.stop
      end.should.not.raise
    end
    it 'should be able to repeat' do
      -> do
        BubbleWrap::Motion.accelerometer.repeat {}
        BubbleWrap::Motion.accelerometer.stop
      end.should.not.raise
    end
    it 'should be able to repeat via every' do
      -> do
        BubbleWrap::Motion.accelerometer.every(5) {}
        BubbleWrap::Motion.accelerometer.stop
      end.should.not.raise
    end
    it 'should be able to run once' do
      -> do
        BubbleWrap::Motion.accelerometer.once {}
        BubbleWrap::Motion.accelerometer.stop
      end.should.not.raise
    end
  end

  describe 'BubbleWrap::Motion.gyroscope' do
    it 'should be a BubbleWrap::Motion::Gyroscope' do
      BubbleWrap::Motion.gyroscope.should.be.kind_of(BubbleWrap::Motion::Gyroscope)
    end
    it 'should be a shared instance' do
      obj1 = BubbleWrap::Motion.gyroscope
      obj2 = BubbleWrap::Motion.gyroscope
      obj1.should.equal? obj2
    end
    it 'should not be available in the simulator' do
      BubbleWrap::Motion.gyroscope.available?.should == false
    end
    it 'should not be active in the simulator' do
      BubbleWrap::Motion.gyroscope.active?.should == false
    end
    it 'should not have data' do
      BubbleWrap::Motion.gyroscope.data.should == nil
    end
    it 'should be able to start with a block' do
      -> do
        BubbleWrap::Motion.gyroscope.start {}
        BubbleWrap::Motion.gyroscope.stop
      end.should.not.raise
    end
    it 'should be able to start without a block' do
      -> do
        BubbleWrap::Motion.gyroscope.start
        BubbleWrap::Motion.gyroscope.stop
      end.should.not.raise
    end
    it 'should be able to repeat' do
      -> do
        BubbleWrap::Motion.gyroscope.repeat {}
        BubbleWrap::Motion.gyroscope.stop
      end.should.not.raise
    end
    it 'should be able to repeat via every' do
      -> do
        BubbleWrap::Motion.gyroscope.every(5) {}
        BubbleWrap::Motion.gyroscope.stop
      end.should.not.raise
    end
    it 'should be able to run once' do
      -> do
        BubbleWrap::Motion.gyroscope.once {}
        BubbleWrap::Motion.gyroscope.stop
      end.should.not.raise
    end
  end

  describe 'BubbleWrap::Motion.magnetometer' do
    it 'should be a BubbleWrap::Motion::Magnetometer' do
      BubbleWrap::Motion.magnetometer.should.be.kind_of(BubbleWrap::Motion::Magnetometer)
    end
    it 'should be a shared instance' do
      obj1 = BubbleWrap::Motion.magnetometer
      obj2 = BubbleWrap::Motion.magnetometer
      obj1.should.equal? obj2
    end
    it 'should not be available in the simulator' do
      BubbleWrap::Motion.magnetometer.available?.should == false
    end
    it 'should not be active in the simulator' do
      BubbleWrap::Motion.magnetometer.active?.should == false
    end
    it 'should not have data' do
      BubbleWrap::Motion.magnetometer.data.should == nil
    end
    it 'should be able to start with a block' do
      -> do
        BubbleWrap::Motion.magnetometer.start {}
        BubbleWrap::Motion.magnetometer.stop
      end.should.not.raise
    end
    it 'should be able to start without a block' do
      -> do
        BubbleWrap::Motion.magnetometer.start
        BubbleWrap::Motion.magnetometer.stop
      end.should.not.raise
    end
    it 'should be able to repeat' do
      -> do
        BubbleWrap::Motion.magnetometer.repeat {}
        BubbleWrap::Motion.magnetometer.stop
      end.should.not.raise
    end
    it 'should be able to repeat via every' do
      -> do
        BubbleWrap::Motion.magnetometer.every(5) {}
        BubbleWrap::Motion.magnetometer.stop
      end.should.not.raise
    end
    it 'should be able to run once' do
      -> do
        BubbleWrap::Motion.magnetometer.once {}
        BubbleWrap::Motion.magnetometer.stop
      end.should.not.raise
    end
  end

  describe 'BubbleWrap::Motion.device' do
    it 'should be a BubbleWrap::Motion::DeviceMotion' do
      BubbleWrap::Motion.device.should.be.kind_of(BubbleWrap::Motion::DeviceMotion)
    end
    it 'should be a shared instance' do
      obj1 = BubbleWrap::Motion.device
      obj2 = BubbleWrap::Motion.device
      obj1.should.equal? obj2
    end
    it 'should not be available in the simulator' do
      BubbleWrap::Motion.device.available?.should == false
    end
    it 'should not be active in the simulator' do
      BubbleWrap::Motion.device.active?.should == false
    end
    it 'should not have data' do
      BubbleWrap::Motion.device.data.should == nil
    end
    it 'should be able to start with a block' do
      -> do
        BubbleWrap::Motion.device.start {}
        BubbleWrap::Motion.device.stop
      end.should.not.raise
    end
    it 'should be able to start without a block' do
      -> do
        BubbleWrap::Motion.device.start
        BubbleWrap::Motion.device.stop
      end.should.not.raise
    end
    it 'should be able to repeat' do
      -> do
        BubbleWrap::Motion.device.repeat {}
        BubbleWrap::Motion.device.stop
      end.should.not.raise
    end
    it 'should be able to repeat via every' do
      -> do
        BubbleWrap::Motion.device.every(5) {}
        BubbleWrap::Motion.device.stop
      end.should.not.raise
    end
    it 'should be able to run once' do
      -> do
        BubbleWrap::Motion.device.once {}
        BubbleWrap::Motion.device.stop
      end.should.not.raise
    end
  end

end
