describe BW::UIBarButtonItem do
  describe ".styled" do
    describe "given an unknown style" do
      it "raises an exception" do
        exception = should.raise(NameError) { BW::UIBarButtonItem.styled(:unknown, "object") }
        exception.message.should.equal("uninitialized constant Kernel::UIBarButtonItemStyleUnknown")
      end
    end

    describe "given an invalid object" do
      it "raises an exception" do
        exception = should.raise(ArgumentError) { BW::UIBarButtonItem.styled(:plain, :object) }
        exception.message.should.equal("invalid object - :object")
      end
    end

    ###############################################################################################

    describe "given a String object" do
      before do
        @object  = "Friends"
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.styled(:plain, @object, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStylePlain)
      end

      it "has the correct title" do
        @subject.title.should.equal(@object)
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given a String object but no block" do
      before do
        @object  = "Friends"
        @subject = BW::UIBarButtonItem.styled(:plain, @object)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStylePlain)
      end

      it "has the correct title" do
        @subject.title.should.equal(@object)
      end

      it "has the correct target" do
        @subject.target.should.equal(nil)
      end

      it "has the correct action" do
        @subject.target.should.equal(nil)
      end
    end

    ###############################################################################################

    describe "given an UIImage object" do
      before do
        @object  = UIImage.alloc.init
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.styled(:bordered, @object, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStyleBordered)
      end

      it "has the correct image" do
        @subject.image.should.equal(@object)
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given two UIImage objects" do
      before do
        @object1 = UIImage.alloc.init
        @object2 = UIImage.alloc.init
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.styled(:done, @object1, @object2, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStyleDone)
      end

      it "has the correct image" do
        @subject.image.should.equal(@object1)
      end

      it "has the correct iPhone landscape image" do
        @subject.landscapeImagePhone.should.equal(@object2)
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end
  end

  #################################################################################################

  describe ".system" do
    describe "given an unknown system item" do
      it "raises an exception" do
        exception = should.raise(NameError) { BW::UIBarButtonItem.system(:unknown) }
        exception.message.should.equal("uninitialized constant Kernel::UIBarButtonSystemItemUnknown")
      end
    end

    ###############################################################################################

    describe "given a system item" do
      before do
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.system(:save, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct system item" do
        # TIP: systemItem is an undocumented property
        @subject.systemItem.should.equal(UIBarButtonSystemItemSave)
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given a system item but no block" do
      before do
        @subject = BW::UIBarButtonItem.system(:save)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct system item" do
        @subject.systemItem.should.equal(UIBarButtonSystemItemSave)
      end

      it "has the correct target" do
        @subject.target.should.equal(nil)
      end

      it "has the correct action" do
        @subject.action.should.equal(nil)
      end
    end
  end

  #################################################################################################

  describe ".custom" do
    describe "given a custom view" do
      before do
        @view    = UIView.alloc.init
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.custom(@view, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has a custom view" do
        @subject.customView.should.equal(@view)
      end

      it "adds one, single tap gesture recognizer to the custom view" do
        @view.gestureRecognizers.size.should.equal(1)
        @view.gestureRecognizers.first.class.should.equal(UITapGestureRecognizer)
        @view.gestureRecognizers.first.numberOfTapsRequired.should.equal(1)
      end
    end

    ###############################################################################################

    describe "given a custom view but no block" do
      before do
        @view    = UIView.alloc.init
        @subject = BW::UIBarButtonItem.custom(@view)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has a custom view" do
        @subject.customView.should.equal(@view)
      end

      it "adds no gesture recognizers to the custom view" do
        @view.gestureRecognizers.should.equal(nil)
      end
    end
  end

  #################################################################################################

  describe ".build" do
    describe "not given options" do
      it "raises an exception" do
        exception = should.raise(ArgumentError) { BW::UIBarButtonItem.build }
        exception.message.should.equal("invalid options - {}")
      end
    end

    describe "given unknown options" do
      it "raises an exception" do
        exception = should.raise(ArgumentError) { BW::UIBarButtonItem.build(:unknown => true) }
        exception.message.should.equal("invalid options - {:unknown=>true}")
      end
    end

    describe "given incompatible options for a styled item" do
      before do
        @options = {
          :styled => :bordered,
          :title  => "Friends",
          :image  => UIImage.alloc.init
        }
      end

      it "raises an exception" do
        exception = should.raise(ArgumentError) { BW::UIBarButtonItem.build(@options) }
        exception.message.should.equal("invalid object - #{@options.values_at(:title, :image)}")
      end
    end

    ###############################################################################################

    describe "given options for a styled item with a title" do
      before do
        @options = { :styled => :plain, :title => "Friends" }
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.build(@options, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStylePlain)
      end

      it "has the correct title" do
        @subject.title.should.equal(@options[:title])
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given options for a styled item with an image" do
      before do
        @options = { :styled => :bordered, :image => UIImage.alloc.init }
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.build(@options, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStyleBordered)
      end

      it "has the correct image" do
        @subject.image.should.equal(@options[:image])
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given options for a styled item with two images" do
      before do
        @options = {
          :styled    => :bordered,
          :image     => UIImage.alloc.init,
          :landscape => UIImage.alloc.init
        }
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.build(@options, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct style" do
        @subject.style.should.equal(UIBarButtonItemStyleBordered)
      end

      it "has the correct image" do
        @subject.image.should.equal(@options[:image])
      end

      it "has the correct iPhone landscape image" do
        @subject.landscapeImagePhone.should.equal(@options[:landscape])
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given options for a system item" do
      before do
        @options = { :system => :save }
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.build(@options, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has the correct system item" do
        @subject.systemItem.should.equal(UIBarButtonSystemItemSave)
      end

      it "has the correct target" do
        @subject.target.should.equal(@target)
      end

      it "has the correct action" do
        @subject.action.should.equal(:call)
      end
    end

    ###############################################################################################

    describe "given options for a custom view" do
      before do
        @options = { :custom => UIView.alloc.init }
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.build(@options, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has a custom view" do
        @subject.customView.should.equal(@options[:custom])
      end

      it "adds one, single tap gesture recognizer to the custom view" do
        @options[:custom].gestureRecognizers.size.should.equal(1)
        @options[:custom].gestureRecognizers.first.class.should.equal(UITapGestureRecognizer)
        @options[:custom].gestureRecognizers.first.numberOfTapsRequired.should.equal(1)
      end
    end

    ###############################################################################################

    describe "given options for a view" do
      before do
        @options = { :view => UIView.alloc.init }
        @target  = -> { true }
        @subject = BW::UIBarButtonItem.build(@options, &@target)
      end

      it "has the correct class" do
        @subject.class.should.equal(UIBarButtonItem)
      end

      it "has a custom view" do
        @subject.customView.should.equal(@options[:view])
      end

      it "adds one, single tap gesture recognizer to the view" do
        @options[:view].gestureRecognizers.size.should.equal(1)
        @options[:view].gestureRecognizers.first.class.should.equal(UITapGestureRecognizer)
        @options[:view].gestureRecognizers.first.numberOfTapsRequired.should.equal(1)
      end
    end
  end
end
