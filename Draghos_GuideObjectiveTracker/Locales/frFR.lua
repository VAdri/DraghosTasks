local function UseThisLocalization()
    TRACKER_HEADER_GUIDE = "Guide";
    TARGET_KEYBIND_ALREADY_EXISTS_DIALOG = "Le raccourci '%s' est configuré pour cibler l'objectif du guide " ..
                                               "mais il est déjà utilisé par %s, souhaitez-vous le remplacer ?";
    ANOTHER_ACTION = "une autre action";
end

local Locale = GetLocale();
if Locale == "frFR" then
    UseThisLocalization();
end

-- After using this localization or deciding that we don't need it, remove it from memory.
UseThisLocalization = nil;
