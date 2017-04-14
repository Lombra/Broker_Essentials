local _, core = ...

local function onClick(self, set)
	EquipmentManager_EquipSet(set)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self)
	for i, id in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
		local name, icon, setID, isEquipped, numItems, numEquipped, numInventory, numMissing, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(id)
		local info = UIDropDownMenu_CreateInfo()
		info.text = name
		info.func = onClick
		info.arg1 = id
		info.isNotRadio = true
		info.checked = isEquipped
		self:AddButton(info)
	end
end

local module = core:NewModule("EquipmentSets", {
	type = "data source",
	label = "Equipment sets",
	icon = [[Interface\PaperDollInfoFrame\UI-GearManager-Button]],
	OnClick = function(self)
		dropdown:Toggle(nil, self)
	end,
	-- OnTooltipShow = function(self)
		-- GetEquipmentSetLocations("name")
	-- end,
})

function module:OnInitialize()
	self:RegisterEvent("EQUIPMENT_SETS_CHANGED", "Update")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "Update")
	self:RegisterEvent("BAG_UPDATE_DELAYED", "Update")
end

function module:Update()
	local equipped
	local mostEquipped = 0
	for i, id in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
		local name, icon, setID, isEquipped, numItems, numEquipped, numInventory, numMissing, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(id)
		if numEquipped > mostEquipped then
			equipped = id
			mostEquipped = numEquipped
		end
	end
	if equipped then
		local name, icon, setID, isEquipped, numItems, numEquipped, numInventory, numMissing, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(equipped)
		if isEquipped then
			self.text = name
		else
			self.text = format("%s (|cffff2020-%d|r)", name, numItems - numEquipped)
		end
	else
		self.text = "N/A"
	end
end