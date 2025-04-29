return {
    en = {
        actions = {
            messages = {
                executing = 'Executing action: %{action}',
            },
            materia_extraction = 'Materia Extraction',
            repair = 'Repair',
        },
        addons = {
            messages = {
                wait_until_ready = 'Waiting for addon to be ready: %{addon}',
                ready = 'Addon ready: %{addon}',
                wait_unitl_visible = 'Waiting for addon to be visible: %{addon}',
                visible = 'Addon visible: %{addon}',
            },
        },
        npcs = {
            researchingway = 'Researchingway',
        },
        jobs = {
            unknown = 'Unknown',
            carpenter = 'Carpenter',
            blacksmith = 'Blacksmith',
            armorer = 'Armorer',
            goldsmith = 'Goldsmith',
            leatherworker = 'Leatherworker',
            weaver = 'Weaver',
            alchemist = 'Alchemist',
            culinarian = 'Culinarian',
            miner = 'Miner',
            botanist = 'Botanist',
            fisher = 'Fisher',
        },
        ferret = {
            initialising = 'Initialising',
            running_setup = 'Running Setup',
            stopping = 'Stopping',
            no_setup = 'No setup defined',
            no_loop = 'No loop defined',
            setup_error = 'An error cocured during setup',
            starting_loop = 'Starting Ferret loop',
            hook_subscription = 'Regsitering callback to hook: %{hook}',
            emit_event = 'Emitting Event: %{event}',
            callback = 'Callback: %{command}',
        },
        modules = {
            cosmic_exploration = {
                wks_mission = {
                    open_basic = 'Opening basic mission ui',
                    open_critical = 'Opening critical mission ui',
                    open_provisional = 'Opening provisional mission ui',
                    getting_missions = 'Getting missions from mission list:',
                    mission_found = 'Mission found: %{mission}',
                    mission_not_found = 'Mission not found or for a different job: %{mission}',
                    blacklisted = 'Mission %{mission} is blacklisted.',
                    not_blacklisted = 'Mission %{mission} is not blacklisted.',
                },
                mission = {
                    waiting_for_crafting_ui_or_mission_complete = 'Waiting for Crafting ui or mission complete',
                    crafting_ui_or_mission_complete = 'Finished waiting for Crafting ui or Mission complete',
                    recipe_count = {
                        one = '%{count} recipe',
                        other = '%{count} recipes',
                    },
                    recipe_index = 'Setting recipe index to %{index}',
                    crafting = 'Crafting (%{index}/%{count})',
                    starting_mission = 'Starting mission: %{mission}',
                },
            },
        },
        plugins = {
            messages = {
                no_init = 'No init set for this plugin: %{name}',
            },
            crafting_consumables = {
                pre_craft_start = 'Checking crafting consumables',
                eating_food = 'Eating food: %{food}',
                food_above_time = 'Food buff remaining is more than %{time}',
                drinking_medicine = 'Drinking medicine: %{medicine}',
                medicine_above_time = 'Medicine buff remaining is more than %{time}',
            },
            extract_materia = {
                check = 'Checking if materia needs to be extracted',
                not_needed = 'Materia does not need to be extracted',
                extracting = 'Extracting materia',
                done = 'Finished extracting materia',
            },
            repair = {
                check = 'Checking if gear needs repairing',
                not_needed = 'Gear does not need repairing',
                repairing = 'Reparing gear',
                done = 'Finished repairing gear',
            },
        },
        templates = {
            stellar_crafting_relic = {
                name = 'Stellar Crafting Relic',
                maxed = 'All relics at rank 9! Exiting.',
                failed_to_get_mission = 'Failed to get mission.',
                mission_failed = 'Mission failed: %{mission}',
                mission = 'Mission: %{mission}',
                mission_blacklisting = 'Blacklisting mission: %{mission}',
                mission_complete = 'Mission complete.',
                checking_relic_ranks = 'Checking relic ranks.',
                checking_relic_exp = 'Checking relic exp.',
            },
            stellar_missions = {
                name = 'Stellar Mission Farming',
            },
        },
    },
}
