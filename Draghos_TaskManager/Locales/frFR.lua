local function UseThisLocalization()
    MODIFY = not MODIFY and "Modifier";
    STEP_COMPLETION_TYPE = "Type de complétion";
    TASK_MANAGER_STEPS_GROUPBOX_TITLE = "Étapes";
    TASK_MANAGER_STEP_DIALOG_TITLE = "Étape";
    TASK_MANAGER_TITLE = "Journal des tâches";
    TASK_REPEAT = "Répétition";
    TASKLOG_ADD_NEW_TASK = "Nouvelle tâche";
    TASKLOG_TASK_TITLE = "Intitulé de la tâche";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
