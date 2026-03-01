---
title: ESP-IDF Development Patterns
description: >-
  Component structure, FreeRTOS patterns, sdkconfig,
  and idf.py build system reference for ESP-IDF projects
created: 2026-03-01
category: reference
version: 1.0.0
see-also: platformio-patterns.md
---

# ESP-IDF Development Patterns

## Project Structure

```
project/
  CMakeLists.txt              # Top-level: cmake_minimum_required + project()
  sdkconfig                   # Generated menuconfig output
  sdkconfig.defaults          # Committed defaults
  main/
    CMakeLists.txt            # idf_component_register(SRCS ... INCLUDE_DIRS ...)
    main.c                    # app_main() entry point
  components/
    <component_name>/
      CMakeLists.txt          # idf_component_register(...)
      include/
        <component_name>.h
      src/
        <component_name>.c
      test/
        test_<component_name>.c
  test/
    CMakeLists.txt
```

## Component CMakeLists.txt

```cmake
idf_component_register(
    SRCS "src/emv_filter.c"
    INCLUDE_DIRS "include"
    REQUIRES driver esp_timer
    PRIV_REQUIRES unity
)
```

## FreeRTOS Patterns

### Task Creation

```c
static void sensor_task(void *pvParameters) {
    while (1) {
        // Read sensor
        vTaskDelay(pdMS_TO_TICKS(100));
    }
}

xTaskCreate(sensor_task, "sensor", 4096, NULL, 5, &sensor_task_handle);
```

### Queue Communication

```c
QueueHandle_t data_queue = xQueueCreate(10, sizeof(sensor_data_t));

// Producer
xQueueSend(data_queue, &data, pdMS_TO_TICKS(100));

// Consumer
sensor_data_t received;
if (xQueueReceive(data_queue, &received, portMAX_DELAY) == pdTRUE) {
    process(received);
}
```

### Event Groups

```c
EventGroupHandle_t events = xEventGroupCreate();
#define WIFI_CONNECTED BIT0
#define DATA_READY     BIT1

// Signal
xEventGroupSetBits(events, WIFI_CONNECTED);

// Wait
EventBits_t bits = xEventGroupWaitBits(events,
    WIFI_CONNECTED | DATA_READY, pdTRUE, pdTRUE, portMAX_DELAY);
```

## Error Handling

```c
esp_err_t result = some_function();
if (result != ESP_OK) {
    ESP_LOGE(TAG, "Failed: %s", esp_err_to_name(result));
    return result;
}

// Or for fatal errors:
ESP_ERROR_CHECK(some_critical_function());
```

## Build Commands

```bash
idf.py set-target esp32s3     # Set target chip
idf.py menuconfig             # Interactive configuration
idf.py build                  # Build project
idf.py flash monitor          # Flash and open serial monitor
idf.py size-components        # Component size analysis
```

## sdkconfig.defaults

Commit `sdkconfig.defaults` (not `sdkconfig`) with project-specific overrides:

```ini
CONFIG_FREERTOS_HZ=1000
CONFIG_ESP_SYSTEM_EVENT_TASK_STACK_SIZE=4096
CONFIG_LOG_DEFAULT_LEVEL_INFO=y
CONFIG_PARTITION_TABLE_CUSTOM=y
CONFIG_PARTITION_TABLE_CUSTOM_FILENAME="partitions.csv"
```

## References

- [ESP-IDF Programming Guide](https://docs.espressif.com/projects/esp-idf/en/latest/)
- [ESP-IDF Build System](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/build-system.html)
