local Hacks = DraghosUtils.Hacks;
local Str = DraghosUtils.Str;
local FP = DraghosUtils.FP;

local defaultInitialAnchorOffsets = {0, 0};

function GuideObjective_SetupHeader(block, initialLineWidth)
    block.leftIcon = nil;
    block.rightButton = nil;
    block.lineWidth = initialLineWidth or OBJECTIVE_TRACKER_TEXT_WIDTH;
end

local function OnRelease(framePool, frame)
    frame:Hide();
    frame:ClearAllPoints();
    frame:SetParent(nil);
end

-- *****************************************************************************************************
-- ***** LEFT_ICON
-- *****************************************************************************************************

-- See https://www.wowinterface.com/forums/showthread.php?t=53870 for a complete list of objectIconIDs
-- Speak: https://github.com/Gethe/wow-ui-textures/blob/live/CHATFRAME/UI-ChatWhisperIcon.PNG
-- Rest: https://raw.githubusercontent.com/Gethe/wow-ui-textures/live/CHARACTERFRAME/UI-StateIcon.PNG
-- Information: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Profession.PNG
-- Search: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/None.PNG
-- Hearthstone: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Innkeeper.PNG
-- Food: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Food.PNG
-- Fly: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/FlightMaster.PNG
-- Spell: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Class.PNG
-- Buy/Sell: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Auctioneer.PNG or https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-GroupLoot-Coin-Up.PNG
-- Repair: https://github.com/Gethe/wow-ui-textures/blob/live/MINIMAP/TRACKING/Repair.PNG
-- Really good quality: https://github.com/Gethe/wow-ui-textures/blob/live/Garrison/MobileAppIcons.PNG
-- Alert: https://github.com/Gethe/wow-ui-textures/blob/live/DialogFrame/UI-Dialog-Icon-AlertNew.PNG
-- Dices: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-GroupLoot-Dice-Up.PNG
-- Skip: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-GroupLoot-Pass-Up.PNG
-- Refresh: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-RefreshButton.PNG or https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UIFrameButtons.PNG
-- Stop?: https://github.com/Gethe/wow-ui-textures/blob/live/Buttons/UI-StopButton.PNG
-- Plus: https://github.com/Gethe/wow-ui-textures/blob/live/PaperDollInfoFrame/Character-Plus.PNG

local StepTypeIconTextureInfos = {
    ["PickUpQuest"] = {filePath = "Interface\\MINIMAP\\ObjectIconsAtlas", objectIconID = 4726, x = 22, y = 20},
    ["HandInQuest"] = {filePath = "Interface\\MINIMAP\\ObjectIconsAtlas", objectIconID = 4699, x = 20, y = 20},
    ["CombatObjective"] = {
        filePath = "Interface\\CHARACTERFRAME\\UI-StateIcon",
        left = "0.5",
        right = "1",
        top = "0",
        bottom = "0.5",
        x = 24,
        y = 24,
    },
    ["LootObjective"] = {filePath = "Interface\\MINIMAP\\TRACKING\\Banker", x = 20, y = 20},
    -- ["ObjectInteractionObjective"] = {filePath = "Interface\\Scenarios\\ScenarioIcon-Interact", x = 16, y = 16},
    ["OtherObjective"] = {filePath = "Interface\\Scenarios\\ScenarioIcon-Interact", x = 16, y = 16},
    ["Grind"] = {filePath = "Interface\\PaperDollInfoFrame\\Character-Plus", x = 14, y = 14},
    ["Move"] = {filePath = "Interface\\MINIMAP\\TRACKING\\FlightMaster", x = 18, y = 18},
};

local guideObjectiveLeftIconPool = CreateFramePool("Frame", nil, "GuideStepTypeIconTemplate", OnRelease);

function GuideObjectiveBlock_AcquireLeftIcon(parent)
    local icon = guideObjectiveLeftIconPool:Acquire();
    icon:SetParent(parent);

    return icon;
end

function GuideObjectiveBlock_InitializeTexture(frame, textureInfo)
    frame.MainIcon:SetTexture(textureInfo.filePath);
    frame.MainIcon:SetSize(textureInfo.x, textureInfo.y);

    local left, right, top, bottom;
    if textureInfo.objectIconID then
        left, right, top, bottom = GetObjectIconTextureCoords(textureInfo.objectIconID);
    else
        left, right, top, bottom = textureInfo.left, textureInfo.right, textureInfo.top, textureInfo.bottom;
    end

    frame.MainIcon:SetTexCoord(left or 0, right or 1, top or 0, bottom or 1);
end

function GuideObjectiveBlock_AddLeftIcon(block, iconName, initialAnchorOffsets)
    local textureInfo = StepTypeIconTextureInfos[iconName];
    if not textureInfo then
        textureInfo = StepTypeIconTextureInfos["OtherObjective"];
    end

    local icon = block.leftIcon;
    if not icon then
        icon = GuideObjectiveBlock_AcquireLeftIcon(block);
        -- block.stepTypeIcon = icon;
    end

    GuideObjectiveBlock_InitializeTexture(icon, textureInfo);

    if block.leftIcon == icon then
        return;
    end

    icon:ClearAllPoints();

    local paddingBetweenButtons = block.module.paddingBetweenButtons or 0;

    if block.leftIcon then
        icon:SetPoint("LEFT", block.leftIcon, "RIGHT", -paddingBetweenButtons, 0);
    else
        initialAnchorOffsets = initialAnchorOffsets or defaultInitialAnchorOffsets;
        -- icon:SetPoint("TOPLEFT", block, initialAnchorOffsets[1], initialAnchorOffsets[2]);
        icon:SetPoint("RIGHT", block.HeaderText, "LEFT", -2, 0);
    end

    icon:Show();

    block.leftIcon = icon;
end

function GuideObjectiveBlock_ReleaseLeftIcon(block)
    if block.leftIcon then
        guideObjectiveLeftIconPool:Release(block.leftIcon);
        block.leftIcon = nil;
    end
end

-- *****************************************************************************************************
-- ***** RIGHT BUTTON MANAGER
-- *****************************************************************************************************

local g_guideObjectiveButtonPool = Hacks:CreateNamedFramePool(
                                       "BUTTON", nil, "GuideObjectiveButtonTemplate", OnRelease, "GuideObjectiveButton"
                                   );
function GuideObjectiveButton_Acquire(parent)
    local button = g_guideObjectiveButtonPool:Acquire();
    button:SetParent(parent);
    return button;
end

function GuideObjectiveButton_Release(button)
    g_guideObjectiveButtonPool:Release(button);
end

function GuideObjectiveSetupBlockButton_AddRightButton(block, button, initialAnchorOffsets)
    if block.rightButton == button then
        -- TODO: Fix for real, some event causes the findGroup button to get added twice (could happen for any button)
        -- so it doesn't need to be reanchored another time
        return;
    end

    button:ClearAllPoints();

    local paddingBetweenButtons = block.module.paddingBetweenButtons or 0;

    if block.rightButton then
        button:SetPoint("RIGHT", block.rightButton, "LEFT", -paddingBetweenButtons, 0);
    else
        initialAnchorOffsets = initialAnchorOffsets or defaultInitialAnchorOffsets;
        button:SetPoint("TOPRIGHT", block, initialAnchorOffsets[1], initialAnchorOffsets[2]);
    end

    button:Show();

    block.rightButton = button;
    block.lineWidth = block.lineWidth - button:GetWidth() - paddingBetweenButtons;
end

-- *****************************************************************************************************
-- ***** BUTTON HOKS
-- *****************************************************************************************************

function GuideObjectiveButton_OnLoad(self)
    self:RegisterForClicks("AnyUp")
    self:HookScript("OnClick", GuideObjectiveButton_OnClick)
end

function GuideObjectiveButton_OnEvent(self, event, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        self.rangeTimer = -1;
    elseif (event == "BAG_UPDATE_COOLDOWN") then
        GuideObjectiveButton_UpdateCooldown(self);
    end
end

function GuideObjectiveButton_UpdateCooldown(self)
    if self.item then
        GuideObjectiveButton_UpdateItemCooldown(self);
        -- elseif self.spell then
        --     GuideObjectiveButton_UpdateSpellCooldown(self);
    end
end

function GuideObjectiveButton_OnUpdate(self, elapsed)
    if self.item then
        GuideObjectiveButton_UpdateItem(self, elapsed);
        -- elseif self.spell then
        --     GuideObjectiveButton_UpdateSpell(self, elapsed);
    elseif self.targets then
        GuideObjectiveButton_UpdateTarget(self, elapsed);
    end
end

function GuideObjectiveButton_OnShow(self)
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("BAG_UPDATE_COOLDOWN");
end

function GuideObjectiveButton_OnHide(self)
    self:UnregisterEvent("PLAYER_TARGET_CHANGED");
    self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
end

function GuideObjectiveButton_OnEnter(self)
    if self.item then
        GuideObjectiveButton_ShowItemTooltip(self);
        -- elseif self.spell then
        --     GuideObjectiveButton_ShowSpellTooltip(self);
    elseif self.targets then
        GuideObjectiveButton_ShowTargetTooltip(self);
    end
end

function GuideObjectiveButton_OnClick(self, button)
    if self.item then
        GuideObjectiveButton_OnItemClick(self, button);
        -- elseif self.spell then
        --     GuideObjectiveButton_OnSpellClick(self, button);
    elseif self.targets then
        GuideObjectiveButton_OnTargetClick(self, button);
    end
end

-- *****************************************************************************************************
-- ***** ITEM BUTTON
-- *****************************************************************************************************

function GuideObjectiveButton_InitializeItem(itemButton, item)
    itemButton:SetID(item:GetItemID());
    itemButton:SetAttribute("type1", "item")
    itemButton:SetAttribute("item", item:GetItemName());
    itemButton.item = item;
    -- itemButton.charges = nil;
    itemButton.rangeTimer = -1;
    SetItemButtonTexture(itemButton, item:GetItemIcon());
    -- SetItemButtonCount(itemButton, itemButton.charges);
    GuideObjectiveButton_UpdateItemCooldown(itemButton);
end

function GuideObjectiveButton_ShowItemTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetItemByID(self:GetID());
end

function GuideObjectiveButton_OnItemClick(self, button)
    if (IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
        local link = self.item:GetItemLink();
        if (link) then
            ChatEdit_InsertLink(link);
        end
    end
end
function GuideObjectiveButton_UpdateItem(self, elapsed)
    -- -- Handle range indicator
    local rangeTimer = self.rangeTimer;
    if (rangeTimer) then
        rangeTimer = rangeTimer - elapsed;
        if (rangeTimer <= 0) then
            local count = self.HotKey;
            -- ! IsItemInRange return true, false or nil but IsSpellInRange return 1, 0 or nil
            local valid = IsItemInRange(self.item:GetItemName(), "player");
            if (valid == false) then
                count:Show();
                count:SetVertexColor(1.0, 0.1, 0.1);
            elseif (valid == true) then
                count:Show();
                count:SetVertexColor(0.6, 0.6, 0.6);
            else
                count:Hide();
            end
            rangeTimer = TOOLTIP_UPDATE_TIME;
        end

        self.rangeTimer = rangeTimer;
    end
end

function GuideObjectiveButton_UpdateItemCooldown(itemButton)
    local start, duration, enable = GetItemCooldown(itemButton:GetID());
    if (start) then
        CooldownFrame_Set(itemButton.Cooldown, start, duration, enable);
        if (duration > 0 and enable == 0) then
            SetItemButtonTextureVertexColor(itemButton, 0.4, 0.4, 0.4);
        else
            SetItemButtonTextureVertexColor(itemButton, 1, 1, 1);
        end
    end
end

function GuideObjectiveSetupBlockButton_Item(block, item)
    if item then
        local itemButton = block.itemButton;
        if not itemButton then
            itemButton = GuideObjectiveButton_Acquire(block);
            block.itemButton = itemButton;
        end

        GuideObjectiveButton_InitializeItem(itemButton, item);
        GuideObjectiveSetupBlockButton_AddRightButton(block, itemButton, block.module.buttonOffsets.useItem);
        return true;
    else
        GuideObjectiveReleaseBlockButton_Item(block);
        return false;
    end
end

function GuideObjectiveReleaseBlockButton_Item(block)
    if block.itemButton then
        GuideObjectiveButton_Release(block.itemButton);
        block.itemButton = nil;
    end
end

-- *****************************************************************************************************
-- ***** TARGETS BUTTON
-- *****************************************************************************************************

-- TODO: Set the binding (CTRL-TAB) on the options
local bindingKey = "CTRL-TAB";

StaticPopupDialogs["DRAGHOS_GOT_KEYBIND_EXISTS"] = {
    text = TARGET_KEYBIND_ALREADY_EXISTS_DIALOG,
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        SetBinding(bindingKey, nil);
        SaveBindings(2)
        ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_GUIDE);
    end,
    OnCancel = function(_, _, action)
        if action == "clicked" then
            -- TODO: Modify it in the options
            bindingKey = nil;
        end
    end,
    timeout = 0,
    whileDead = true,
    -- hideOnEscape = true,
};

local function TargetUnitMacro(name)
    return "/targetexact " .. name;
end

function GuideObjectiveButton_InitializeTargets(targetsButton, step)
    local macroTargets = table.concat(FP:Map(step:GetTargetNames(), TargetUnitMacro), "\n");

    -- targetButton:SetID(item:GetItemID());
    targetsButton.targets = step:GetTargetIDs();

    targetsButton:SetAttribute("type1", "macro");
    targetsButton:SetAttribute("macrotext", "/cleartaget\n" .. macroTargets);

    if bindingKey and not g_guideObjectiveButtonPool.hasKeyBind then
        local bindingAction = GetBindingAction(bindingKey);
        if not Str:IsBlankString(bindingAction) then
            if not StaticPopup_Visible("DRAGHOS_GOT_KEYBIND_EXISTS") then
                local bindingActionName = _G["BINDING_NAME_" .. bindingAction];
                bindingActionName = bindingActionName and "'" .. bindingActionName .. "'" or ANOTHER_ACTION;
                StaticPopup_Show("DRAGHOS_GOT_KEYBIND_EXISTS", bindingKey, bindingActionName);
            end
        else
            SetBindingClick(bindingKey, targetsButton:GetName());
            targetsButton.hasKeyBind = true;
            g_guideObjectiveButtonPool.hasKeyBind = true;
        end
    end

    targetsButton.HotKey:Hide();

    targetsButton.icon = targetsButton:CreateTexture(nil, "BORDER");
    targetsButton.icon:SetTexture("Interface\\Icons\\Ability_Hunter_SniperShot");
    targetsButton.icon:SetAllPoints(targetsButton);
end

function GuideObjectiveButton_ShowTargetTooltip(self)
    -- GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    -- GameTooltip:SetItemByID(self:GetID());
end

function GuideObjectiveButton_OnTargetClick(self, button)
    -- if (IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
    --     local link = self.item:GetItemLink();
    --     if (link) then
    --         ChatEdit_InsertLink(link);
    --     end
    -- end

    -- Mark the target
    if not GetRaidTargetIndex("target") then
        if UnitIsFriend("player", "target") then
            -- With a star for friendly units
            SetRaidTarget("target", 1);
        else
            -- With a skull for ennemy units
            SetRaidTarget("target", 8);
        end
    end
end

function GuideObjectiveButton_UpdateTarget(self, elapsed)
end

function GuideObjectiveSetupBlockButton_Targets(block, step)
    if step:HasTargets() then
        local targetsButton = block.targetsButton;
        if not targetsButton then
            targetsButton = GuideObjectiveButton_Acquire(block);
            block.targetsButton = targetsButton;
        end

        GuideObjectiveButton_InitializeTargets(targetsButton, step);
        GuideObjectiveSetupBlockButton_AddRightButton(block, targetsButton, block.module.buttonOffsets.useItem);
        return true;
    else
        GuideObjectiveReleaseBlockButton_Targets(block);
        return false;
    end
end

function GuideObjectiveReleaseBlockButton_Targets(block)
    if block.targetsButton then
        if block.targetsButton.hasKeyBind then
            block.targetsButton.hasKeyBind = false;
            g_guideObjectiveButtonPool.hasKeyBind = false;
        end
        GuideObjectiveButton_Release(block.targetsButton);
        block.targetsButton = nil;
    end
end
