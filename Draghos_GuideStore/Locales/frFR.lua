local function UseThisLocalization()
    SPEAK_TO_NPC_IN_LOCATION = "Parler à %s dans %s";
    PICKUP_QUEST = ACCEPT.." : %s";
    HANDIN_QUEST = QUEST_WATCH_QUEST_READY.." : %s";
    COMPLETE_QUEST = "Compléter : %s";
    PROGRESS_QUEST_OBJECTIVES = "Progresser sur %d |4objectif:objectifs; : %s"
    COMPLETE_QUEST_OBJECTIVES = "Compléter %d |4objectif:objectifs; : %s"
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
