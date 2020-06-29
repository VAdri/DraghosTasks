local TaxiNodeMixin = {};

Mixin(TaxiNodeMixin, DraghosMixins.Observable);
Mixin(TaxiNodeMixin, DraghosMixins.Zone);

function TaxiNodeMixin:TaxiNodeInit(taxiNode)
    taxiNode = taxiNode or {};

    self:ZoneInit(taxiNode.location);

    self.nodeID = tonumber(taxiNode.nodeID);
    if self.nodeID then
        self.taxiNode = Draghos_GuideStore:GetTaxiNodeByID(self.nodeID);

        self:AddOneStepLine(DraghosMixins.StepLineSpeakTo.New(self.taxiNode));
        self.flightMaster = self.stepLines:Last();
    end

    Draghos_GuideStore:RegisterForNotifications(self, "DRAGHOS_NEWTAXIPATH");
end

function TaxiNodeMixin:IsValidTaxiNode()
    return self.nodeID and self.taxiNode and self:IsValidZone() and self.flightMaster and self.flightMaster:IsValidNPC();
end

function TaxiNodeMixin:IsTaxiNodeDiscovered()
    return DraghosTaxiNodesDB and DraghosTaxiNodesDB[self.nodeID] == true;
end

function TaxiNodeMixin:GetFlightMasterName()
    return self.flightMaster:GetNPCName();
end

DraghosMixins.TaxiNode = TaxiNodeMixin;
