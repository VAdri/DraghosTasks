local function UseThisLocalization()
    TRACKER_HEADER_TASKS = "Tasks";
end

local Locale = GetLocale();
if Locale ~= "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
