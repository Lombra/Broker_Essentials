local Libra = LibStub("Libra")
local LDB = LibStub("LibDataBroker-1.1")

local addon = Libra:NewAddon(...)
Libra:Embed(addon)

function addon:OnInitialize()
	Broker_EssentialsDB = Broker_EssentialsDB or {}
end

local function copyDefaults(source, target)
	source = source or { }
	target = target or { }
	for k, v in pairs(source) do
		if type(v) == "table" then
			target[k] = copyDefaults(v, target[k])
		elseif type(v) ~= type(target[k]) then
			target[k] = v
		end
	end
	return target
end

local function getDB(self, defaults)
	Broker_EssentialsDB[self.name] = copyDefaults(defaults, Broker_EssentialsDB[self.name])
	return Broker_EssentialsDB[self.name]
end

function addon:OnModuleCreated(name, data)
	LDB:NewDataObject(name, data)
	data.GetDB = getDB
end
