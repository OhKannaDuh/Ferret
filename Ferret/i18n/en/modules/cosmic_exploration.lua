return {
    messages = {
        job_list = 'Setting up job list for %{job}',
        registering_callbacks = 'Registering Cosmic Exploration request callbacks',
    },
    wks_mission = {
        open = 'Opening mission ui',
        open_basic = 'Opening basic mission ui',
        open_critical = 'Opening critical mission ui',
        open_provisional = 'Opening provisional mission ui',
        getting_missions = 'Getting missions from mission list:',
        mission_found = 'Mission found: %{mission}',
        mission_not_found = 'Mission not found or for a different job: %{mission}',
        blacklisted = 'Mission %{mission} is blacklisted.',
        not_blacklisted = 'Mission %{mission} is not blacklisted.',
    },
    wks_mission_information = {
        report = 'Reporting mission',
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
        crafting_current = 'Crafting currently selected recipe (%{name}).',
        not_craftable = 'Cannot craft recipe',
        timeout = 'Too much time has passed since the last detected crafting action',
        finished_craft = 'Finished Craft',
        finished = 'Finished, crafted: %{crafted}',
        no_more_to_craft = 'No more to craft, crafted: %{crafted}',
        reached_goal = 'Reached goal, crafted: %{crafted}',
        reason = 'Reason: %{reason}',
    },
    mission_list = {
        find_by_name = 'Finding mission by name %{name}',
    },
}
