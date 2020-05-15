local function UseThisLocalization()
    TRACKER_HEADER_GUIDE = "Guide";
    TARGET_KEYBIND_ALREADY_EXISTS_DIALOG = "The key binding '%s' is configured to target the guide's objective " ..
                                               "but it is already used by %s, do you want to replace it?";
    ANOTHER_ACTION = "another action";
end

-- Use these on any case, another localization may override some or all of them afterwards.
UseThisLocalization();

-- After using this localization, remove it from memory.
UseThisLocalization = nil;
