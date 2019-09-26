local _, core = ...

local module = core:NewModule("ReloadUI", {
	type = "launcher",
	label = "Reload UI",
	icon = [[Interface\PaperDollInfoFrame\UI-GearManager-Undo]],
	OnClick = C_UI.Reload,
	OnTooltipShow = function(self)
		self:AddLine("ReloadUI", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		self:AddLine("Click to reload UI.")
	end
})