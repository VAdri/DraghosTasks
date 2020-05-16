local function UseThisLocalization()
    SPEAK_TO_NPC_IN_LOCATION = "Speak to %s in %s";
    PICKUP_QUEST = "Pick up: %s";
    HANDIN_QUEST = QUEST_WATCH_QUEST_READY .. ": %s";
    COMPLETE_QUEST = "Complete quest: %s";
    PROGRESS_QUEST_OBJECTIVES = "Progress %d |4objective:objectives;: %s";
    COMPLETE_QUEST_OBJECTIVES = "Complete %d |4objective:objectives;: %s";
    GRIND_TO = "Grind mobs until reaching: %s";
    LEVEL_AND_XP = LEVEL_GAINED .. " (" .. XP_STATUS_BAR_TEXT:gsub("%%d/%%d", "%%d") .. ")";
    GRIND_PROGRESS = "Progress";
    GRIND_PROGRESS_TO_NEXT_LEVEL = "Progress to reach next level";
    USE_HEARTHSTONE_TO_TELEPORT = "Use %s to return to %s";
    SET_HEARTH_TO_LOCATION = "Set hearth at %s";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
