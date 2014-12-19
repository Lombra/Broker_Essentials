local _, core = ...

local db

local inventoryPct, backpackPct
local slotDetails = {}

local slots = {
	"HeadSlot",
	"ShoulderSlot",
	"ChestSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
}

local function onClick(self, arg)
	db[arg] = not db[arg]
	module:Update()
end

local menu = {
	{
		text = "Durability",
		isTitle = true,
		notCheckable = true,
	},
	{
		text = "Hide empty slots",
		arg1 = "hideEmptySlots",
		isNotRadio = true,
		keepShownOnClick = true,
	},
	{
		text = "Show most damaged item",
		arg1 = "showMostDamaged",
		isNotRadio = true,
		keepShownOnClick = true,
	},
}

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self)
	for i, v in ipairs(menu) do
		v.func = onClick
		v.checked = db[v.value]
		self:AddButton(v)
	end
end

local function getColoredText(percent)
	local r, g

	if percent >= 0.5 then
		r = (1 - percent) * 2
		g = 1
	else
		r = 1
		g = percent * 2
	end

	return format("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, 0, (percent * 100))
end

local function getPercentage(current, total)
	if current and total > 0 then
		local perc = current / total
		local fixed = perc
		-- make sure we never round down to 0 to be able to distinguish between completely broken and fully functional
		if perc > 0 then
			fixed = max(0.01, perc)
		end
		return fixed, perc
	end
end

local module = core:NewModule("Durability", {
	type = "data source",
	text = "n/a",
	label = "Durability",
	icon = [[Interface\Icons\Trade_BlackSmithing]],
	OnClick = function(self)
		dropdown:Toggle(nil, self)
	end,
	OnTooltipShow = function(self)
		self:AddLine("Durability", HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		
		for i, slot in ipairs(slots) do
			if slotDetails[slot] or not db.hideEmptySlots then
				self:AddDoubleLine(_G[slot:upper()], slotDetails[slot] or "|cffa0a0a0"..NONE.."|r")
			end
		end
		
		self:AddLine(" ")
		self:AddDoubleLine("Equipped:", inventoryPct and getColoredText(inventoryPct) or "N/A")
		
		self:AddLine(" ")
		self:AddDoubleLine("Bags:", backpackPct and getColoredText(backpackPct) or "|cffa0a0a0"..NONE.."|r")
		
		if inventoryPct and backpackPct then
			self:AddLine(" ")
			self:AddDoubleLine("Total:", getColoredText((inventoryPct + backpackPct) / 2))
		end
	end,
})

local defaults = {
	hideEmptySlots = false,
	showMostDamaged = true,
}

function module:OnInitialize()
	db = self:GetDB(defaults)
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "Update")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "Update")
end

function module:Update()
	wipe(slotDetails)

	local mostDamaged = 1
	local mostDamagedSlot
	local inventory, inventoryMax = 0, 0
	local backpack, backpackMax = 0, 0
	
	for i, slot in ipairs(slots) do
		local durability, durabilityMax = GetInventoryItemDurability(GetInventorySlotInfo(slot))
		
		if durability and durabilityMax then
			local fixedPct, exactPct = getPercentage(durability, durabilityMax)
			if fixedPct < mostDamaged then
				mostDamaged = fixedPct
				mostDamagedSlot = slot
			end
			
			slotDetails[slot] = getColoredText(fixedPct)
			
			-- add item durability values to total inventory durability value
			inventory = inventory + exactPct
			inventoryMax = inventoryMax + 1
		end
	end
	
	-- scan backpack items' durability status
	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			local durability, durabilityMax = GetContainerItemDurability(bag, slot)
			if durability then
				backpack = backpack + durability
				backpackMax = backpackMax + durabilityMax
			end
		end
	end
	
	inventoryPct = getPercentage(inventory, inventoryMax)
	backpackPct = getPercentage(backpack, backpackMax)
	
	if inventoryPct then
		local text = getColoredText(inventoryPct)
		if db.showMostDamaged and mostDamagedSlot then
			text = format("%s (%s: %s)", text, _G[mostDamagedSlot:upper()], getColoredText(mostDamaged))
		end
		self.text = text
	else
		self.text = "N/A"
	end
end