local StepSetHearthMixin = {};

Mixin(StepSetHearthMixin, DraghosMixins.Step);
Mixin(StepSetHearthMixin, DraghosMixins.Location);
Mixin(StepSetHearthMixin, DraghosMixins.Hearth);
Mixin(StepSetHearthMixin, DraghosMixins.Target);

function StepSetHearthMixin:Init(step)
    self:StepInit(step);
    self:LocationInit(step.location);
    self:HearthInit(step.location);
    self:TargetInit();

    if step.location.innkeeper then
        self:AddOneStepLine(
            Draghos_GuideStore:CreateGuideItem(
                DraghosMixins.StepLineSpeakTo, {location = step.location, npc = step.location.innkeeper}
            )
        );
    end
end

function StepSetHearthMixin:GetStepType()
    return "Hearth";
end

function StepSetHearthMixin:GetLabel()
    return SET_HEARTH_TO_LOCATION:format(self:GetHearthLabel());
end

function StepSetHearthMixin:IsValid()
    return self:IsValidStep() and self:IsValidHearth();
end

function StepSetHearthMixin:IsAvailable()
    return self:IsStepAvailable() and not self:IsCurrentHearth();
end

function StepSetHearthMixin:IsCompleted()
    return self:IsCurrentHearth();
end

DraghosMixins.StepSetHearth = StepSetHearthMixin;
