local function UseThisLocalization()
    SPEAK_TO_NPC_IN_LOCATION = "Parler à %s dans %s";
    PICKUP_QUEST = ACCEPT .. " : %s";
    HANDIN_QUEST = QUEST_WATCH_QUEST_READY .. " : %s";
    COMPLETE_QUEST = "Compléter : %s";
    PROGRESS_QUEST_OBJECTIVES = "Progresser sur %d |4objectif:objectifs; : %s";
    COMPLETE_QUEST_OBJECTIVES = "Compléter %d |4objectif:objectifs; : %s";
    GRIND_TO = "Farmer des monstres jusqu'à atteindre : %s";
    LEVEL_AND_XP = LEVEL_GAINED .. " (" .. XP_STATUS_BAR_TEXT:gsub("%%d/%%d", "%%d") .. ")";
    GRIND_PROGRESS = "Progression";
    GRIND_PROGRESS_TO_NEXT_LEVEL = "Progression jusqu'au prochain niveau";
    USE_HEARTHSTONE_TO_TELEPORT = "Utiliser la %s pour retourner à %s";
    SET_HEARTH_TO_LOCATION = "Faire de %s votre nouveau foyer";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
