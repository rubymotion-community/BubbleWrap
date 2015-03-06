module BubbleWrap
  module App
    module_function

    # Opens an url (string or instance of `NSURL`)
    # in the default web browser
    # Usage Example:
    #   App.open_url("http://www.rubymotion.com")
    def open_url(url)
      unless url.is_a?(NSURL)
        url = NSURL.URLWithString(url)
      end
      NSWorkspace.sharedWorkspace.openURL(url)
    end

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
