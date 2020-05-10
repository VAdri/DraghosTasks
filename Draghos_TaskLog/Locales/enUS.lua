local function UseThisLocalization()
    STEP_SUMMARY = "%s: %s";
    STEP_TYPE_MANUAL_LABEL = "Manual";
    STEP_TYPE_QUEST_PICKUP_LABEL = "Pick up";
    STEP_TYPE_GROUP_QUEST_LABEL = "Quest";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
