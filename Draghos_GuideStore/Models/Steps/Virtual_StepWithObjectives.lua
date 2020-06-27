local Lambdas = DraghosUtils.Lambdas;

local Virtual_StepWithObjectivesMixin = {};

-- *********************************************************************************************************************
-- ***** Quest with objectives
-- *********************************************************************************************************************

function Virtual_StepWithObjectivesMixin:AllObjectivesHaveBeenFetched()
    local currentQuestObjectives = self:GetQuestObjectives();

    if self.questObjectivesIndexes == nil and currentQuestObjectives:Count() ~=
        C_QuestLog.GetNumQuestObjectives(self.questID) then
        return false;
    elseif self.questObjectivesIndexes ~= nil and currentQuestObjectives:Count() ~= #self.questObjectivesIndexes then
        return false;
    else
        return true;
    end
end

local isSameQuestObjective = function(obj1, obj2)
    return obj1.index == obj2.index;
end

-- Sometimes (after login for instance), the objectives are not loaded so we need to add them after
function Virtual_StepWithObjectivesMixin:GetStepLines()
    if not self:AllObjectivesHaveBeenFetched() then
        -- The last fetch couldn't get all the objectives
        local newQuestObjectives = self:CreateQuestObjectives();
        self:AddMultipleStepLines(newQuestObjectives:Distinct(isSameQuestObjective));
        -- self:ClearCache("GetStepLines");
    end

    return DraghosMixins.Step.GetStepLines(self);
end

local isCombat = Lambdas.SelfResult("IsCombat");
local isObjectInteraction = Lambdas.SelfResult("IsObjectInteraction");
local isLoot = Lambdas.SelfResult("IsLoot");

local function getObjectivesType(questObjectives)
    local questObjectivesCount = #questObjectives;
    if questObjectivesCount == 0 then
        return nil;
    else
        local combatObjectivesCount = questObjectives:Count(isCombat);
        if combatObjectivesCount == questObjectivesCount then
            return "CombatObjective";
        end

        local objectInteractObjectivesCount = questObjectives:Count(isObjectInteraction);
        if objectInteractObjectivesCount == questObjectivesCount then
            return "ObjectInteractionObjective";
        end

        local lootObjectivesCount = questObjectives:Count(isLoot);
        if lootObjectivesCount == questObjectivesCount then
            return "LootObjective";
        end

        -- local setFreeObjectivesCount = questObjectives:Count(isSetFree);
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
