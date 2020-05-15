local StepUseHearthstoneMixin = {}

Mixin(StepUseHearthstoneMixin, StepMixin);
Mixin(StepUseHearthstoneMixin, LocationMixin);
Mixin(StepUseHearthstoneMixin, DraghosMixins.Hearth);
Mixin(StepUseHearthstoneMixin, DraghosMixins.UseItem);

function StepUseHearthstoneMixin:Init(step)
    self:StepInit(step);
    self:LocationInit(step.location);
    self:HearthInit(step.location);

    local hearthstoneID = PlayerHasHearthstone();
    self:UseItemInit(Draghos_GuideStore:GetHearthstoneItemByID(hearthstoneID));

    -- self:AddOneStepLine(Draghos_GuideStore:CreateGuideItem(StepLineGrindProgressMixin, step));
end

function StepUseHearthstoneMixin:GetStepType()
    return "Move";
end

function StepUseHearthstoneMixin:GetLabel()
    return USE_HEARTHSTONE_TO_TELEPORT:format(self:GetItemLabel(), self:GetHearthLabel());
end

function StepUseHearthstoneMixin:IsValid()
    return self:IsValidStep() and self:IsValidItemToUse() and self:IsValidHearth() and self:IsValidLocation();
end

function StepUseHearthstoneMixin:IsAvailable()
    return self:IsStepAvailable() and self:IsItemAvailableToUse();
end

function StepUseHearthstoneMixin:IsCompleted()
    return self:DependentStepsCompleted();
end

DraghosMixins.StepUseHearthstone = StepUseHearthstoneMixin;
