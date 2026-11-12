# XIAO ESP32-C6 BME280 – SmartThings Edge Driver

Vlastní Zigbee Edge Driver pro senzor založený na **Seeed Studio XIAO ESP32-C6** a senzoru **Bosch BME280**.

Driver umožňuje připojit vlastní senzor k platformě Samsung SmartThings bez cloudového prostředníka. Komunikace probíhá přes Zigbee a zpracování zajišťuje SmartThings Edge Driver na hubu.

## Funkce

- Měření teploty (°C)
- Měření relativní vlhkosti (%)
- Měření atmosférického tlaku (kPa)
- Zobrazení stavu baterie (%)
- Zigbee End Device (ZED)
- Vlastní identifikace zařízení

## Hardware

| Komponenta | Použití |
|---|---|
| Seeed Studio XIAO ESP32-C6 | Mikrokontrolér a Zigbee |
| Bosch BME280 | Teplota, vlhkost, tlak |
| Zigbee SmartThings Hub | Připojení do SmartThings |

## Identifikace zařízení

| Parametr | Hodnota |
|---|---|
| Manufacturer | `MatejSlama` |
| Model | `XIAO-C6-BME280` |
| Endpoint | `1` |
| Zigbee režim | End Device (ZED) |

## Zigbee clustery

| Cluster | ID | Funkce |
|---|---:|---|
| TemperatureMeasurement | `0x0402` | Teplota |
| RelativeHumidity | `0x0405` | Vlhkost |
| PressureMeasurement | `0x0403` | Atmosférický tlak |
| PowerConfiguration | `0x0001` | Baterie |

Tlak využívá standardní atribut `MeasuredValue (0x0000)` typu INT16. Firmware odesílá hodnotu v hPa a Edge Driver ji převádí na kPa pro SmartThings.

## Struktura projektu

```text
xiao-bme280/
├── config.yml
├── fingerprints.yml
├── profiles/
│   └── xiao-bme280.yml
└── src/
    └── init.lua
```

## Požadavky

- SmartThings Hub s podporou Edge Drivers
- Samsung SmartThings účet
- Windows 10/11, Linux nebo macOS
- SmartThings CLI
- Přístup k SmartThings API

## 1. Instalace SmartThings CLI

### Windows

Stáhněte instalační balíček MSI z oficiálního GitHub repozitáře:

https://github.com/SmartThingsCommunity/smartthings-cli/releases

Spusťte instalační soubor a dokončete instalaci.

Ověření instalace:

```powershell
smartthings --version
```

### Přihlášení

Spusťte:

```powershell
smartthings devices
```

Při prvním použití CLI otevře přihlašovací okno pro autorizaci SmartThings účtu.

CLI podporuje také osobní přístupový token (PAT), ale doporučuje se automatické přihlášení přes prohlížeč.

## 2. Kontrola konfigurace

Přejděte do adresáře driveru:

```powershell
cd C:\cesta\xiao-bme280
```

Ověřte soubory:

```powershell
Get-ChildItem -Recurse
```

## 3. Zabalení a nahrání driveru

V kořenovém adresáři projektu spusťte:

```powershell
smartthings edge:drivers:package .
```

CLI vytvoří balíček a nahraje driver do SmartThings Cloudu.

## 4. Vytvoření SmartThings Edge kanálu

Pokud ještě nemáte vlastní kanál:

```powershell
smartthings edge:channels:create
```

Postupujte podle otázek CLI.

## 5. Připojení hubu ke kanálu

```powershell
smartthings edge:channels:enroll
```

Vyberte požadovaný hub a kanál.

## 6. Přiřazení driveru ke kanálu

```powershell
smartthings edge:channels:assign
```

Vyberte nahraný driver a jeho verzi.

## 7. Instalace driveru do hubu

```powershell
smartthings edge:drivers:install
```

Vyberte správný hub a driver.

## 8. Přepnutí existujícího zařízení na driver

Pokud už je senzor spárovaný a chcete změnit jeho driver:

```powershell
smartthings edge:drivers:switch DEVICE_ID
```

Místo `DEVICE_ID` vložte ID svého Zigbee zařízení.

Není nutné senzor znovu párovat.

## 9. Sledování logů

Výpis dostupných driverů:

```powershell
smartthings edge:drivers
```

Sledování logů konkrétního driveru:

```powershell
smartthings edge:drivers:logcat DRIVER_ID
```

Ukončení sledování:

```text
Ctrl + C
```

## 10. Kontrola naměřených hodnot

```powershell
smartthings devices:status DEVICE_ID
```

Očekávané atributy:

- `temperatureMeasurement.temperature`
- `relativeHumidityMeasurement.humidity`
- `atmosphericPressureMeasurement.atmosphericPressure`
- `battery.battery`

## Aktualizace driveru

Po změně Lua kódu nebo profilu:

```powershell
smartthings edge:drivers:package .
```

Následně je potřeba novou verzi přiřadit ke kanálu a nainstalovat do hubu.

Pro automatické přiřazení a instalaci lze využít:

```powershell
smartthings edge:drivers:package . --install
```

CLI se zeptá na potřebný kanál a hub, případně použije již uložené výchozí hodnoty.

## Bezpečnost

- Nikdy nevkládejte PAT token do veřejného repozitáře.
- Nezveřejňujte osobní ID hubu, zařízení ani přístupové údaje.
- Nepřidávejte konfigurační soubory obsahující osobní přístupové tokeny.

## Autor

**Matěj Sláma**

Vlastní vývoj Zigbee senzoru a SmartThings Edge Driveru.

Hardware: Seeed Studio XIAO ESP32-C6 + Bosch BME280.

Platforma: Samsung SmartThings Edge.

---

Projekt je určen pro vlastní použití a další rozvoj.
