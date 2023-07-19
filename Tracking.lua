local _, core = ...

local function onClick(self, id)
	C_Minimap.SetTracking(id, on)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = MiniMapTrackingDropDown_Initialize

local module = core:NewModule("Tracking", {
	type = "data source",
	label = "Tracking",
	icon = [[Interface\Icons\Ability_Tracking]],
	OnClick = function(self)
		dropdown:Toggle(nil, self)
	end,
	OnTooltipShow = function(self)
		self:SetText(TRACKING, 1, 1, 1)
		self:AddLine(MINIMAP_TRACKING_TOOLTIP_NONE, nil, nil, nil, true)
	end,
})

function module:OnInitialize()
	self:RegisterEvent("MINIMAP_UPDATE_TRACKING")
end

function module:MINIMAP_UPDATE_TRACKING()
	dropdown:Rebuild()
end
