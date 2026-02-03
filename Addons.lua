local _, core = ...

local function onClick(self, arg1)
	arg1(nil, { })
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	table.sort(AddonCompartmentFrame.registeredAddons, function(infoA, infoB) return strcmputf8i(C_StringUtil.StripHyperlinks(infoA.text), C_StringUtil.StripHyperlinks(infoB.text)) < 0 end)
	for i, info in ipairs(AddonCompartmentFrame.registeredAddons) do
		info = {
			text = info.text,
			func = onClick,
			arg1 = info.func,
			notCheckable = true,
		}
		UIDropDownMenu_AddButton(info, level)
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
