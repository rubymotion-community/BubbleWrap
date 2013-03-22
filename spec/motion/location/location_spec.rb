describe "CLLocationWrap" do
  it "should have correct values for lat and lng" do
    coordinate = CLLocation.alloc.initWithLatitude(100, longitude: 50)
    coordinate.latitude.should == 100
    coordinate.longitude.should == 50
  end
end

# monkey patch for testing
class CLLocationManager
  def self.enable(enable)
    @enabled = enable
  end

  def self.locationServicesEnabled
    return true if @enabled.nil?
    @enabled
  end

  def startUpdatingLocation
    @startUpdatingLocation = true
  end

  def stopUpdatingLocation
    @stopUpdatingLocation = true
  end

  def startMonitoringSignificantLocationChanges
    @startMonitoringSignificantLocationChanges = true
  end

  def stopMonitoringSignificantLocationChanges
    @stopMonitoringSignificantLocationChanges = true
  end
end

def location_manager
  BW::Location.instance_variable_get("@location_manager")
end

def reset
  CLLocationManager.enable(true)
  BW::Location.instance_variable_set("@callback", nil)
  BW::Location.instance_variable_set("@location_manager", nil)
end

describe BubbleWrap::Location do
  describe ".get" do
    before do
      reset
    end

    it "should set purpose using hash" do
      BW::Location.get(purpose: "test") do |result|
      end

      location_manager.purpose.should == "test"
    end

    it "should throw error if not enabled" do
      CLLocationManager.enable(false)

      BW::Location.get do |result|
        result[:error].should == BW::Location::Error::DISABLED
      end
    end

    it "should throw error if permission denied" do
      BW::Location.get do |result|
        result[:error].should == BW::Location::Error::PERMISSION_DENIED
      end

      error = NSError.errorWithDomain(KCLErrorDomain, code: KCLErrorDenied, userInfo: nil)
      BW::Location.locationManager(location_manager, didFailWithError: error)
    end

    it "should use significant update functions with :significant param" do
      BW::Location.get(significant: true) do |result|
      end

      location_manager.instance_variable_get("@startMonitoringSignificantLocationChanges").should == true
    end

    it "should use normal update functions" do
      BW::Location.get do |result|
      end

      location_manager.instance_variable_get("@startUpdatingLocation").should == true
    end

    it "should have correct location when succeeding" do
      to = CLLocation.alloc.initWithLatitude(100, longitude: 50)
      from = CLLocation.alloc.initWithLatitude(100, longitude: 49)

      BW::Location.get do |result|
        result[:to].longitude.should == 50
        result[:from].longitude.should == 49
      end

      BW::Location.locationManager(location_manager, didUpdateToLocation: to, fromLocation: from)
    end
  end

  describe ".get_once" do
    it "should have correct location when succeeding" do
      to = CLLocation.alloc.initWithLatitude(100, longitude: 50)
      from = CLLocation.alloc.initWithLatitude(100, longitude: 49)

      @number_times = 0
      BW::Location.get_once do |location|
        location.longitude.should == 50
        location.latitude.should == 100
        @number_times += 1
      end

      BW::Location.locationManager(location_manager, didUpdateToLocation: to, fromLocation: from)

      to = CLLocation.alloc.initWithLatitude(0, longitude: 0)
      from = CLLocation.alloc.initWithLatitude(0, longitude: 0)
      BW::Location.locationManager(location_manager, didUpdateToLocation: to, fromLocation: from)
      @number_times.should == 1
    end
  end

  describe ".get_significant" do
    before do
      reset
    end

    it "should use significant changes functions" do
      BW::Location.get_significant do |result|
      end

      location_manager.instance_variable_get("@startMonitoringSignificantLocationChanges").should == true
    end

    it "should have correct location when succeeding" do
      to = CLLocation.alloc.initWithLatitude(100, longitude: 50)
      from = CLLocation.alloc.initWithLatitude(100, longitude: 49)

      BW::Location.get_significant do |result|
        result[:to].longitude.should == 50
        result[:from].longitude.should == 49
      end

      BW::Location.locationManager(location_manager, didUpdateToLocation: to, fromLocation: from)
    end
  end

  describe ".stop" do
    before do
      reset
    end

    it "should use normal update functions" do
      BW::Location.get do |result|
      end

      BW::Location.stop

      location_manager.instance_variable_get("@stopUpdatingLocation").should == true
    end

    it "should use significant update functions with get_significant" do
      BW::Location.get_significant do |result|
      end

      BW::Location.stop

      location_manager.instance_variable_get("@stopMonitoringSignificantLocationChanges").should == true
    end
  end
end
