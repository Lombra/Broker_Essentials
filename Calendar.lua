local _, core = ...

local module = core:NewModule("Calendar", {
	type = "launcher",
	label = "Calendar",
	icon = [[Interface\Icons\SPELL_HOLY_BORROWEDTIME]],
	OnClick = function(self)
		ToggleCalendar()
	end,
	OnTooltipShow = function(self)
		self:SetText(GAMETIME_TOOLTIP_TOGGLE_CALENDAR)
	end,
})

local UPDATE_INTERVAL = 1
local lastUpdate = 0

module:SetOnUpdate(function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	while lastUpdate > UPDATE_INTERVAL do
		local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
		self.iconAtlas = format("ui-hud-calendar-%d-mouseover", currentCalendarTime.monthDay)
		lastUpdate = lastUpdate - UPDATE_INTERVAL
	end
end)
