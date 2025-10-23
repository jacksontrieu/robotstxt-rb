#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Return 1 if allowed, 0 if disallowed.
// robots_txt: entire robots.txt content
// user_agent: UA string to test (e.g., "MyBot")
// url: absolute path or URL to check (depending on underlying API)
int robots_is_allowed(const char* robots_txt, const char* user_agent, const char* url);

// Return 1 if the robots_txt parsed without fatal error, else 0.
int robots_is_valid(const char* robots_txt);

#ifdef __cplusplus
}
#endif
