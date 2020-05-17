local FP = DraghosUtils.FP;

-- *********************************************************************************************************************
-- ***** TAXI NODES DATABASE
-- *********************************************************************************************************************

local TaxiNodesStore = CreateFrame("Frame");

local function IsTaxiDiscovered(taxiNode)
    return taxiNode.state == Enum.FlightPathState.Reachable or taxiNode.state == Enum.FlightPathState.Current;
end

local function OnEvent(self, event, ...)
    if event == "UI_INFO_MESSAGE" then
        local _, message = ...;
        if message == ERR_NEWTAXIPATH then
            -- The player has just discovered a new taxi node but the taxi map is not opened, so we just assume that the
            -- taxi node for the current zone is discovered.

            -- Get the taxi node for the current zone
            local function IsInCurrentZone(taxiNode)
                if taxiNode.location then
                    local zone = Draghos_GuideStore:CreateBaseItem(DraghosMixins.Zone, taxiNode.location);
                    return zone and zone:IsValidZone() and zone:PlayerIsInZone();
                end
            end

            local currentTaxiNode = FP:Find(Draghos_GuideStore.taxiNodes, IsInCurrentZone);
            if currentTaxiNode and currentTaxiNode.nodeID then
                -- A taxi node has been found in the current player's zone so it is probably the one discovered
                TaxiNodesDB = TaxiNodesDB or {};
                TaxiNodesDB[currentTaxiNode.nodeID] = true;

                Draghos_GuideStore:SendCustomEvent("DRAGHOS_NEWTAXIPATH");
            end
        end
    elseif event == "TAXIMAP_OPENED" then
        -- The flight map is opened so we can add all the flights that are reachable
        local mapID = FlightMapFrame:GetMapID();
        local taxiNodes = C_TaxiMap.GetAllTaxiNodes(mapID);

        local taxiNodesDiscovered = FP:Filter(taxiNodes, IsTaxiDiscovered);
        if taxiNodesDiscovered and #taxiNodesDiscovered > 0 then
            -- Set the nodes as discovered
            local taxiNodeIDs = FP:MapProp(taxiNodesDiscovered, "nodeID");
            TaxiNodesDB = FP:FillWith(TaxiNodesDB or {}, taxiNodeIDs, true);

            Draghos_GuideStore:SendCustomEvent("DRAGHOS_NEWTAXIPATH");
        end
    end
end

TaxiNodesStore:SetScript("OnEvent", OnEvent);

TaxiNodesStore:RegisterEvent("TAXIMAP_OPENED");
TaxiNodesStore:RegisterEvent("UI_INFO_MESSAGE");