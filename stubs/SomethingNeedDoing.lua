-- Object definitions

--- @class ActionWrapper
--- @field AdjustableActionId number
--- @field RecastTimeElapsed number
--- @field RealRecastTimeElapsed number
--- @field SpellCooldown number
--- @field RealSpellCooldown number

--- @class LimitBreakWrapper
--- @field CurrentUnits number
--- @field BarUnits number
--- @field BarCount number

--- @class AtkValueWrapper
--- @field ValueString string

--- @alias NodeType
---| 1 # Res
---| 2 # Image
---| 3 # Text
---| 4 # NineGrid
---| 5 # Counter
---| 8 # Collision
---| 10 # ClippingMask
---| 10000 # Component

--- @class NodeWrapper
--- @field Id number
--- @field IsVisible boolean
--- @field Text string
--- @field NodeType NodeType

--- @class AddonWrapper
--- @field Exists boolean
--- @field Ready boolean
--- @field AtkValues table<AtkValueWrapper>
--- @field Nodes table<NodeWrapper>
--- @field GetAtkValue fun(id: number): AtkValueWrapper
--- @field GetNode fun(idPath: number[]): NodeWrapper

--- @alias ObjectKind number
---| 0  # None - Invalid character.
---| 1  # Player - Player character.
---| 2  # BattleNpc - Battle NPC.
---| 3  # EventNpc - Event NPC.
---| 4  # Treasure - Treasure object.
---| 5  # Aetheryte - Aetheryte.
---| 6  # GatheringPoint - Gathering point.
---| 7  # EventObj - Event object.
---| 8  # MountType - Mount.
---| 9  # Companion - Minion.
---| 10 # Retainer - Retainer.
---| 11 # Area - Area object.
---| 12 # Housing - Housing object.
---| 13 # Cutscene - Cutscene object.
---| 14 # CardStand - Card stand.
---| 15 # Ornament - Fashion accessory (Ornament).

--- @class Vector3
--- @field X number
--- @field Y number
--- @field Z number

--- @class EntityWrapper
--- @field Type ObjectKind
--- @field Name string
--- @field Position Vector3
--- @field DistanceTo number
--- @field ContentId number
--- @field AccountId number
--- @field CurrentWorld number
--- @field HomeWorld number
--- @field CurrentHp number
--- @field MaxHp number
--- @field Target EntityWrapper
--- @field IsCasting boolean
--- @field IsCastInterruptable boolean
--- @field IsInCombat boolean
--- @field HuntRank number
--- @field SetAsTArget fun(): nil
--- @field SetAsFocusTarget fun(): nil
--- @field ClearTarget fun(): nil

--- @class ExcelRowWrapper

--- @class ExcelSheetWrapper
--- @field GetRow fun(id: number): ExcelRowWrapper
--- @field GetSubRow fun(id: number, subId: number): ExcelRowWrapper

-- Function definitions

--- @class Actions
--- @field ExecuteAction fun(id: number, type: number): nil
--- @field ExecuteGeneralAction fun(id: number): nil
--- @field Teleport fun(id: number): nil
--- @field CancelCast fun(): nil
--- @field GetActionInfo fun(id: number): ActionWrapper
--- @field LimitBreak LimitBreakWrapper

--- @class Addons
--- @field GetAddon fun(name: string): AddonWrapper

--- @class Dalamud
--- @field Log fun(message: string | table): nil
--- @field LogDebug fun(message: string | table): nil
--- @field LogVerbose fun(message: string | table): nil

--- @class Entity
--- @field GetPartyMember fun(): EntityWrapper
--- @field GetAllianceMember fun(): EntityWrapper
--- @field GetEntityByName fun(name: string): EntityWrapper
--- @field Target EntityWrapper
--- @field FocusTarget EntityWrapper
--- @field NearestDeadCharacter EntityWrapper

--- @class Excel
--- @field GetSheet fun(name: string): ExcelSheetWrapper
--- @field GetRow fun(sheetName: string, id: number): ExcelRowWrapper
--- @field GetSubRow fun(sheetName: string, id: number, subId: number): ExcelRowWrapper
--- @field __index ExcelSheetWrapper
