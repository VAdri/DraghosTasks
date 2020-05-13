local function UseThisLocalization()
    SPEAK_TO_NPC_IN_LOCATION = "Speak to %s in %s";
    PICKUP_QUEST = "Pick up: %s";
    HANDIN_QUEST = QUEST_WATCH_QUEST_READY..": %s";
    COMPLETE_QUEST = "Complete quest: %s";
    PROGRESS_QUEST_OBJECTIVES = "Progress %d |4objective:objectives;: %s"
    COMPLETE_QUEST_OBJECTIVES = "Complete %d |4objective:objectives;: %s"
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
