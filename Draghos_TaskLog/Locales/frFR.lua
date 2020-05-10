local function UseThisLocalization()
    STEP_SUMMARY = "%s : %s";
    STEP_TYPE_MANUAL_LABEL = "Manuel";
    STEP_TYPE_QUEST_PICKUP_LABEL = "Accepter";
    STEP_TYPE_GROUP_QUEST_LABEL = "Quête";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
