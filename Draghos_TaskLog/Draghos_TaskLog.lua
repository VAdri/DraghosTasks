Draghos_TaskLog = {TaskCache = nil, Subscribers = {}};

-- *********************************************************************************************************************
-- ***** UTILS
-- *********************************************************************************************************************

local function IsTaskWatched(task)
    return task.isActive;
end

local function FindByTaskID(taskID)
    return function(task)
        return task and task.taskID == taskID or false;
    end
end

local function GetTaskID(task)
    return task.taskID;
end

local function NewTaskID()
    local taskIDs = Map(Draghos_TaskLog:GetTasks(), GetTaskID);
    if #taskIDs > 0 then
        return math.max(unpack(taskIDs)) + 1;
    else
        return 1;
    end
end

-- *********************************************************************************************************************
-- ***** STORE
-- *********************************************************************************************************************

--- @return Task[]
function Draghos_TaskLog:GetTasks()
    if not self.TaskCache then
        local initTask = function(task)
            return CreateAndInitFromMixin(TaskMixin, task);
        end;
        self.TaskCache = Map(TaskLogSaved or {}, initTask);
        self:RaiseChange();
    end
    return self.TaskCache;
end

function Draghos_TaskLog:RaiseChange()
    for _, handler in pairs(self.Subscribers) do
        handler();
    end
end

--- @param handler function
function Draghos_TaskLog:Subscribe(handler)
    table.insert(self.Subscribers, handler);
end

-- *********************************************************************************************************************
-- ***** WRITE DATA
-- *********************************************************************************************************************

--- @param task Task
--- @param index number
function Draghos_TaskLog:UpdateTask(task, index)
    if not TaskLogSaved then
        TaskLogSaved = {};
    end
    for key, value in pairs(task) do
        TaskLogSaved[index][key] = value;
    end
    self.TaskCache = nil;
    self:RaiseChange();
end

--- @param task Task
function Draghos_TaskLog:AddTask(task)
    if not TaskLogSaved then
        TaskLogSaved = {};
    end
    task.taskID = NewTaskID();
    table.insert(TaskLogSaved, task);
    self.TaskCache = nil;
    self:RaiseChange();
end

--- @param taskID number
function Draghos_TaskLog:RemoveTaskByID(taskID)
    if not TaskLogSaved then
        TaskLogSaved = {};
    end
    local index = Draghos_TaskLog:GetTaskIndexByTaskID(taskID);
    if index then
        table.remove(TaskLogSaved, index);
        self.TaskCache = nil;
        self:RaiseChange();
        return true;
    else
        return false;
    end
end

-- *********************************************************************************************************************
-- ***** READ DATA
-- *********************************************************************************************************************

--- @return number
function Draghos_TaskLog:GetNumTaskWatches()
    return #Filter(self:GetTasks(), IsTaskWatched);
end

--- @param index number
--- @return Task|nil
function Draghos_TaskLog:GetTaskForTaskWatchIndex(index)
    return Filter(self:GetTasks(), IsTaskWatched)[index];
end

--- @return number
function Draghos_TaskLog:GetNumTaskLog()
    return #self:GetTasks();
end

--- @param index number
--- @return Task|nil
function Draghos_TaskLog:GetTaskForTaskLogIndex(index)
    return self:GetTasks()[index];
end

--- @param taskID number
--- @return number|nil
function Draghos_TaskLog:GetTaskIndexByTaskID(taskID)
    return FindIndex(self:GetTasks(), FindByTaskID(taskID));
end

--- @param taskID number
--- @return Task|nil
function Draghos_TaskLog:GetTaskByTaskID(taskID)
    return Find(self:GetTasks(), FindByTaskID(taskID));
end
