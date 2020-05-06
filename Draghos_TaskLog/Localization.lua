local function UseThisLocalization()
    CALENDAR_REPEAT_DAILY = "Daily";
    STEP_SUMMARY = "%s: %s";
    STEP_TYPE_OPTION_MANUAL = "Manual";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
