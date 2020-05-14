local FP = DraghosUtils.FP;

Virtual_StepWithObjectivesMixin = {};

local function IsQuestObjective(object)
    return object.QuestObjectiveInit ~= nil;
end

function Virtual_StepWithObjectivesMixin:GetObjectivesType()
    local questObjectives = FP:Filter(self.stepLines, IsQuestObjective);
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
