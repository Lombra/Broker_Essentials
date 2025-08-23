local _, core = ...

local function onClick(self, spec)
	C_SpecializationInfo.SetSpecialization(spec)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.xOffset = 0
dropdown.yOffset = 0
dropdown.initialize = function(self, level)
	local specIndex = C_SpecializationInfo.GetSpecialization()
	for i = 1, GetNumSpecializations() do
		local id, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(i)
		local info = UIDropDownMenu_CreateInfo()
		info.text = name
		info.func = onClick
		info.arg1 = i
		info.checked = (i == specIndex)
		self:AddButton(info)
	end
end

local module = core:NewModule("Spec", {
	type = "data source",
	label = "Spec",
	OnClick = function(self)
		dropdown:ToggleMenu(nil, self)
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN", "Update")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "Update")
end

function module:Update()
	local spec = C_SpecializationInfo.GetSpecialization()
	if spec then
		local _, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(spec)
		self.text = name
		self.icon = icon
	else
		self.text = NONE
		self.icon = [[Interface\Icons\Ability_Marksmanship]]
	end
end
