# Security Policy

## Supported Versions

We provide security updates for the following versions of robotstxt-rb:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability in robotstxt-rb, please report it responsibly.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please use one of the following methods:

1. **GitHub Security Advisories** (Recommended):
   - Go to the [Security tab](https://github.com/jacksontrieu/robotstxt-rb/security) in this repository
   - Click "Report a vulnerability"
   - Follow the instructions to create a private security advisory

2. **Direct Contact**:
   - Create a new issue with the "security" label
   - Mark it as private if possible
   - Include detailed information about the vulnerability

### What to Include

When reporting a security vulnerability, please include:

- **Description** of the vulnerability
- **Steps to reproduce** the issue
- **Potential impact** of the vulnerability
- **Suggested fix** (if you have one)
- **Your contact information** for follow-up questions

### What to Expect

1. **Acknowledgment**: We will acknowledge receipt of your report within 48 hours
2. **Investigation**: We will investigate the vulnerability promptly
3. **Updates**: We will provide regular updates on our progress
4. **Resolution**: We will work to fix the vulnerability and release an update
5. **Credit**: We will credit you in our security advisories (unless you prefer to remain anonymous)

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 1 week
- **Resolution**: As quickly as possible, typically within 30 days
- **Public Disclosure**: After a fix is available and tested

## Security Best Practices

### For Users

1. **Keep Updated**: Always use the latest version of robotstxt-rb
2. **Validate Input**: Always validate robots.txt content before processing
3. **Handle Errors**: Implement proper error handling for malformed input
4. **Monitor Dependencies**: Keep your Ruby and gem dependencies updated

### For Developers

1. **Input Validation**: The gem validates input parameters, but additional validation may be needed in your application
2. **Error Handling**: Always handle potential errors from the gem methods
3. **Testing**: Test with various robots.txt formats, including malformed content
4. **Security Scanning**: Use tools like `bundler-audit` to check for known vulnerabilities

### Example Secure Usage

```ruby
require 'robotstxt-rb'

def safe_check_url(robots_txt, user_agent, url)
  # Validate inputs
  return false unless robots_txt.is_a?(String)
  return false unless user_agent.is_a?(String) && !user_agent.empty?
  return false unless url.is_a?(String) && !url.empty?

  begin
    # Check if robots.txt is valid first
    return true unless RobotstxtRb.valid?(robots_txt: robots_txt)

    # Check URL access
    RobotstxtRb.allowed?(
      robots_txt: robots_txt,
      user_agent: user_agent,
      url: url
    )
  rescue ArgumentError, StandardError => e
    # Log error and handle gracefully
    Rails.logger.error "Robots.txt check failed: #{e.message}"
    false
  end
end
```

## Known Security Considerations

### Input Validation

- The gem validates that required parameters are not `nil`
- Malformed robots.txt content is handled gracefully
- Very large inputs may cause memory issues (consider implementing size limits)

### Native Library Security

- The gem uses pre-compiled native libraries
- These libraries are built from Google's official robots.txt parser
- No arbitrary code execution is possible through the FFI interface

### Memory Safety

- The native C++ library handles memory management
- Ruby FFI provides safe memory boundaries
- No direct memory access from Ruby code

## Security Updates

Security updates will be released as:

- **Patch versions** (e.g., 1.0.1) for critical security fixes
- **Minor versions** (e.g., 1.1.0) for security improvements
- **Major versions** (e.g., 2.0.0) for breaking security changes

## Disclosure Policy

We follow responsible disclosure practices:

1. **Private Reporting**: Vulnerabilities are reported privately first
2. **Coordinated Release**: We coordinate with reporters on disclosure timing
3. **Public Advisory**: We publish security advisories after fixes are available
4. **CVE Assignment**: We work to assign CVEs for significant vulnerabilities

## Contact

For security-related questions or concerns:

- **GitHub Issues**: Use the "security" label
- **Repository**: [jacksontrieu/robotstxt-rb](https://github.com/jacksontrieu/robotstxt-rb)

## Acknowledgments

We thank all security researchers who responsibly report vulnerabilities to help keep robotstxt-rb and its users safe.

## License

This security policy is part of the robotstxt-rb project and is subject to the same [Apache 2.0 License](LICENSE) as the main project.
