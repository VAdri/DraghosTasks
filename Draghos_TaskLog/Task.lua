local TaskMixin = {};

function TaskMixin:Init(taskID)
    self.taskID = taskID;
    self.title = "Test" .. taskID;
end

function TaskMixin:GetID()
    return self.taskID;
end

TaskCache = _ObjectCache_Create(TaskMixin);
