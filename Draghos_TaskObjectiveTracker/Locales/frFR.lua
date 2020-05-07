local function UseThisLocalization()
    OBJECTIVES_MARK_STEP_AS_COMPLETE = "Indiquer une étape terminée";
    OBJECTIVES_VIEW_TASK = "Ouvrir la tâche";
    TRACKER_HEADER_TASKS = "Tâches";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
