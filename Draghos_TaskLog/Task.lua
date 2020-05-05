--- @class Task
--- @field public taskID number
--- @field public title string
--- @field isActive boolean
--- @field public repeating number
TaskMixin = {};

TASK_REPEAT_NEVER = 1;
TASK_REPEAT_DAILY = 2;
TASK_REPEAT_WEEKLY = 3;
TASK_REPEAT_BIWEEKLY = 4;
TASK_REPEAT_MONTHLY = 5;

TaskRepeats = {
    [TASK_REPEAT_NEVER] = {},
    [TASK_REPEAT_DAILY] = {},
    [TASK_REPEAT_WEEKLY] = {},
    [TASK_REPEAT_BIWEEKLY] = {},
    [TASK_REPEAT_MONTHLY] = {}
}

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

    return true;
end

--- @param taskID number|nil
--- @param title string
--- @param isActive boolean
--- @param repeating number
--- @return Task
function TaskMixin:Create(taskID, title, isActive, repeating)
    local result = CreateFromMixins(TaskMixin);
    result.taskID = taskID;
    result.title = title;
    result.isActive = isActive;
    result.repeating = repeating;
    return result;
end

function TaskMixin:IsValid()
    if IsBlankString(self.title) then
        return false;
    elseif type(self.isActive) ~= "boolean" then
        return false;
    elseif not TaskRepeats[self.repeating] then
        return false;
    else
        return true;
    end
end

function TaskMixin:Save()
    local task = {taskID = self.taskID, title = self.title, isActive = self.isActive, repeating = self.repeating};

    local index = Draghos_TaskLog:GetTaskIndexByTaskID(self.taskID);
    if index then
        Draghos_TaskLog:UpdateTask(task, index);
    else
        Draghos_TaskLog:AddTask(task);
    end
end

function TaskMixin:GetID()
    return self.taskID;
end

function TaskMixin:IsCompleted()
    -- TODO
    return false;
end

function TaskMixin:IsModified()
    local storedTask = Draghos_TaskLog:GetTaskByTaskID(self.taskID);
    if not storedTask then
        return true;
    else
        return self.title ~= storedTask.title or self.isActive ~= storedTask.isActive or self.repeating ~=
                   storedTask.repeating;
    end
end

function TaskMixin:StopTracking()
    self.isActive = false;
    self:Save();
end
