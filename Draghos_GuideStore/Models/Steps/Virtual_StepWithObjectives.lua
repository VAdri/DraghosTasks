local FP = DraghosUtils.FP;

local Virtual_StepWithObjectivesMixin = {};

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
        self.stepLines = FP:UniqueBy(FP:Concat(self.stepLines or {}, newQuestObjectives), "index");
    end

    return self.stepLines or {};
end

function Virtual_StepWithObjectivesMixin:GetObjectivesType()
    local questObjectives = self:GetQuestObjectives();
    local questObjectivesCount = #questObjectives;
    if questObjectivesCount == 0 then
        return nil;
    else
        local combatObjectivesCount = FP:Count(questObjectives, FP:CallOnSelf("IsCombat"));
        if combatObjectivesCount == questObjectivesCount then
            return "CombatObjective";
        end

        local objectInteractObjectivesCount = FP:Count(questObjectives, FP:CallOnSelf("IsObjectInteraction"));
        if objectInteractObjectivesCount == questObjectivesCount then
            return "ObjectInteractionObjective";
        end

        local lootObjectivesCount = FP:Count(questObjectives, FP:CallOnSelf("IsLoot"));
        if lootObjectivesCount == questObjectivesCount then
            return "LootObjective";
        end

        -- local setFreeObjectivesCount = Count(questObjectives, CallOnSelf("IsSetFree"));
        -- if setFreeObjectivesCount == questObjectivesCount then
        --     return "SetFreeObjective";
        -- end

        -- TODO: Other types of objectives

        return nil;
    end
end

DraghosMixins.Virtual_StepWithObjectives = Virtual_StepWithObjectivesMixin;
