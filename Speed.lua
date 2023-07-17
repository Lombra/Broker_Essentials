local _, core = ...

local currentUnit = "player"

local format = string.format
local GetUnitSpeed = GetUnitSpeed
local IsSwimming = IsSwimming
local IsFalling = IsFalling

local function getSpeedText(formatString, speed)
	return format(formatString, speed / BASE_MOVEMENT_SPEED * 100 + 0.5)
end

local module = core:NewModule("Speed", {
	type = "data source",
	text = "Speed",
	label = "Speed",
	icon = [[Interface\Icons\Ability_Rogue_Sprint]],
	OnTooltipShow = function(self)
		local _, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player")
		local speed = runSpeed
		if IsSwimming() then
			speed = swimSpeed
		elseif IsFlying() then
			speed = flightSpeed
		end
		self:AddLine(format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_MOVEMENT_SPEED).." "..getSpeedText("%d%%", speed), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		self:AddLine(getSpeedText(STAT_MOVEMENT_GROUND_TOOLTIP, runSpeed))
		self:AddLine(getSpeedText(STAT_MOVEMENT_FLIGHT_TOOLTIP, flightSpeed))
		self:AddLine(getSpeedText(STAT_MOVEMENT_SWIM_TOOLTIP, swimSpeed))
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_STARTED_MOVING")
	self:RegisterEvent("PLAYER_STOPPED_MOVING")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
end

local function onUpdate(self)
	-- Hack so that your speed doesn't appear to change when jumping out of the water
	-- if IsFalling() then
		-- if self.wasSwimming then
			-- speed = swimSpeed
		-- end
	-- else
		-- self.wasSwimming = IsSwimming()
	-- end
	local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
	self.text = getSpeedText("%d%%", isGliding and forwardSpeed or GetUnitSpeed(currentUnit))
end

function module:PLAYER_ENTERING_WORLD()
	if UnitInVehicle("player") then
		currentUnit = "vehicle"
	end
	if IsPlayerMoving() or GetUnitSpeed(currentUnit) > 0 then
		self:PLAYER_STARTED_MOVING()
	else
		self:PLAYER_STOPPED_MOVING()
	end
end

function module:PLAYER_STARTED_MOVING()
	self:SetOnUpdate(onUpdate)
end

function module:PLAYER_STOPPED_MOVING()
	self:RemoveOnUpdate()
	-- onUpdate(self)
	self.text = "0%"
end

function module:UNIT_ENTERED_VEHICLE(unit)
	if unit == "player" then
		currentUnit = "vehicle"
	end
end

function module:UNIT_EXITED_VEHICLE(unit)
	if unit == "player" then
		currentUnit = "player"
	end
end
