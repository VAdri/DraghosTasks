local function UseThisLocalization()
    TASK_MANAGER_TITLE = "Journal des tâches";
    TASKLOG_ADD_NEW_TASK = "Nouvelle tâche";
    TASKLOG_TASK_TITLE = "Intitulé de la tâche";
    CALENDAR_REPEAT_DAILY = "Tous les jours";
    TASK_REPEAT = "Répétition";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
