local StepUseHearthstoneMixin = {}

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepUseHearthstoneMixin, DraghosMixins.Step);
Mixin(StepUseHearthstoneMixin, DraghosMixins.Location);
Mixin(StepUseHearthstoneMixin, DraghosMixins.Hearth);
Mixin(StepUseHearthstoneMixin, DraghosMixins.UseItem);

local StepUseHearthstoneMT = {__index = function(t, key, ...) return StepUseHearthstoneMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepUseHearthstoneMixin.New(step)
    local item = setmetatable({}, StepUseHearthstoneMT);
    item:Init(step);
    return item;
end

local function GetHearthstoneSpellIDByItemID(hearthstoneID)
    local hearthstone = Draghos_GuideStore:GetHearthstoneItemByID(hearthstoneID);
    if hearthstone then
        return hearthstone.spellID;
    end
end

function StepUseHearthstoneMixin:Init(step)
    self:StepInit(step);
    self:LocationInit(step.location);
    self:HearthInit(step.location);

    local hearthstoneID = PlayerHasHearthstone();
    if hearthstoneID then
        -- PlayerHasHearthstone() returned the id of the player's hearthstone
        local hearthstone = Draghos_GuideStore:GetHearthstoneItemByID(hearthstoneID);
        self:UseItemInit(hearthstone);
    else
        -- PlayerHasHearthstone() has returned nil so we need to wait until the player gets it back
        local getItemHandlers = {getItemID = PlayerHasHearthstone, getItemSpellID = GetHearthstoneSpellIDByItemID};
        self:UseItemInit(getItemHandlers);
    end
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepUseHearthstoneMixin:GetStepType()
    return "Move";
end

function StepUseHearthstoneMixin:GetLabel()
    return USE_HEARTHSTONE_TO_TELEPORT:format(self:GetItemLabel() or "", self:GetHearthLabel());
end

function StepUseHearthstoneMixin:IsValid()
    return self:HasDependentSteps() and self:IsValidStep() and self:IsValidItemToUse() and self:IsValidHearth() and
               self:IsValidLocation();
end

function StepUseHearthstoneMixin:IsAvailable()
    return self:IsStepAvailable() and self:IsItemAvailableToUse() and self:IsCurrentHearth() and
               not self:IsPlayerAtHearth();
end

function StepUseHearthstoneMixin:IsCompleted()
    return self:DependentStepsCompleted();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepUseHearthstone = StepUseHearthstoneMixin;
