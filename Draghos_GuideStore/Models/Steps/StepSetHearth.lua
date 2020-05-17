local StepSetHearthMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepSetHearthMixin, DraghosMixins.Step);
Mixin(StepSetHearthMixin, DraghosMixins.Location);
Mixin(StepSetHearthMixin, DraghosMixins.Hearth);
Mixin(StepSetHearthMixin, DraghosMixins.Target);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepSetHearthMixin:Init(step)
    self:StepInit(step);
    self:LocationInit(step.location);
    self:HearthInit(step.location);
    self:TargetInit();

    if step.location.innkeeper then
        self.hasInnkeeper = true;
        step.npc = step.location.innkeeper;
        self:AddOneStepLine(Draghos_GuideStore:CreateGuideItem(DraghosMixins.StepLineSpeakTo, step));
    end
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepSetHearthMixin:GetStepType()
    return "Hearth";
end

function StepSetHearthMixin:GetLabel()
    return SET_HEARTH_TO_LOCATION:format(self:GetHearthLabel());
end

function StepSetHearthMixin:IsValid()
    return self.hasInnkeeper and self:IsValidStep() and self:IsValidHearth();
end

function StepSetHearthMixin:IsAvailable()
    return self:IsStepAvailable() and not self:IsCurrentHearth();
end

function StepSetHearthMixin:IsCompleted()
    return self:IsCurrentHearth();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepSetHearth = StepSetHearthMixin;
