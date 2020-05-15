local Str = DraghosUtils.Str;

local QuestObjectiveMixin = {};

--- @class QuestObjective
--- @field questID number
--- @field index number
--- @field overrideObjectiveType string|nil

--- @param questObjective QuestObjective
function QuestObjectiveMixin:QuestObjectiveInit(questObjective)
    self.questID = tonumber(questObjective.questID);
    self.index = tonumber(questObjective.index);
    self.overrideObjectiveType = questObjective.overrideObjectiveType;

    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_LOG_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "QUEST_LOG_CRITERIA_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "WAYPOINT_UPDATE");
end

function QuestObjectiveMixin:GetQuestObjective()
    local questObjectives = C_QuestLog.GetQuestObjectives(self.questID);
    local questObjective = questObjectives and questObjectives[self.index];

    local text, objectiveType, finished;
    if questObjective then
        text, objectiveType, finished = questObjectives.text, questObjective.type, questObjective.finished;
    end

    -- if IsBlankString(text) or IsBlankString(objectiveType) then
    --     local questLogIndex = GetQuestLogIndexByID(self.questID);
    --     text, objectiveType, finished = GetQuestLogLeaderBoard(self.index, questLogIndex);
    -- end

    if Str:IsBlankString(text) or Str:IsBlankString(objectiveType) then
        text, objectiveType, finished = GetQuestObjectiveInfo(self.questID, self.index, false);
    end

    return {
        text = text,
        type = objectiveType,
        finished = finished,
        numFulfilled = questObjective and questObjective.numFulfilled or nil,
        numRequired = questObjective and questObjective.numRequired or nil,
    };
end

function QuestObjectiveMixin:GetQuestObjectiveLabel()
    local questObjective = self:GetQuestObjective();
    return questObjective.text;
end

function QuestObjectiveMixin:IsQuestObjectiveCompleted()
    local questObjective = self:GetQuestObjective();
    return questObjective.finished;
end

function QuestObjectiveMixin:IsValidQuestObjective()
    local questObjective = self:GetQuestObjective();
    return not Str:IsBlankString(questObjective.text) and not Str:IsBlankString(questObjective.type);
end

function QuestObjectiveMixin:IsObjectiveType(objectiveType)
    local currentObjectiveType = self.overrideObjectiveType or self:GetQuestObjective().type;
    return currentObjectiveType == objectiveType;
end

function QuestObjectiveMixin:IsCombat()
    return self:IsObjectiveType(QUEST_OBJECTIVE_TYPE_MONSTER);
end

function QuestObjectiveMixin:IsObjectInteraction()
    return self:IsObjectiveType(QUEST_OBJECTIVE_TYPE_OBJECT);
end

function QuestObjectiveMixin:IsLoot()
    return self:IsObjectiveType(QUEST_OBJECTIVE_TYPE_ITEM);
end

-- function QuestObjectiveMixin:IsSetFree()
-- return self:IsObjectiveType(CUSTOM_QUEST_OBJECTIVE_TYPE_SET_FREE);
--     return self.overrideObjectiveType == CUSTOM_QUEST_OBJECTIVE_TYPE_SET_FREE;
-- end

DraghosMixins.QuestObjective = QuestObjectiveMixin;
