#include <string>
#include <stdexcept>
#include <cstring>

#include "robots.h"
#include "reporting_robots.h"  // Optional, only if using Option 2 for is_valid

extern "C" {

int robots_is_allowed(const char* robots_txt, const char* user_agent, const char* url) {
  try {
    const std::string ua = user_agent ? user_agent : "";
    const std::string robots = robots_txt ? robots_txt : "";
    const std::string u = url ? url : "";

    googlebot::RobotsMatcher matcher;
    bool allowed = matcher.OneAgentAllowedByRobots(robots, ua, u);
    return allowed ? 1 : 0;
  } catch (...) {
    return 0;
  }
}

int robots_is_valid(const char* robots_txt) {
  try {
    const std::string robots = robots_txt ? robots_txt : "";

    // Empty robots.txt is considered valid (allows all access)
    if (robots.empty()) {
      return 1;
    }

    googlebot::RobotsParsingReporter reporter;
    googlebot::ParseRobotsTxt(robots, &reporter);

    // Return true if we found at least one valid directive
    return reporter.valid_directives() > 0 ? 1 : 0;
  } catch (...) {
    return 0;
  }
}

} // extern "C"
