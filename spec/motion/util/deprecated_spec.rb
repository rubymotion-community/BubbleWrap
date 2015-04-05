module ModuleExample
  include BubbleWrap::Deprecated

  module_function

  def a_method
    @called = true
  end

  deprecated :a_method, "100.0.0"
end

class ClassExample
  include BubbleWrap::Deprecated

  def a_method
    @called = true
  end
  deprecated :a_method, "100.0.0"
end

module BubbleWrap
  def self.set_version(version)
    define_singleton_method("version") do
      version
    end
  end
end

describe BubbleWrap::Deprecated do
  describe ".deprecated" do
    describe "on a module method" do
      describe "with valid version" do
        it "should not raise an exception" do
          should.not.raise(BubbleWrap::Deprecated::DeprecatedError) {
            ModuleExample.a_method
          }
        end
      end

      describe "with invalid version" do
        before do
          @old_version = BubbleWrap.version
          BubbleWrap.set_version("100.0.0")
        end
        after do
          BubbleWrap.set_version(@old_version)
        end

        it "should raise an exception" do
          should.raise(BubbleWrap::Deprecated::DeprecatedError) {
            ModuleExample.a_method
          }
        end
      end
    end

    describe "on an instance method" do
      describe "with valid version" do
        it "should not raise an exception" do
          should.not.raise(BubbleWrap::Deprecated::DeprecatedError) {
            ClassExample.new.a_method
          }
        end
      end

      describe "with invalid version" do
        before do
          @old_version = BubbleWrap.version
          BubbleWrap.set_version("100.0.0")
        end
        after do
          BubbleWrap.set_version(@old_version)
        end

        it "should raise an exception" do
          should.raise(BubbleWrap::Deprecated::DeprecatedError) {
            ClassExample.new.a_method
          }
        end
      end
    end
  end
end
