# AllTheThings.Best Projects

Configs, firmware, 3D models and wiring for the smart home builds written up on [AllTheThings.Best](https://www.allthethings.best/). Each folder is one build: everything you need to copy it, plus a link to the post that explains why it is built that way.

These are things running in my own house, on Home Assistant and ESPHome.

## Builds

| Build | What it is | Write-up |
|---|---|---|
| [Halloween yard speakers](halloween-yard-speakers/) | ESP32 + NS4168 I2S amp as a Home Assistant media player, about $20 a zone, with a printable jack-o'-lantern case | [How I Built Cheap ESP32 Yard Speakers for Halloween Sound Effects](https://www.allthethings.best/how-i-built-cheap-esp32-yard-speakers-for-halloween-sound-effects/) |

## How each folder is laid out

- `README.md`: parts, wiring, quick start and troubleshooting
- `esphome/`: device YAML and a `secrets.example.yaml`
- `case/`: OpenSCAD source and STLs, where the build has a printed part
- `images/`: photos and diagrams

Secrets are never committed. Every config reads them from a `secrets.yaml` you create from the example file.

## Questions and fixes

Found a mistake, or got a build working on different hardware? Open an issue or a pull request.

## License

- **Code and configuration** (YAML, OpenSCAD source): [MIT](LICENSE).
- **Documentation, photos, diagrams and STL files**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Reuse them freely with credit and a link to [allthethings.best](https://www.allthethings.best/).
