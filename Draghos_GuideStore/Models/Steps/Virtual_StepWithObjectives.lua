local M = LibStub("Moses");

local Virtual_StepWithObjectivesMixin = {};

-- *********************************************************************************************************************
-- ***** Quest with objectives
-- *********************************************************************************************************************

function Virtual_StepWithObjectivesMixin:AllObjectivesHaveBeenFetched()
    local currentQuestObjectives = self:GetQuestObjectives();

    if self.questObjectivesIndexes == nil and #currentQuestObjectives ~= C_QuestLog.GetNumQuestObjectives(self.questID) then
        return false;
    elseif self.questObjectivesIndexes ~= nil and #currentQuestObjectives ~= #self.questObjectivesIndexes then
        return false;
    else
        return true;
    end
end

-- Sometimes (after login for instance), the objectives are not loaded so we need to check them after
function Virtual_StepWithObjectivesMixin:GetStepLines()
    if not self:AllObjectivesHaveBeenFetched() then
        -- The last fetch couldn't get all the objectives
        local newQuestObjectives = self:CreateQuestObjectives();
        self.stepLines = M(self.stepLines or {}):append(newQuestObjectives or {}):uniqueProp("index"):value();
    end

    return self.stepLines or {};
end

local isCombat = M.partial(M.result, "_", "IsCombat");
local isObjectInteraction = M.partial(M.result, "_", "IsObjectInteraction");
local isLoot = M.partial(M.result, "_", "IsLoot");
local function getObjectivesType(questObjectives)
    local questObjectivesCount = #questObjectives;
    if questObjectivesCount == 0 then
        return nil;
    else
        local combatObjectivesCount = M(questObjectives):countf(isCombat):value();
        if combatObjectivesCount == questObjectivesCount then
            return "CombatObjective";
        end

        local objectInteractObjectivesCount = M(questObjectives):countf(isObjectInteraction):value();
        if objectInteractObjectivesCount == questObjectivesCount then
            return "ObjectInteractionObjective";
        end

        local lootObjectivesCount = M(questObjectives):countf(isLoot):value();
        if lootObjectivesCount == questObjectivesCount then
            return "LootObjective";
        end

        -- local setFreeObjectivesCount = M(questObjectives):countf(isSetFree):value();
        -- if setFreeObjectivesCount == questObjectivesCount then
        --     return "SetFreeObjective";
        -- end

        -- TODO: Other types of objectives

        return nil;
    end
end

function Virtual_StepWithObjectivesMixin:GetObjectivesType()
    if (not self:HasCache("GetObjectivesType")) then
        self:SetCache("GetObjectivesType", getObjectivesType(self:GetQuestObjectives()));
    end
    return self:GetCache("GetObjectivesType");
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.Virtual_StepWithObjectives = Virtual_StepWithObjectivesMixin;
