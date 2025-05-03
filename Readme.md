# Ferret

A Lua library to be used with https://github.com/Jaksuhn/SomethingNeedDoing
The goal is to make interacting with the game and the APIs SND proides easier.

**Currently you will need to be on the testing version of SND (12.0)**
https://goatcorp.github.io/faq/dalamud_troubleshooting.html#q-how-do-i-enable-plugin-test-builds

## Installation

- Download or clone the Github repository linked above.
  - If you've downloaded the zip, extract it somewhere on your computer.
- Get the path to the folder that contains your copy of Ferret, example:
  - My path to `Ferret.lua` is `C:/ferret/Ferret/Ferret.lua` So the path I will need is `C:/ferret`.
  - Please not if you use backslashes in your path, you will need to double them up. `C:\\ferret`
- Add this path to SND.
  - Open the main SND window (The window where you manage all your scripts and macros)
  - Click the `?` (Help) icon, this will bring up another window
  - Click the `Options` tab
  - Expand the `Lua` section
  - Add your ferret path to the required path list
- You can now use Ferret

## Reporting an issue

Please provide as much information as you can with your report, with the debug output from Ferret.
The best way to get your issue noticed and not lost among messages is by submitting an issue on Github: https://github.com/OhKannaDuh/Ferret/issues/new

## Templates

- [Stellar Mission Farming](https://github.com/OhKannaDuh/Ferret/wiki/Stellar-Missions-Template) - Farm specific Stellar Missions (Crafting)
- [Stellar Crafting Relic Automation](https://github.com/OhKannaDuh/Ferret/wiki/Stellar-Crafting-Relic-Template) - Farm the optimal mission to get your

```
local stellar_missions = require("Ferret/Templates/StellarMissions") --example
require("Ferret/Extensions/ExtractMateria") -- extensions are auto registered
require("Ferret/Extensions/Repair")
```
