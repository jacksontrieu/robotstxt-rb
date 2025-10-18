require_relative "robotstxt-rb/ffi"

module RobotstxtRb
  # Public Ruby API (thin facade)
  def self.allowed?(robots_txt:, user_agent:, url:)
    FFI.allowed?(robots_txt: robots_txt, user_agent: user_agent, url: url)
  end

  def self.valid?(robots_txt:)
    FFI.valid?(robots_txt: robots_txt)
  end
end
