require 'active_support'
require 'active_support/testing/autorun'

require 'platform_agent'

class BasecampAgent < PlatformAgent
  def ios_app?
    match? /BC3 iOS/
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

class PlatformAgentTest < ActiveSupport::TestCase
  WINDOWS_PHONE    = 'Mozilla/5.0 (Mobile; Windows Phone 8.1; Android 4.0; ARM; Trident/7.0; Touch; rv:11.0; IEMobile/11.0; NOKIA; Lumia 520) like iPhone OS 7_0_3 Mac OS X AppleWebKit/537 (KHTML, like Gecko) Mobile Safari/537'
  CHROME_DESKTOP   = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'
  CHROME_ANDROID   = 'Mozilla/5.0 (Linux; Android 4.4; Nexus 5 Build/_BuildID_) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36'
  SAFARI_IPHONE    = 'Mozilla/5.0 (iPhone; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B410 Safari/600.1.4'
  SAFARI_IPAD      = 'Mozilla/5.0 (iPad; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B410 Safari/600.1.4'
  BASECAMP_MAC     = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) basecamp3/1.0.2 Chrome/47.0.2526.110 Electron/0.36.7 Safari/537.36'
  BASECAMP_WINDOWS = 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) basecamp3/1.0.2 Chrome/49.0.2623.75 Electron/0.36.7 Safari/537.36'
  BASECAMP_IPAD    = 'BC3 iOS/3.0.1 (build 13; iPad Air 2); iOS 9.3'
  BASECAMP_IPHONE  = 'BC3 iOS/3.0.1 (build 13; iPhone 6S); iOS 9.3'
  BASECAMP_ANDROID = 'BC3 Android/3.0.1 (build 13; Galaxy S3); Marshmallow'

  test "chrome is via web" do
    assert_equal "web", platform(CHROME_DESKTOP)
  end

  test "safari iOS is via phone" do
    assert_equal "phone", platform(SAFARI_IPHONE)
  end

  test "safari iPad is via tablet" do
    assert_equal "tablet", platform(SAFARI_IPAD)
  end

  test "basecamp iPhone is via iPhone app" do
    assert_equal "iPhone app", platform(BASECAMP_IPHONE)
  end

  test "basecamp iPad is via iPad app" do
    assert_equal "iPad app", platform(BASECAMP_IPAD)
  end

  test "basecamp Android is via Android app" do
    assert_equal "Android app", platform(BASECAMP_ANDROID)
  end

  test "basecamp Mac is via Mac app" do
    assert_equal "Mac app", platform(BASECAMP_MAC)
  end

  test "basecamp Windows is via Windows app" do
    assert_equal "Windows app", platform(BASECAMP_WINDOWS)
  end

  test "blank user agent is via missing" do
    assert_equal "missing", platform(nil)
  end

  test "other phones are via phone" do
    assert_equal "phone", platform(WINDOWS_PHONE)
  end

  test "non-native app android detection" do
    assert android_phone?(CHROME_ANDROID), "CHROME_ANDROID should be android phone"

    assert_not android_phone?(SAFARI_IPHONE), "SAFARI_IPHONE should not be android phone"
    assert_not android_phone?(BASECAMP_ANDROID), "BC3_ANDROID should not be android phone"
  end

  private
    def platform(agent)
      BasecampAgent.new(agent).to_s
    end

    def android_phone?(agent)
      BasecampAgent.new(agent).android_phone?
    end
end
