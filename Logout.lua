local _, core = ...

local module = core:NewModule("Logout", {
	type = "launcher",
	label = LOGOUT,
	icon = [[Interface\Icons\Ability_TownWatch]],
	OnClick = function(self, button)
		if IsShiftKeyDown() then
			ForceQuit()
		elseif button == "LeftButton" then
			Logout()
		elseif button == "RightButton" then
			Quit()
		end
	end,
	OnTooltipShow = function(self)
		self:AddLine("Broker: Logout", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		self:AddLine("Left-click to logout.", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		self:AddLine("Right-click to exit.", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		self:AddLine("Shift-click to force exit.", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	end
})