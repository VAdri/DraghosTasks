local Helpers = DraghosUtils.Helpers;

-- Frame that tracks the end of cooldowns to fix the lack of event from Blizzard
local ItemWatcherFrame = CreateFrame("Frame");
ItemWatcherFrame.items = {};

local function WatchAvailability(elapsed)
    for itemID, item in pairs(ItemWatcherFrame.items) do
        if item:IsItemAvailableToUse() then
            Draghos_GuideStore:SendCustomEvent("DRAGHOS_ITEM_AVAILABLE", itemID);
            -- item:NotifyWatchers("DRAGHOS_ITEM_AVAILABLE", itemID);
            ItemWatcherFrame.items[itemID] = nil;
        end
    end
end

ItemWatcherFrame:SetScript("OnUpdate", WatchAvailability);

-- Mixin
local UseItemMixin = {};

Mixin(UseItemMixin, DraghosMixins.Observable);

function UseItemMixin:UseItemInit(item)
    if type(item.getItemID) == "function" then
        self.getItemID = item.getItemID;
    end

    if type(item.getItemSpellID) == "function" then
        self.getItemSpellID = item.getItemSpellID;
    end

    self.itemID = tonumber(item.itemID);
    self.itemSpellID = tonumber(item.spellID);
    self.item = self.itemID and Item:CreateFromItemID(self.itemID);
    self.spell = self.itemSpellID and Spell:CreateFromSpellID(self.itemSpellID);

    Draghos_GuideStore:RegisterForNotifications(self, "BAG_UPDATE_COOLDOWN");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_SPELLCAST_SUCCEEDED");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_SPELLCAST_INTERRUPTED");
    Draghos_GuideStore:RegisterForNotifications(self, "UNIT_SPELLCAST_FAILED");
    Draghos_GuideStore:RegisterForNotifications(self, "SPELL_UPDATE_COOLDOWN");
    Draghos_GuideStore:RegisterForNotifications(self, "SPELL_UPDATE_USABLE");
    Draghos_GuideStore:RegisterForNotifications(self, "DRAGHOS_ITEM_AVAILABLE");
end

function UseItemMixin:GetItem()
    if self.item then
        return self.item;
    elseif self.getItemID then
        local itemID = self.getItemID();
        if itemID then
            self.itemID = itemID;
            self.item = self.itemID and Item:CreateFromItemID(self.itemID);
            return self.item;
        end
    end
end

function UseItemMixin:GetItemSpell()
    if self.spell then
        return self.spell;
    elseif self.getItemSpellID then
        local itemSpellID = self.getItemSpellID(self.itemID);
        if itemSpellID then
            self.itemSpellID = itemSpellID;
            self.spell = self.itemSpellID and Spell:CreateFromSpellID(self.itemSpellID);
            return self.spell;
        end
    end
end

function UseItemMixin:IsValidItemToUse()
    local item = self:GetItem();
    return item and --[[self.spell and]] item:IsItemDataCached();
end

function UseItemMixin:IsItemAvailableToUse()
    local item = self:GetItem();
    if not item then
        return false;
    end

    local spell = self:GetItemSpell();
    local spellID = spell and spell:GetSpellID();
    if spellID and Helpers:PlayerIsCastingSpellID(spellID) then
        -- Player is currently using the item
        return true;
    end

    local _, duration, enabled = GetItemCooldown(item:GetItemID());
    if duration == 0 and enabled == 1 then
        return true;
    else
        ItemWatcherFrame.items[item:GetItemID()] = self;
        return false;
    end
end

function UseItemMixin:GetItemLabel()
    local item = self:GetItem();
    return item and item:GetItemName() or nil;
end

function UseItemMixin:CanUseItem()
    return self:GetItem() and true or false;
end

function UseItemMixin:UsedItemID()
    local item = self:GetItem();
    return item and item.itemID or nil;
end

DraghosMixins.UseItem = UseItemMixin;
