local StepLineQuestObjectiveMixin = {};

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepLineQuestObjectiveMixin, DraghosMixins.StepLine);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.QuestObjective);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.Location);
Mixin(StepLineQuestObjectiveMixin, DraghosMixins.Target);

local StepLineQuestObjectiveMT = {__index = function(t, key, ...) return StepLineQuestObjectiveMixin[key]; end};

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepLineQuestObjectiveMixin.New(stepLine)
    local item = setmetatable({}, StepLineQuestObjectiveMT);
    item:Init(stepLine);
    return item;
end

function StepLineQuestObjectiveMixin:Init(stepLine)
    self:StepLineInit();
    self:QuestObjectiveInit(stepLine.questObjective);
    self:LocationInit(stepLine.location);
    self:TargetInit(stepLine.targets);
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepLineQuestObjectiveMixin:GetLabel()
    return self:GetQuestObjectiveLabel();
end

function StepLineQuestObjectiveMixin:IsValid()
    return self:IsValidStepLine() and self:IsValidQuestObjective() and not self:HasInvalidTargets() -- and self:IsValidLocation();
end

function StepLineQuestObjectiveMixin:IsCompleted()
    return self:IsQuestObjectiveCompleted();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepLineQuestObjective = StepLineQuestObjectiveMixin;
