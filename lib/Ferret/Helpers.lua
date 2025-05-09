--------------------------------------------------------------------------------
--   DESCRIPTION: A list of helper functions
--        AUTHOR: Faye (OhKannaDuh)
--------------------------------------------------------------------------------

function module_require(module, file)
    return require('Ferret/Modules/' .. module .. '/' .. file)
end

function load_module(module)
    return module_require(module, module)
end
