StepLineQuestObjectiveMixin = {};

Mixin(StepLineQuestObjectiveMixin, StepLineMixin);
Mixin(StepLineQuestObjectiveMixin, QuestObjectiveMixin);
Mixin(StepLineQuestObjectiveMixin, LocationMixin);

function StepLineQuestObjectiveMixin:Init(stepLine)
    self:StepLineInit();
    self:QuestObjectiveInit(stepLine.questObjective);
    self:LocationInit(stepLine.location);
end

function StepLineQuestObjectiveMixin:GetLabel()
    return self:GetQuestObjectiveLabel();
end

function StepLineQuestObjectiveMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidQuestObjective() -- and self:IsValidLocation();
end

function StepLineQuestObjectiveMixin:IsCompleted()
    return self:IsQuestObjectiveCompleted();
end
