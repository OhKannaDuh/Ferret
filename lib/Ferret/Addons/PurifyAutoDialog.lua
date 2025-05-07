--------------------------------------------------------------------------------
--   DESCRIPTION: Addon for the PurifyAutoDialog
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

---@class PurifyAutoDialog : Addon
local PurifyAutoDialog = Addon:extend()

function PurifyAutoDialog:new()
    PurifyAutoDialog.super.new(self, 'PurifyAutoDialog')
end

function PurifyAutoDialog:check_for_exit()
    return self:get_node_text(2, 2) == i18n('basic.exit')
end

function PurifyAutoDialog:wait_for_exit()
    Ferret:wait_until(function()
        return self:check_for_exit()
    end)
end

function PurifyAutoDialog:exit()
    self:callback(true, 0)
end

return PurifyAutoDialog()
