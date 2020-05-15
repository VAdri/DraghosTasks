local ExperienceMixin = {};

Mixin(ExperienceMixin, DraghosMixins.Observable);

function ExperienceMixin:ExperienceInit(experience)
    self.level = tonumber(experience.level);
    self.xp = tonumber(experience.xp);

    Draghos_GuideStore:RegisterForNotifications(self, "PLAYER_XP_UPDATE");
    Draghos_GuideStore:RegisterForNotifications(self, "PLAYER_LEVEL_UP");
    Draghos_GuideStore:RegisterForNotifications(self, "PLAYER_LEVEL_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "PLAYER_LEVEL_CHANGED");
    Draghos_GuideStore:RegisterForNotifications(self, "PLAYER_UPDATE_RESTING");
    Draghos_GuideStore:RegisterForNotifications(self, "UPDATE_EXHAUSTION");
end

function ExperienceMixin:GetExperienceLabel()
    if self.xp <= 0 then
        return LEVEL_GAINED:format(self.level);
    else
        return LEVEL_AND_XP:format(self.level, self.xp);
    end
end

function ExperienceMixin:IsValidExperience()
    return self.level ~= nil and self.xp ~= nil;
end

function ExperienceMixin:IsAboveLevelXP()
    return UnitLevel("player") > self.level or (UnitLevel("player") == self.level and UnitXP("player") >= self.xp);
end

function ExperienceMixin:GetXPRequired()
    if self.level == UnitLevel("player") then
        return true, UnitXP("player"), self.xp;
    elseif self.level == UnitLevel("player") + 1 and self.xp <= 0 then
        return true, UnitXP("player"), UnitXPMax("player");
    else
        return false, UnitXP("player"), UnitXPMax("player");
    end
end

DraghosMixins.Experience = ExperienceMixin;
