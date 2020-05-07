--- @class Task
--- @field public taskID number
--- @field public title string
--- @field public isActive boolean
--- @field public repeating number
--- @field public steps Step[]
TaskMixin = {};

TASK_REPEAT_NEVER = 1;
TASK_REPEAT_DAILY = 2;
TASK_REPEAT_WEEKLY = 3;
TASK_REPEAT_BIWEEKLY = 4;
TASK_REPEAT_MONTHLY = 5;

TaskRepeats = {
    [TASK_REPEAT_NEVER] = {
        Label = CALENDAR_REPEAT_NEVER,
        --- @param step Step
        --- @return boolean
        IsCompleted = function(step)
            return not not step.lastCompleted;
        end
    },
    [TASK_REPEAT_DAILY] = {
        Label = CALENDAR_REPEAT_DAILY,
        --- @param step Step
        --- @return boolean
        IsCompleted = function(step)
            local currentTime = time();
            local elapsed = Elapsed(step.lastCompleted, currentTime);
            return not (elapsed.years > 0 or elapsed.months > 0 or elapsed.days > 0);
        end
    },
    [TASK_REPEAT_WEEKLY] = {
        Label = CALENDAR_REPEAT_WEEKLY,
        --- @param step Step
        --- @return boolean
        IsCompleted = function(step)
            local currentTime = time();
            local elapsed = Elapsed(step.lastCompleted, currentTime);
            return not (elapsed.years >= 0 or elapsed.months >= 0 or elapsed.days >= 7);
        end
    },
    [TASK_REPEAT_BIWEEKLY] = {
        Label = CALENDAR_REPEAT_BIWEEKLY,
        --- @param step Step
        --- @return boolean
        IsCompleted = function(step)
            local currentTime = time();
            local elapsed = Elapsed(step.lastCompleted, currentTime);
            return not (elapsed.years >= 0 or elapsed.months >= 0 or elapsed.days >= 15);
        end
    },
    [TASK_REPEAT_MONTHLY] = {
        Label = CALENDAR_REPEAT_MONTHLY,
        --- @param step Step
        --- @return boolean
        IsCompleted = function(step)
            local currentTime = time();
            local elapsed = Elapsed(step.lastCompleted, currentTime);
            return not (elapsed.years >= 0 or elapsed.months >= 0);
        end
    }
}

local function AsStepMixin(step)
    return CreateAndInitFromMixin(StepMixin, step);
end

--- @param task Task
--- @return boolean
function TaskMixin:Init(task)
    if not task then
        return false;
    end

    self.taskID = task.taskID;
    self.title = task.title;
    self.isActive = task.isActive;
    self.repeating = task.repeating;
    self.steps = Map((task.steps or {}), AsStepMixin);

    return true;
end

--- @returns number
function TaskMixin:IsValid()
    if IsBlankString(self.title) then
        return false;
    elseif type(self.isActive) ~= "boolean" then
        return false;
    elseif not TaskRepeats[self.repeating] then
        return false;
    elseif not self.steps or #self.steps == 0 then
        return false;
    else
        return true;
    end
end

function TaskMixin:Save()
    --- @param step Step
    --- @return table
    local function GetStepValues(step)
        return step:GetValues();
    end

    local task = {
        taskID = self.taskID,
        title = self.title,
        isActive = self.isActive,
        repeating = self.repeating,
        steps = Map(self.steps, GetStepValues)
    };

    local index = Draghos_TaskLog:GetTaskIndexByTaskID(self.taskID);
    if index then
        Draghos_TaskLog:UpdateTask(task, index);
    else
        Draghos_TaskLog:AddTask(task);
    end
end

--- @returns number
function TaskMixin:GetID()
    return self.taskID;
end

--- @returns boolean
function TaskMixin:IsCompleted()
    local function IsStepCompleted(step)
        return step:IsCompleted();
    end
    return #self.steps > 0 and not Any(Map(self.steps, IsStepCompleted), false);
end

--- @returns boolean
function TaskMixin:IsModified()
    local storedTask = Draghos_TaskLog:GetTaskByTaskID(self.taskID);
    if not storedTask then
        return true;
    else
        if #self.steps ~= #storedTask.steps then
            return true;
        else
            for i, step in pairs(self.steps) do
                if not step:IsEqual(storedTask.steps[i]) then
                    return true;
                end
            end
        end
        return self.title ~= storedTask.title or self.isActive ~= storedTask.isActive or self.repeating ~=
                   storedTask.repeating;
    end
end

--- @returns boolean
local function IsManual(step)
    return step.type == STEP_TYPE_MANUAL;
end

function TaskMixin:StopTracking()
    self.isActive = false;
    self:Save();
end

function TaskMixin:AddStep(step)
    local newStep = AsStepMixin(step);
    table.insert(self.steps, newStep);
end

function TaskMixin:UpdateStep(step, index)
    local newStep = AsStepMixin(step);
    table.insert(self.steps, index, newStep);
end

function TaskMixin:RemoveStep(index)
    table.remove(self.steps, index);
end

--- @returns Step[]
function TaskMixin:GetSteps()
    local function CreateStep(step)
        return CreateAndInitFromMixin(StepMixin, step);
    end
    return Map(self.steps, CreateStep);
end

--- @returns Step[]
function TaskMixin:GetManualSteps()
    return FilterIndexed(self.steps, IsManual);
end

--- @returns boolean
function TaskMixin:HasManualSteps()
    return Any(self.steps, IsManual);
end
