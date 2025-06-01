---@class Object
---@field extend function
---@field implement function
---@field is function
---@field __tostring function
---@field __call function
---@field super Object
---@field new fun(Object, ...)
Object = require('external/classic')

i18n = require('external/i18n/init')
i18n.setLocale(_language or 'en')
i18n.load(require('Ferret/i18n/translations'))

require('Ferret/Helpers')
require('Ferret/Modules/Module')

-- Mixins
require('Ferret/Mixins/Translation')

-- Data enums and objects
require('Ferret/Data/Translatable')
require('Ferret/Data/Conditions')
require('Ferret/Data/Events')
require('Ferret/Data/Requests')
require('Ferret/Data/Jobs')
require('Ferret/Data/Name')
require('Ferret/Data/Objects')
require('Ferret/Data/Status')
require('Ferret/Data/Weather')
require('Ferret/Data/Version')
require('Ferret/Data/Node')
require('Ferret/Data/GatheringActions')

-- Managers
EventManager = require('Ferret/EventManager')
RequestManager = require('Ferret/RequestManager')
ExtensionManager = require('Ferret/ExtensionManager')

-- Other classes
require('Ferret/Targetable')
require('Ferret/Timer')
require('Ferret/Sandtimer')
require('Ferret/Pathfinding')

require('Ferret/Extensions/Extension')

require('Ferret/Addons/Addon')
AddonMixins = {}
Addons = {}

require('Ferret/Actions/Actions')

-- Static objects

-- Move to Core Module
Character = require('Ferret/Character')
Mount = require('Ferret/Mount')
World = require('Ferret/World')
IO = require('Ferret/IO')
Logger = require('Ferret/Logger')
Debug = require('Ferret/Debug')
Table = require('Ferret/Table')
String = require('Ferret/String')
Wait = require('Ferret/Wait')

-- Move to Gathering Module
Gathering = require('Ferret/Gathering')
GatherBuddy = require('Ferret/GatherBuddy')
SpearfishingHelper = require('Ferret/SpearfishingHelper')

-- Move to PandorasBox or IPC Module
PandorasBox = require('Ferret/PandorasBox')
