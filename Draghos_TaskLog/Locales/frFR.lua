local function UseThisLocalization()
    CALENDAR_REPEAT_DAILY = "Tous les jours";
    STEP_SUMMARY = "%s : %s";
    STEP_TYPE_MANUAL_LABEL = "Manuel";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
