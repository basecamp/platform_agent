# Platform Agent

Parse user agent to discern the common platforms that UIs are tailored for. Expected that you'll inherit from this to specify native apps.

## Examples

```ruby
class ApplicationPlatform < PlatformAgent
  def ios_app?
    match?(/BC3 iOS/)
  end

  def android_app?
    match? /BC3 Android/
  end

  def mac_app?
    match?(/Electron/) && match?(/basecamp3/) && match?(/Macintosh/)
  end

  def windows_app?
    match?(/Electron/) && match?(/basecamp3/) && match?(/Windows/)
  end  
end

module SetPlatform
  extend ActiveSupport::Concern

  included do
    helper_method :platform
  end

  private
    def platform
      @platform ||= ApplicationPlatform.new(request.user_agent)
    end
end

class ApplicationController < ActionController::Base
  include SetPlatform
end

<% if platform.phone? %>
  Do phone specific stuff!
<% end %>
```

## Maintenance Expectations

This library is an extraction from Basecamp that's been sufficient in almost unaltered form for years. While contributions are always welcome, do not expect a lot of feature evolution beyond the basics. 

## License

Special Agent is released under the [MIT License](https://opensource.org/licenses/MIT).