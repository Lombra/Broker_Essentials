local _, core = ...

local function onClick(self, specID)
	SetLootSpecialization(specID)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	local specIndex = GetSpecialization()
	if specIndex then
		local specID, specName = GetSpecializationInfo(specIndex)
		if specName then
			local info = UIDropDownMenu_CreateInfo()
			info.text = format(LOOT_SPECIALIZATION_DEFAULT, specName)
			info.func = onClick
			info.arg1 = 0
			info.checked = GetLootSpecialization() == 0
			self:AddButton(info)
		end
	end
	for i = 1, GetNumSpecializations() do
		local id, name, _, icon = GetSpecializationInfo(i)
		local info = UIDropDownMenu_CreateInfo()
		info.text = name
		info.func = onClick
		info.arg1 = id
		info.checked = GetLootSpecialization() == id
		self:AddButton(info)
	end
end

local module = core:NewModule("LootSpec", {
	type = "data source",
	label = "LootSpec",
	OnClick = function(self)
		dropdown:ToggleMenu(nil, self)
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN")
end

function module:PLAYER_LOGIN()
	self:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED", "Update")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "Update")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "Update")
	self:Update()
end

function module:Update()
	local lootSpec = GetLootSpecialization()
	local spec = GetSpecialization()
	if lootSpec and spec then
		if lootSpec == 0 then
			lootSpec = GetSpecializationInfo(spec)
		end
		-- sometimes nil after loading screens
		if lootSpec == nil then
			return
		end
		local _, name, _, icon = GetSpecializationInfoByID(lootSpec)
		self.text = name
		self.icon = icon
	else
		self.text = NONE
		self.icon = [[Interface\Icons\Ability_Marksmanship]]
	end
end
