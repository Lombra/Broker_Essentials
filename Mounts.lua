local _, core = ...

local function mountSort(a, b)
	local mountNameA = C_MountJournal.GetMountInfoByID(a)
	local mountNameB = C_MountJournal.GetMountInfoByID(b)
	return mountNameA < mountNameB
end

local function onClick(self, mountID)
	C_MountJournal.SummonByID(mountID)
end

local dropdown = core:CreateDropdown("Menu")
dropdown.initialize = function(self, level)
	local mounts = C_MountJournal.GetMountIDs()
	sort(mounts, mountSort)
	for i, mountID in ipairs(mounts) do
		local creatureName, _, icon, active, isUsable, _, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
		
		if isFavorite and isUsable then
			local info = UIDropDownMenu_CreateInfo()
			info.text = creatureName
			info.icon = icon
			info.func = onClick
			info.arg1 = mountID
			info.notCheckable = true
			self:AddButton(info)
		end
	end
end

local module = core:NewModule("Mounts", {
	type = "data source",
	label = "Mounts",
	icon = [[Interface\Icons\MountJournalPortrait]],
	OnClick = function(self)
		dropdown:Toggle(nil, self)
	end,
})