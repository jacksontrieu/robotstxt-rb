# Contributing to robotstxt-rb

Thank you for your interest in contributing to robotstxt-rb! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Testing](#testing)
- [Code Style](#code-style)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## How to Contribute

### Reporting Issues

Before creating an issue, please check if it has already been reported:

1. Search existing [issues](https://github.com/jacksontrieu/robotstxt-rb/issues)
2. Check if your issue is already resolved in the latest version

When creating a new issue, please include:

- **Clear description** of the problem
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Environment details** (Ruby version, OS, gem version)
- **Minimal code example** if applicable

### Requesting Features

Feature requests are welcome! Please include:

- **Use case** and motivation
- **Proposed solution** or API design
- **Alternatives considered**
- **Additional context** or examples

### Pull Requests

We welcome pull requests! Please follow these guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Make** your changes
4. **Add** tests for new functionality
5. **Ensure** all tests pass
6. **Update** documentation if needed
7. **Commit** your changes (`git commit -m 'Add amazing feature'`)
8. **Push** to your branch (`git push origin feature/amazing-feature`)
9. **Open** a Pull Request

## Development Setup

### Prerequisites

- Ruby 2.0 or higher
- Bundler
- Git

### Installation

1. **Clone** your fork:
```bash
git clone https://github.com/YOUR_USERNAME/robotstxt-rb.git
cd robotstxt-rb
```

2. **Install** dependencies:
```bash
bundle install
```

3. **Verify** setup by running tests:
```bash
bundle exec rspec
```

### Project Structure

```
robotstxt-rb/
├── lib/                    # Main library code
│   ├── robotstxt-rb.rb    # Public API
│   └── robotstxt-rb/      # Internal modules
├── spec/                   # Test files
├── native/                 # Pre-compiled native libraries
├── Gemfile                 # Dependencies
├── robotstxt-rb.gemspec   # Gem specification
└── README.md              # Documentation
```

## Testing

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run specific test file
bundle exec rspec spec/robotstxt_rb_spec.rb

# Run tests matching a pattern
bundle exec rspec --grep "allowed"
```

### Test Coverage

We aim for high test coverage. When adding new features:

1. **Write tests first** (TDD approach)
2. **Test edge cases** and error conditions
3. **Ensure backward compatibility**
4. **Update existing tests** if behavior changes

### Test Structure

Tests are organized by method and functionality:

- `RobotstxtRb.allowed?` - URL access checking
- `RobotstxtRb.valid?` - Content validation
- Error handling and edge cases
- Platform-specific behavior

## Code Style

### Ruby Style

We follow standard Ruby conventions:

- **2 spaces** for indentation
- **No trailing whitespace**
- **Meaningful variable names**
- **Consistent method naming**
- **Clear comments** for complex logic

### Documentation

- **Document public methods** with clear descriptions
- **Include parameter types** and return values
- **Provide usage examples** in comments
- **Update README** for new features

### Git Commit Messages

Use clear, descriptive commit messages:

```
Add support for wildcard patterns in robots.txt parsing

- Implement regex pattern matching for Disallow directives
- Add tests for various wildcard scenarios
- Update documentation with examples
```

## Pull Request Process

### Before Submitting

1. **Ensure tests pass** locally
2. **Check code style** and formatting
3. **Update documentation** if needed
4. **Squash commits** if necessary
5. **Write clear PR description**

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] New tests added for new functionality
- [ ] All existing tests still pass

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
```

### Review Process

1. **Automated checks** must pass
2. **Code review** by maintainers
3. **Discussion** of any requested changes
4. **Approval** and merge

## Reporting Issues

### Bug Reports

Use the [GitHub issue tracker](https://github.com/jacksontrieu/robotstxt-rb/issues) with the "bug" label.

### Security Issues

For security vulnerabilities, please see our [Security Policy](SECURITY.md).

## Questions?

If you have questions about contributing:

1. **Check existing issues** and discussions
2. **Open a new issue** with the "question" label
3. **Contact maintainers** via GitHub

## Recognition

Contributors will be recognized in:

- **CHANGELOG.md** for significant contributions
- **README.md** contributors section (if applicable)
- **Release notes** for major features

Thank you for contributing to robotstxt-rb! 🚀
