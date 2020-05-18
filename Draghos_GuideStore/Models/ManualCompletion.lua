local ManualCompletionMixin = {};

Mixin(ManualCompletionMixin, DraghosMixins.Observable);

function ManualCompletionMixin:ManualCompletionInit()
    Draghos_GuideStore:RegisterForNotifications(self, "DRAGHOS_STEP_COMPLETION_CHANGED");
end

function ManualCompletionMixin:IsManualCompletion()
    return true;
end
function ManualCompletionMixin:IsFlaggedManuallyCompleted()
    return DraghosStepsCompletedDB and DraghosStepsCompletedDB[self.stepID];
end

DraghosMixins.ManualCompletion = ManualCompletionMixin;
