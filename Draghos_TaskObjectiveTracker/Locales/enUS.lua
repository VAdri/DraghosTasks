local function UseThisLocalization()
    OBJECTIVES_MARK_STEP_AS_COMPLETE = "Mark Step as Complete";
    OBJECTIVES_VIEW_TASK = "Open Task";
    TRACKER_HEADER_TASKS = "Tasks";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
