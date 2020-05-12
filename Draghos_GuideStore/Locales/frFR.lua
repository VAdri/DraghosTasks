local function UseThisLocalization()
    SPEAK_TO_NPC_IN_LOCATION = "Parler à %s dans %s";
    PICKUP_QUEST = "Accepter : %s"; -- ? "Accepter la quête « %s »";
    HANDIN_QUEST = "Rendre : %s"; -- ? "Rendre la quête « %s »";
    COMPLETE_QUEST = "Compléter : %s"; -- ? "Compléter la quête « %s »";
    PROGRESS_QUEST_OBJECTIVES = "Progresser sur %d |4objectif:objectifs; : %s"
    COMPLETE_QUEST_OBJECTIVES = "Compléter %d |4objectif:objectifs; : %s"
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
