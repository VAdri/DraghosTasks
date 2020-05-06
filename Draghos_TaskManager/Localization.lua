local function UseThisLocalization()
    STEP_COMPLETION_TYPE = "Completion Type";
    TASK_MANAGER_STEPS_GROUPBOX_TITLE = "Steps";
    TASK_MANAGER_STEP_DIALOG_TITLE = "Step";
    TASK_MANAGER_TITLE = "Task Log";
    TASK_REPEAT = "Repeat";
    TASKLOG_ADD_NEW_TASK = "New Task";
    TASKLOG_TASK_TITLE = "Task Title";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
