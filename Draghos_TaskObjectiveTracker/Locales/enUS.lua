local function UseThisLocalization()
    TRACKER_HEADER_TASKS = "Tasks";
    OBJECTIVES_VIEW_TASK = "Open Task";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
