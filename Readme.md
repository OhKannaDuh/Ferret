# Ferret

A Lua library to be used with https://github.com/Jaksuhn/SomethingNeedDoing
Plugin repository: https://raw.githubusercontent.com/OhKannaDuh/plugins/refs/heads/master/manifest.json

The goal is to make interacting with the game and the APIs SND provides easier.

**Currently you will need to be on the testing version of SND (12.0)**
https://goatcorp.github.io/faq/dalamud_troubleshooting.html#q-how-do-i-enable-plugin-test-builds

## Installation (Plugin)

This is the easiest way to install Ferret and stay up to date. Add the [repository](https://raw.githubusercontent.com/OhKannaDuh/plugins/refs/heads/master/manifest.json) to your Custom Plugin Repository list in Dalamud `/xlsettings` -> Experimental. Then open your plugin browser and look for Ferret.

Open Ferret's settings and copy the lib path into SND (See where to put this below)

The plugin also comes with a ui `/ferret` to help you create script configs.

## Installation (Download or Clone)

Download or clone the github repository, and extract it somewhere if you downloaded it.

Copy the path to the lib folder.

## Adding the library to SND

Once you have your path from the source above:
- Open the main SND window (The window where you manage all your scripts and macros)
  - Click the `?` (Help) icon, this will bring up another window
  - Click the `Options` tab
  - Expand the `Lua` section
  - Add your ferret path to the required path list
- You can now use Ferret

## Reporting an issue

Please provide as much information as you can with your report, with the debug output from Ferret.
The best way to get your issue noticed and not lost among messages is by submitting an issue on Github: https://github.com/OhKannaDuh/Ferret/issues/new
