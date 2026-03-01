---
title: PlatformIO Development Patterns
description: >-
  platformio.ini configuration, pio commands, and
  library management for PlatformIO-based firmware projects
created: 2026-03-01
category: reference
version: 1.0.0
see-also: esp-idf-patterns.md
---

# PlatformIO Development Patterns

## Project Structure

```
project/
  platformio.ini              # Project configuration
  src/
    main.c                    # Entry point
  include/
    config.h
  lib/
    <library_name>/
      library.json
      src/
      include/
  test/
    test_<module>/
      test_main.c
```

## platformio.ini

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = espidf
monitor_speed = 115200
build_flags =
    -DCONFIG_LOG_DEFAULT_LEVEL=3
    -std=c11
check_tool = cppcheck
check_flags =
    cppcheck: --addon=misra.py --std=c11 --enable=all

[env:native]
platform = native
build_flags = -std=c11
test_framework = unity
```

## CLI Commands

```bash
# Build
pio run                           # Build default environment
pio run -e esp32dev               # Build specific environment
pio run -t clean                  # Clean build

# Upload and monitor
pio run -t upload                 # Flash firmware
pio device monitor                # Serial monitor
pio run -t upload && pio device monitor  # Flash + monitor

# Testing
pio test                          # Run all tests
pio test -e native                # Run native tests only
pio test -f test_emv_filter       # Run specific test

# Static analysis
pio check                         # Run configured check_tool
pio check --fail-on-defect=high   # Fail on high severity

# Library management
pio pkg install "library_name"    # Install library
pio pkg list                      # List installed libraries
pio pkg update                    # Update all libraries
```

## Library Management

### Private Libraries (lib/)

Place custom libraries in `lib/` with a `library.json`:

```json
{
  "name": "emv_filter",
  "version": "1.0.0",
  "frameworks": ["espidf"],
  "platforms": ["espressif32"]
}
```

### External Dependencies

In `platformio.ini`:

```ini
lib_deps =
    bblanchon/ArduinoJson@^7.0
    esp-idf-lib/esp_idf_lib_helpers
```

## Multi-Environment Builds

```ini
[platformio]
default_envs = esp32dev

[common]
build_flags = -std=c11 -Wall -Wextra
check_tool = cppcheck

[env:esp32dev]
extends = common
platform = espressif32
board = esp32dev
framework = espidf

[env:esp32s3]
extends = common
platform = espressif32
board = esp32-s3-devkitc-1
framework = espidf
```

## References

- [PlatformIO Documentation](https://docs.platformio.org/en/latest/)
- [PlatformIO ESP-IDF integration](https://docs.platformio.org/en/latest/frameworks/espidf.html)
