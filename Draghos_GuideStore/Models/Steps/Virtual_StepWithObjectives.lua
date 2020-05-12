Virtual_StepWithObjectivesMixin = {};

local function IsQuestObjective(object)
    return object.QuestObjectiveInit ~= nil;
end

-- local function IsCombatObjective(questObjective)
--     return questObjective:IsCombat();
-- end

-- local function IsSetFreeObjective(questObjective)
--     return questObjective:IsSetFree();
-- end

function Virtual_StepWithObjectivesMixin:GetObjectivesType()
    local questObjectives = Filter(self.stepLines, IsQuestObjective);
    local questObjectivesCount = #questObjectives;
    if questObjectivesCount == 0 then
        return nil;
    else
        local combatObjectivesCount = Count(questObjectives, CallOnSelf("IsCombat"));
        if combatObjectivesCount == questObjectivesCount then
            return "CombatObjective";
        end

        local objectInteractObjectivesCount = Count(questObjectives, CallOnSelf("IsObjectInteraction"));
        if objectInteractObjectivesCount == questObjectivesCount then
            return "ObjectInteractionObjective";
        end

        -- local setFreeObjectivesCount = Count(questObjectives, CallOnSelf("IsSetFree"));
        -- if setFreeObjectivesCount == questObjectivesCount then
        --     return "SetFreeObjective";
        -- end

        -- TODO: Other types of objectives

        return nil;
    end
end
