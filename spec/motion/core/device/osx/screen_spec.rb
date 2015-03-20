describe BubbleWrap::Device::Screen do
  describe "OS X" do
    describe 'on retina enabled screen' do
      before do
        @screen = Object.new.tap do |o|
          def o.respondsToSelector(selector)
            return true if selector == 'backingScaleFactor'
            NSScreen.mainScreen.respondsToSelector(selector)
          end
          def o.backingScaleFactor
            2.0
          end
          def o.method_missing(*args)
            NSScreen.mainScreen.send(*args)
          end
        end
      end

      describe '.retina?' do
        it 'returns true' do
          BW::Device::Screen.retina?(@screen).should == true
        end
      end
    end
  end
end
