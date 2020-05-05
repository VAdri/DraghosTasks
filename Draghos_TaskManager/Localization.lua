local function UseThisLocalization()
    TASK_MANAGER_TITLE = "Task Log";
    TASKLOG_ADD_NEW_TASK = "New Task";
    TASKLOG_TASK_TITLE = "Task Title";
    CALENDAR_REPEAT_DAILY = "Daily";
    TASK_REPEAT = "Repeat";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
