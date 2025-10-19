# frozen_string_literal: true

require "spec_helper"

RSpec.describe RobotstxtRb do
  describe ".allowed?" do
    context "with basic robots.txt content" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: *
          Disallow: /admin
          Disallow: /private
          Allow: /public
        ROBOTS
      end

      it "returns true for allowed URLs" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/public",
               )).to be true
      end

      it "returns false for disallowed URLs" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/admin",
               )).to be false
      end

      it "returns false for disallowed URLs with different paths" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/private",
               )).to be false
      end

      it "returns true for root URL when not explicitly disallowed" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/",
               )).to be true
      end
    end

    context "with specific user agent rules" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: Googlebot
          Disallow: /search
          Allow: /

          User-agent: *
          Disallow: /
        ROBOTS
      end

      it "allows Googlebot to access allowed URLs" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "Googlebot",
                 url: "https://example.com/",
               )).to be true
      end

      it "disallows Googlebot from accessing disallowed URLs" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "Googlebot",
                 url: "https://example.com/search",
               )).to be false
      end

      it "disallows other bots from accessing any URL" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "OtherBot",
                 url: "https://example.com/",
               )).to be false
      end

      it "handles case-insensitive user agent matching" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "googlebot",
                 url: "https://example.com/",
               )).to be true
      end

      it "handles mixed case user agent matching" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "GoOgLeBoT",
                 url: "https://example.com/",
               )).to be true
      end
    end

    context "with wildcard patterns" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: *
          Disallow: /*.pdf$
          Disallow: /temp*
          Allow: /temp/public
        ROBOTS
      end

      context "disallowed URLs" do
        it "disallows URLs ending with .pdf" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/document.pdf",
                 )).to be false
        end

        it "disallows URLs starting with /temp" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/temp/file",
                 )).to be false
        end
      end

      context "allowed URLs" do
        it "allows URLs not ending with .pdf" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/document.html",
                 )).to be true
        end

        it "allows specific exception to temp rule" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/temp/public",
                 )).to be true
        end

        it "allows URLs with different case for .pdf pattern (case-sensitive)" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/DOCUMENT.PDF",
                 )).to be true
        end

        it "allows URLs with different case for temp pattern (case-sensitive)" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/TEMP/file",
                 )).to be true
        end
      end
    end

    context "with multiple disallow rules" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: *
          Disallow: /admin
          Disallow: /private
          Disallow: /secret
          Allow: /admin/public
        ROBOTS
      end

      context "disallowed URLs" do
        it "disallows URLs matching first disallow rule" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/admin",
                 )).to be false
        end

        it "disallows URLs matching second disallow rule" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/private",
                 )).to be false
        end

        it "disallows URLs matching third disallow rule" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/secret",
                 )).to be false
        end
      end

      context "allowed URLs" do
        it "allows URLs matching allow rule even if parent is disallowed" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/admin/public",
                 )).to be true
        end

        it "allows URLs not matching any disallow rules" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/public",
                 )).to be true
        end
      end
    end

    context "with empty or minimal robots.txt" do
      it "allows all URLs when robots.txt is empty" do
        expect(described_class.allowed?(
                 robots_txt: "",
                 user_agent: "MyBot",
                 url: "https://example.com/any/path",
               )).to be true
      end

      it "allows all URLs when robots.txt has no disallow rules" do
        robots_txt = "User-agent: *\nAllow: /"
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/any/path",
               )).to be true
      end
    end

    context "with malformed robots.txt" do
      let(:malformed_robots) do
        <<~ROBOTS
          User-agent: *
          Disallow: /admin
          Invalid-directive: some-value
          User-agent: *
          Disallow: /private
        ROBOTS
      end

      it "still processes valid rules correctly" do
        expect(described_class.allowed?(
                 robots_txt: malformed_robots,
                 user_agent: "MyBot",
                 url: "https://example.com/admin",
               )).to be false
      end
    end

    context "with different URL formats" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: *
          Disallow: /admin
        ROBOTS
      end

      it "handles URLs with query parameters" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/admin?param=value",
               )).to be false
      end

      it "handles URLs with fragments" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/admin#section",
               )).to be false
      end

      it "handles URLs with ports" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com:8080/admin",
               )).to be false
      end

      it "handles relative URLs" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "/admin",
               )).to be false
      end

      it "handles URLs with different domains" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://different-domain.com/admin",
               )).to be false
      end

      it "handles malformed URLs without protocol" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "example.com/admin",
               )).to be false
      end

      it "handles URLs with invalid characters" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/admin with spaces",
               )).to be false
      end

      it "handles very long URLs" do
        long_path = "/admin/#{'a' * 1000}"
        long_url = "https://example.com#{long_path}"
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: long_url,
               )).to be false
      end
    end

    context "with RFC 9309 case sensitivity behavior" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: GoogleBot
          Disallow: /Admin
          Disallow: /PRIVATE
          Allow: /admin/public

          User-agent: *
          Disallow: /admin
        ROBOTS
      end

      context "user agent case-insensitive matching" do
        it "matches GoogleBot with exact case" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/Admin",
                 )).to be false
        end

        it "matches googlebot with lowercase" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "googlebot",
                   url: "https://example.com/Admin",
                 )).to be false
        end

        it "matches GOOGLEBOT with uppercase" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GOOGLEBOT",
                   url: "https://example.com/Admin",
                 )).to be false
        end
      end

      context "path case-sensitive matching" do
        it "disallows exact case match for /Admin" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/Admin",
                 )).to be false
        end

        it "disallows exact case match for /PRIVATE" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/PRIVATE",
                 )).to be false
        end

        it "allows different case for /Admin pattern" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/admin",
                 )).to be true
        end

        it "allows different case for /PRIVATE pattern" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/private",
                 )).to be true
        end
      end

      context "allow rule precedence" do
        it "allows exact case match for allow rule" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/admin/public",
                 )).to be true
        end

        it "disallows different case for allow rule" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "GoogleBot",
                   url: "https://example.com/Admin/public",
                 )).to be false
        end
      end
    end

    context "with case-insensitive directives (RFC 9309)" do
      let(:robots_txt) do
        <<~ROBOTS
          user-agent: *
          disallow: /admin
          allow: /public
        ROBOTS
      end

      it "handles lowercase directives correctly" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/admin",
               )).to be false
      end

      it "allows URLs matching allow directive with lowercase" do
        expect(described_class.allowed?(
                 robots_txt: robots_txt,
                 user_agent: "MyBot",
                 url: "https://example.com/public",
               )).to be true
      end

      it "handles mixed case directives" do
        mixed_case_robots = <<~ROBOTS
          USER-AGENT: *
          DISALLOW: /private
          ALLOW: /open
        ROBOTS

        expect(described_class.allowed?(
                 robots_txt: mixed_case_robots,
                 user_agent: "MyBot",
                 url: "https://example.com/private",
               )).to be false
      end

      it "allows URLs with mixed case allow directive" do
        mixed_case_robots = <<~ROBOTS
          USER-AGENT: *
          DISALLOW: /private
          ALLOW: /open
        ROBOTS

        expect(described_class.allowed?(
                 robots_txt: mixed_case_robots,
                 user_agent: "MyBot",
                 url: "https://example.com/open",
               )).to be true
      end
    end

    context "with edge cases and malformed URLs" do
      let(:robots_txt) do
        <<~ROBOTS
          User-agent: *
          Disallow: /admin
        ROBOTS
      end

      context "disallowed URLs" do
        it "disallows URLs with special characters" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/admin%20path",
                 )).to be false
        end

        it "disallows URLs with unicode characters" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/admin/café",
                 )).to be false
        end

        it "disallows URLs with trailing slashes" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/admin/",
                 )).to be false
        end

        it "disallows URLs with encoded characters" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com/admin%2Fpath",
                 )).to be false
        end
      end

      context "allowed URLs" do
        it "allows URLs with multiple slashes" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com//admin//",
                 )).to be true
        end

        it "allows empty string URLs" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "",
                 )).to be true
        end

        it "allows URLs with only domain" do
          expect(described_class.allowed?(
                   robots_txt: robots_txt,
                   user_agent: "MyBot",
                   url: "https://example.com",
                 )).to be true
        end
      end
    end

    context "error handling" do
      it "raises error when robots_txt is nil" do
        expect do
          described_class.allowed?(
            robots_txt: nil,
            user_agent: "MyBot",
            url: "https://example.com/",
          )
        end.to raise_error(ArgumentError)
      end

      it "raises error when user_agent is nil" do
        expect do
          described_class.allowed?(
            robots_txt: "User-agent: *",
            user_agent: nil,
            url: "https://example.com/",
          )
        end.to raise_error(ArgumentError)
      end

      it "raises error when url is nil" do
        expect do
          described_class.allowed?(
            robots_txt: "User-agent: *",
            user_agent: "MyBot",
            url: nil,
          )
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe ".valid?" do
    context "with valid robots.txt content" do
      it "returns true for basic valid robots.txt" do
        robots_txt = "User-agent: *\nDisallow: /admin"
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end

      it "returns true for empty robots.txt" do
        expect(described_class.valid?(robots_txt: "")).to be true
      end

      it "returns true for robots.txt with multiple user agents" do
        robots_txt = <<~ROBOTS
          User-agent: Googlebot
          Disallow: /search

          User-agent: *
          Disallow: /admin
        ROBOTS
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end

      it "returns true for robots.txt with Allow directives" do
        robots_txt = <<~ROBOTS
          User-agent: *
          Disallow: /admin
          Allow: /public
        ROBOTS
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end

      it "returns true for robots.txt with wildcard patterns" do
        robots_txt = <<~ROBOTS
          User-agent: *
          Disallow: /*.pdf$
          Disallow: /temp*
        ROBOTS
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end

      it "returns true for incomplete directives" do
        robots_txt = "User-agent:"
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end
    end

    context "with invalid robots.txt content" do
      it "returns false for robots.txt with only comments" do
        robots_txt = "# This is a comment\n# Another comment"
        expect(described_class.valid?(robots_txt: robots_txt)).to be false
      end

      it "returns false for nil input" do
        expect(described_class.valid?(robots_txt: nil)).to be false
      end

      it "returns false for malformed directives" do
        robots_txt = "Invalid-directive: value"
        expect(described_class.valid?(robots_txt: robots_txt)).to be false
      end
    end

    context "with edge cases" do
      it "handles very long robots.txt content" do
        robots_txt = "User-agent: *\n#{"Disallow: /path#{rand(1000)}\n" * 1000}"
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end

      it "handles robots.txt with unicode characters" do
        robots_txt = "User-agent: *\nDisallow: /café"
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end

      it "handles robots.txt with special characters" do
        robots_txt = "User-agent: *\nDisallow: /path with spaces"
        expect(described_class.valid?(robots_txt: robots_txt)).to be true
      end
    end
  end
end
