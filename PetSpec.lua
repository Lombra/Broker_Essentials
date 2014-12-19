if select(2, UnitClass("player")) ~= "HUNTER" then return end

local _, core = ...

local function onClick(self)
	SetSpecialization(self.value, true)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.xOffset = 0
dropdown.yOffset = 0
dropdown.initialize = function(self, level)
	for i = 1, GetNumSpecializations(nil, true) do
		local _, name, _, icon = GetSpecializationInfo(i, false, true)
		local info = UIDropDownMenu_CreateInfo()
		info.text = name
		info.value = i
		info.func = onClick
		info.checked = GetSpecialization(false, true) == i
		self:AddButton(info)
	end
end

local module = core:NewModule("PetSpec", {
	type = "data source",
	label = "PetSpec",
	OnClick = function(self)
		dropdown:ToggleMenu(nil, self)
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN", "Update")
	-- self:RegisterEvent("PLAYER_TALENT_UPDATE", "Update")
	self:RegisterEvent("PET_SPECIALIZATION_CHANGED", "Update")
end

function module:Update()
	local spec = GetSpecialization(false, true)
	if spec then
		local _, name, _, icon = GetSpecializationInfo(spec, false, true)
		self.text = name
		self.icon = icon
	else
		self.text = NONE
		self.icon = [[Interface\Icons\Ability_Marksmanship]]
	end
end