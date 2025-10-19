# frozen_string_literal: true

require "ffi"

module RobotstxtRb
  module FFI
    extend ::FFI::Library

    def self.platform_tag
      case RUBY_PLATFORM
      when /darwin.*arm64/ then "darwin-arm64"
      when /darwin/        then "darwin-x86_64"
      when /linux.*aarch64/ then "linux-arm64"
      when /linux/ then "linux-x86_64"
      else
        raise "Unsupported platform: #{RUBY_PLATFORM}"
      end
    end

    def self.native_dir
      File.expand_path("../native/#{platform_tag}", __FILE__)
    end

    def self.shared_lib_name
      if RUBY_PLATFORM =~ /darwin/
        "librobotstxt_ffi.dylib"
      else
        "librobotstxt_ffi.so"
      end
    end

    def self.shared_lib_path
      File.join(native_dir, shared_lib_name)
    end

    # Load the prebuilt shared library
    ffi_lib shared_lib_path

    # C signatures
    attach_function :robots_is_allowed, %i[string string string], :int
    attach_function :robots_is_valid,   [:string], :int

    # Ruby-friendly wrappers
    def self.allowed?(robots_txt:, user_agent:, url:)
      robots_is_allowed(robots_txt, user_agent, url) == 1
    end

    def self.valid?(robots_txt:)
      robots_is_valid(robots_txt) == 1
    end
  end
end
