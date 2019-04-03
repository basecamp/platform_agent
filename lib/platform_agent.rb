require "user_agent"

class PlatformAgent
  def initialize(user_agent_string)
    self.user_agent_string = user_agent_string
  end

  delegate :browser, :version, :product, to: :user_agent

  def desktop?
    !mobile?
  end

  def mobile?
    phone? || tablet? || mobile_app?
  end

  def phone?
    iphone? || android? || other_phones?
  end

  def iphone?
    match? /iPhone/
  end

  def android_phone?
    !android_app? && android?
  end

  def other_phones?
    match? /(iPod|Windows Phone|BlackBerry|BB10.*Mobile|Mobile.*Firefox)/
  end

  def tablet?
    ipad? || match?(/(Kindle|Silk)/)
  end

  def ipad?
    match? /iPad/
  end

  def android?
    match? /Android/
  end

  def native_app?
    mobile_app? || desktop_app?
  end

  def mobile_app?
    ios_app? || android_app?
  end

  def iphone_app?
    iphone? && ios_app?
  end

  def ipad_app?
    ipad? && ios_app?
  end

  # Must overwrite with app-specific match
  def ios_app?
    false
  end

  # Must overwrite with app-specific match
  def android_app?
    false
  end

  def desktop_app?
    mac_app? || windows_app?
  end

  # Must overwrite with app-specific match
  def mac_app?
    false
  end

  # Must overwrite with app-specific match
  def windows_app?
    false
  end

  def missing?
    user_agent_string.nil?
  end

  def app_version
    # App user-agent string is parsed into two separate UserAgent instances, it's the last one that contains the right version
    user_agent.last.version if native?
  end

  def to_s
    case
    when ipad_app?     then "iPad app"
    when iphone_app?   then "iPhone app"
    when android_app?  then "Android app"
    when mac_app?      then "Mac app"
    when windows_app?  then "Windows app"
    when tablet?       then "tablet"
    when phone?        then "phone"
    when missing?      then "missing"
    else                    "web"
    end
  end

  private
    attr_accessor :user_agent_string

    def match?(pattern)
      !!user_agent_string.to_s.match(pattern)
    end

    def user_agent
      @user_agent ||= UserAgent.parse(user_agent_string)
    end
end
