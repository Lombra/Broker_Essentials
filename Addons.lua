local _, core = ...

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	table.sort(AddonCompartmentFrame.registeredAddons, function(infoA, infoB) return strcmputf8i(StripHyperlinks(infoA.text), StripHyperlinks(infoB.text)) < 0 end)
	for i, info in ipairs(AddonCompartmentFrame.registeredAddons) do
		UIDropDownMenu_AddButton(info, level);
	end
end

local module = core:NewModule("Addons", {
	type = "data source",
	label = "Addons",
	icon = [[Interface\Icons\INV_Misc_Gear_08]],
	OnClick = function(self)
		dropdown:Toggle(nil, self)
	end,
})
