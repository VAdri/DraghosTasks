local StepDiscoverTaxiNodeMixin = {}

-- *********************************************************************************************************************
-- ***** Mixins
-- *********************************************************************************************************************

Mixin(StepDiscoverTaxiNodeMixin, DraghosMixins.Step);
Mixin(StepDiscoverTaxiNodeMixin, DraghosMixins.TaxiNode);

-- *********************************************************************************************************************
-- ***** Init
-- *********************************************************************************************************************

function StepDiscoverTaxiNodeMixin:Init(step)
    self:StepInit(step);
    self:TaxiNodeInit(step.taxiNode);
end

-- *********************************************************************************************************************
-- ***** Public
-- *********************************************************************************************************************

function StepDiscoverTaxiNodeMixin:GetStepType()
    return "FlightMaster";
end

function StepDiscoverTaxiNodeMixin:GetLabel()
    return DISCOVER_FLIGHT_PATH_AT:format(self:GetZoneName());
end

function StepDiscoverTaxiNodeMixin:IsValid()
    return self:IsValidStep() and self:IsValidTaxiNode();
end

function StepDiscoverTaxiNodeMixin:IsCompleted()
    return self:IsTaxiNodeDiscovered();
end

-- *********************************************************************************************************************
-- ***** Export
-- *********************************************************************************************************************

DraghosMixins.StepDiscoverTaxiNode = StepDiscoverTaxiNodeMixin;
