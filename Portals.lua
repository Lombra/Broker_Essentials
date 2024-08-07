local _, core = ...

-- table to contain known spells and also the headers
local menu = {}

local menuItems = {
	-- {type = "item", id = HEARTHSTONE_ITEM_ID},	-- Hearthstone

	{text = "Teleports"},
	{type = "spell", id = 3561},  -- Stormwind
	{type = "spell", id = 3562},  -- Ironforge
	{type = "spell", id = 3565},  -- Darnassus
	{type = "spell", id = 32271}, -- Exodar
	{type = "spell", id = 49359}, -- Theramore

	{type = "spell", id = 3567},  -- Orgrimmar
	{type = "spell", id = 3563},  -- Undercity
	{type = "spell", id = 3566},  -- Thunder Bluff
	{type = "spell", id = 32272}, -- Silvermoon
	{type = "spell", id = 49358}, -- Stonard

	{type = "spell", id = 33690}, -- Shattrath (Alliance)
	{type = "spell", id = 35715}, -- Shattrath (Horde)
	{type = "spell", id = 53140}, -- Dalaran - Northrend
	{type = "spell", id = 88342}, -- Tol Barad (Alliance)
	{type = "spell", id = 88344}, -- Tol Barad (Horde)
	{type = "spell", id = 132621}, -- Vale of Eternal Blossoms
	{type = "spell", id = 176248}, -- Stormshield
	{type = "spell", id = 224869}, -- Dalaran - Broken Isles
	{type = "spell", id = 281403}, -- Boralus
	{type = "spell", id = 344587}, -- Oribos
	{type = "spell", id = 395277}, -- Valdrakken

	{type = "spell", id = 18960}, -- Moonglade
	{type = "spell", id = 120145}, -- Dalaran crater
	{type = "spell", id = 193759}, -- Hall of the Guardian

	{text = "Portals"},
	{type = "spell", id = 10059}, -- Stormwind
	{type = "spell", id = 11416}, -- Ironforge
	{type = "spell", id = 11419}, -- Darnassus
	{type = "spell", id = 32266}, -- Exodar
	{type = "spell", id = 49360}, -- Theramore

	{type = "spell", id = 11417}, -- Orgrimmar
	{type = "spell", id = 11418}, -- Undercity
	{type = "spell", id = 11420}, -- Thunder Bluff
	{type = "spell", id = 32267}, -- Silvermoon
	{type = "spell", id = 49361}, -- Stonard

	{type = "spell", id = 33691}, -- Shattrath (Alliance)
	{type = "spell", id = 35717}, -- Shattrath (Horde)
	{type = "spell", id = 53142}, -- Dalaran - Northrend
	{type = "spell", id = 88345}, -- Tol Barad (Alliance)
	{type = "spell", id = 88346}, -- Tol Barad (Horde)
	{type = "spell", id = 132620}, -- Vale of Eternal Blossoms
	{type = "spell", id = 176246}, -- Stormshield
	{type = "spell", id = 224871}, -- Dalaran - Broken Isles
	{type = "spell", id = 281400}, -- Boralus
	{type = "spell", id = 344597}, -- Oribos
	{type = "spell", id = 395289}, -- Valdrakken

	{type = "spell", id = 120146}, -- Dalaran crater

	{text = "Challenger's Path"},
	{type = "spell", id = 131228}, -- Path of the Black Ox
	{type = "spell", id = 131204}, -- Path of the Jade Serpent
	{type = "spell", id = 131222}, -- Path of the Mogu King
	{type = "spell", id = 131232}, -- Path of the Necromancer
	{type = "spell", id = 131231}, -- Path of the Scarlet Blade
	{type = "spell", id = 131229}, -- Path of the Scarlet Mitre
	{type = "spell", id = 131225}, -- Path of the Setting Sun
	{type = "spell", id = 131206}, -- Path of the Shado-Pan
	{type = "spell", id = 131205}, -- Path of the Stout Brew

	{text = "Warlord's Path"},
	{type = "spell", id = 159895}, -- Path of the Bloodmaul
	{type = "spell", id = 159896}, -- Path of the Iron Prow
	{type = "spell", id = 159897}, -- Path of the Vigilant
	{type = "spell", id = 159898}, -- Path of the Skies
	{type = "spell", id = 159901}, -- Path of the Verdant
	{type = "spell", id = 159900}, -- Path of the Dark Rail
	{type = "spell", id = 159899}, -- Path of the Crescent Moon
	{type = "spell", id = 159902}, -- Path of the Burning Mountain

	{text = "Items"},
	{type = "toy", id = 18986},  -- Ultrasafe Transporter: Gadgetzan
	{type = "toy", id = 18984},  -- Dimensional Ripper: Everlook
	{type = "toy", id = 30544},  -- Ultrasafe Transporter: Toshley's Station
	{type = "toy", id = 30542},  -- Dimensional Ripper: Area 52
	{type = "toy", id = 48933},  -- Wormhole Generator: Northrend
	{type = "toy", id = 87215},  -- Wormhole Generator: Pandaria
	{type = "toy", id = 112059}, -- Wormhole Centrifuge

	{type = "toy", id = 110560}, -- Garrison Hearthstone
	{type = "toy", id = 140192}, -- Dalaran Hearthstone
}

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self)
	for i, v in ipairs(menu) do
		self:AddButton(v)
	end
end

local module = core:NewModule("Portals", {
	type = "data source",
	text = "Ready",
	label = "Portals",
	icon = [[Interface\Icons\Spell_Arcane_TeleportDalaran]],
	OnClick = function(self)
		if not InCombatLockdown() then
			dropdown:Toggle(nil, self)
		end
	end,
})

function module:OnInitialize()
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function module:PLAYER_LOGIN()
	for index, value in ipairs(menuItems) do
		if value.id then
			local name, icon
			if value.type == "spell" then
				local spellInfo = C_Spell.GetSpellInfo(value.id)
				name = spellInfo.name
				icon = spellInfo.iconID
			elseif value.type == "item" then
				name = "item:"..value.id
				icon = C_Item.GetItemIconByID(value.id)
			elseif value.type == "toy" then
				name = value.id
				icon = C_Item.GetItemIconByID(value.id)
			end
			value.text = name
			value.icon = icon
			value.attributes = {
				["type"] = value.type,
				[value.type] = name,
			}
		else
			value.isTitle = true
		end
		value.notCheckable = true
	end

	self:SetMenuItemVisibility()

	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("BAG_UPDATE_DELAYED", "SetMenuItemVisibility")
end

function module:PLAYER_REGEN_ENABLED()
	self.text = "Ready"
end

-- portals cannot be cast in combat, so hide overlay buttons and disable menu
function module:PLAYER_REGEN_DISABLED()
	self.text = "|cffff0000In combat|r"
	dropdown:Close()
end

local function onUpdate(self)
	self:SetMenuItemVisibility()
	self:RemoveOnUpdate()
end

function module:LEARNED_SPELL_IN_TAB()
	self:SetOnUpdate(onUpdate)
end

-- update menu items, to deterrmine which items should actually be visible
function module:SetMenuItemVisibility()
	if InCombatLockdown() then
		return
	end

	wipe(menu)

	local previousItem
	for index, value in ipairs(menuItems) do
		if not value.id then
			-- items without an ID will be headers
			tinsert(menu, value)
		elseif value.type == "spell" and IsSpellKnown(value.id) then
			value.disabled = not C_Spell.IsSpellUsable(value.text)
			tinsert(menu, value)
		elseif value.type == "item" and C_Item.GetItemCount(value.id) > 0 then
			value.text = C_Item.GetItemInfo(value.id)
			tinsert(menu, value)
		elseif value.type == "toy" and PlayerHasToy(value.id) and C_ToyBox.IsToyUsable(value.id) then
			value.text = C_Item.GetItemInfo(value.id)
			tinsert(menu, value)
		end
	end

	for i = #menu, 1, -1 do
		-- if a header has no following spells or next button is another header, we want to hide it
		local _, next = next(menu, i)
		if menu[i].isTitle and (not next or next.isTitle) then
			tremove(menu, i)
		end
	end
end