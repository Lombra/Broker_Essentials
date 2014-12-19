local _, core = ...

local module = core:NewModule("DualSpec", {
	type = "data source",
	label = "DualSpec",
	OnClick = function(self)
		SetActiveSpecGroup(3 - GetActiveSpecGroup())
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN", "Update")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "Update")
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "Update")
end

function module:Update()
	local spec = GetSpecialization()
	if spec then
		local _, name, _, icon = GetSpecializationInfo(spec)
		self.text = name
		self.icon = icon
	else
		self.text = NONE
		self.icon = [[Interface\Icons\Ability_Marksmanship]]
	end
end