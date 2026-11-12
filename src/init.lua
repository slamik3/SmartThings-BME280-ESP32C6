-- ============================================================
-- XIAO ESP32-C6 + BME280 Zigbee senzor
-- Autor: Matej Slama
--
-- Manufacturer: MatejSlama
-- Model: XIAO-C6-BME280
--
-- Endpoint 1:
--   TemperatureMeasurement  0x0402
--   RelativeHumidity        0x0405
--   PressureMeasurement     0x0403
--   PowerConfiguration      0x0001
--
-- Tlak:
--   Atribut 0x0000 - MeasuredValue (INT16)
--   Jednotka Zigbee: 0.1 kPa
--   1 jednotka = 1 hPa
-- ============================================================

local capabilities = require "st.capabilities"
local ZigbeeDriver = require "st.zigbee"
local defaults = require "st.zigbee.defaults"
local zcl_clusters = require "st.zigbee.zcl.clusters"

local PressureMeasurement = zcl_clusters.PressureMeasurement

-- Standardni atribut MeasuredValue
local PRESSURE_ATTR = 0x0000

-- ============================================================
-- TLAK
-- ============================================================

local function pressure_handler(driver, device, value, zb_rx)

    local hpa = value.value

    -- Zigbee hodnota 973 = 973 hPa = 97.3 kPa
    local kpa = hpa / 10.0

    device.log.info(
        string.format(
            "XIAO BME280 - Tlak: %.1f hPa (%.2f kPa)",
            hpa,
            kpa
        )
    )

    device:emit_event(
        capabilities.atmosphericPressureMeasurement.atmosphericPressure({
            value = kpa,
            unit = "kPa"
        })
    )
end

-- ============================================================
-- DRIVER TEMPLATE
-- ============================================================

local driver_template = {

    supported_capabilities = {
        capabilities.temperatureMeasurement,
        capabilities.relativeHumidityMeasurement,
        capabilities.atmosphericPressureMeasurement,
        capabilities.battery,
    },

    zigbee_handlers = {

        attr = {

            [PressureMeasurement.ID] = {

                [PRESSURE_ATTR] = pressure_handler,

            },

        },

    },
}

-- ============================================================
-- VYCHOZI HANDLERY SMARTTHINGS
-- ============================================================

defaults.register_for_default_handlers(
    driver_template,
    driver_template.supported_capabilities
)

-- ============================================================
-- SPUSTENI DRIVERU
-- ============================================================

local driver = ZigbeeDriver(
    "xiao-bme280",
    driver_template
)

driver:run()
