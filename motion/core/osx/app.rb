module BubbleWrap
  module App
    module_function

    # Application Delegate
    def delegate
      shared.delegate
    end

    # the Application object.
    def shared
      NSApplication.sharedApplication
    end
  end
end