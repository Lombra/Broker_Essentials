local _, core = ...

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self)
	-- API sometimes doesn't return stuff until we call this
	-- C_ToyBox.ForceToyRefilter()
	for i = 1, C_ToyBox.GetNumToys() do
		local itemID, toyName, icon, isFavorite = C_ToyBox.GetToyInfo(C_ToyBox.GetToyFromIndex(i))
		if isFavorite then
			local info = UIDropDownMenu_CreateInfo()
			info.text = toyName
			info.icon = icon
			info.notCheckable = true
			info.attributes = {
				["type"] = "toy",
				["toy"] = itemID,
			}
			self:AddButton(info)
		end
	end
end

local module = core:NewModule("Toys", {
	type = "data source",
	text = "Ready",
	label = "Toys",
	icon = [[Interface\Icons\Trade_Archaeology_ChestofTinyGlassAnimals]],
	OnClick = function(self)
		if not InCombatLockdown() then
			dropdown:Toggle(nil, self)
		end
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function module:PLAYER_REGEN_ENABLED()
	self.text = "Ready"
end

function module:PLAYER_REGEN_DISABLED()
	self.text = "|cffff0000In combat|r"
	dropdown:Close()
end