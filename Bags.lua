local _, core = ...

local module = core:NewModule("Bags", {
	type = "data source",
	label = "Bags",
	icon = [[Interface\Icons\INV_Misc_Bag_08]],
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN")
end

function module:PLAYER_LOGIN()
	self:UpdateSlots()
	self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateSlots")
end

function module:UpdateSlots()
	local totalFree = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local freeSlots, bagFamily = C_Container.GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end
	self.text = format("%d slots free", totalFree)
end
