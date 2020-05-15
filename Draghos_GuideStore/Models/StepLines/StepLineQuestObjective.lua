local StepLineQuestObjectiveMixin = {};

Mixin(StepLineQuestObjectiveMixin, DraghosMixins.StepLine);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.QuestObjective);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.Location);

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

DraghosMixins.StepLineQuestObjective = StepLineQuestObjectiveMixin;
