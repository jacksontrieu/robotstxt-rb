# frozen_string_literal: true

require_relative "robotstxt-rb/ffi"

module RobotstxtRb
  # Public Ruby API (thin facade)
  def self.allowed?(robots_txt:, user_agent:, url:)
    raise ArgumentError, "robots_txt is required" if robots_txt.nil?
    raise ArgumentError, "user_agent is required" if user_agent.nil?
    raise ArgumentError, "url is required" if url.nil?

    FFI.allowed?(robots_txt: robots_txt, user_agent: user_agent, url: url)
  end

  def self.valid?(robots_txt:)
    return false if robots_txt.nil?

    FFI.valid?(robots_txt: robots_txt)
  end
end
