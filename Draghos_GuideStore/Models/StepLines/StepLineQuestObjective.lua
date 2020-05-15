local StepLineQuestObjectiveMixin = {};

Mixin(StepLineQuestObjectiveMixin, DraghosMixins.StepLine);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.QuestObjective);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.Location);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.Target);

function StepLineQuestObjectiveMixin:Init(stepLine)
    self:StepLineInit();
    self:QuestObjectiveInit(stepLine.questObjective);
    self:LocationInit(stepLine.location);
    self:TargetInit(stepLine.targets);
end

function StepLineQuestObjectiveMixin:GetLabel()
    return self:GetQuestObjectiveLabel();
end

function StepLineQuestObjectiveMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidQuestObjective() and not self:HasInvalidTargets() -- and self:IsValidLocation();
end

function StepLineQuestObjectiveMixin:IsCompleted()
    return self:IsQuestObjectiveCompleted();
end

DraghosMixins.StepLineQuestObjective = StepLineQuestObjectiveMixin;
