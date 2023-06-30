-- SRPFramwork By Galaxy // Galaxy#1337
-- Don't touch this file unless you know what you're doing.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SRPFramework = {}
local Config = require(script.Config)

local DataService = require(script.Core.DataService)

local Plugins = script.Core.Plugins

local Event = require(script.Core.Dependencies.Event)

-- Initialize all the client-server replication stuff --------------

local RemoteFolder = Instance.new("Folder")
RemoteFolder.Name = "Remotes"
RemoteFolder.Parent = ReplicatedStorage

local ClientReplicator = Instance.new("RemoteFunction")
ClientReplicator.Name = "ClientReplicator"
ClientReplicator.Parent = RemoteFolder

local ServerReplicator = Instance.new("RemoteFunction")
ServerReplicator.Name = "ServerReplicator"
ServerReplicator.Parent = RemoteFolder

-------------------------------------------------------------

local DataStore = nil
if Config.DATA.Enabled then
	DataStore = DataService:CreateDataStoreInstance {
		Name = Config.DATA.Data_Key,
		AutoSave = Config.DATA.Auto_Save,
		AutoSaveInterval = Config.DATA.Auto_Save_Interval,

		DefaultData = {
			['RPName'] = "",
			['Currency'] = Config.ECONOMY.Starting_Balance,
		}
	}
end

--------------------------------------------------------------

PlayerDataLoaded = {}

RegisteredTags = {}


local ServerHooks = {
	['Data'] = DataStore,

	['Events'] = {
		PlayerDataChanged = Event.new(),
		PlayerAdded = Event.new(),
		DataLoadedForPlayer = function(player: Player)
			if not PlayerDataLoaded[player.Name] then
				PlayerDataLoaded[player.Name] = Event.new()
			end

			
			return PlayerDataLoaded[player.Name]
		end,

	},
	['Functions'] = {
		['FormatRoleplayName'] = function(player: Player & {[any]: any}, name: string)
			local displayType = Config.RP_NAME.Display_Type
			
			local formatting = {
				["{RPNAME}"] = name,
				["{USERNAME}"] = player.Name,
				["{DISPLAYNAME}"] = player.DisplayName,
				["{MONEY}"] = player:FindFirstChild("Currency") and player.Currency.Value or 0,
				["{MONEY_FULL}"] = Config.ECONOMY.Symbol .. (player:FindFirstChild("Currency") and player.Currency.Value or 0)
			}

			local newStr = displayType
			for format, str in pairs(formatting) do
				newStr = newStr:gsub(format, str)	
			end

			local groupRole = newStr:match("{GROUPROLE:(%d+)}")
			if groupRole then
				newStr = newStr:gsub("{GROUPROLE:"..groupRole.."}", player:GetRoleInGroup(tonumber(groupRole)))
			end

			local groupRank = newStr:match("{GROUPRANK:(%d+)}")
			if groupRank then
				newStr = newStr:gsub("{GROUPRANK:"..groupRank.."}", player:GetRankInGroup(tonumber(groupRank)))
			end

			for tag, value in pairs(RegisteredTags) do
				newStr = newStr:gsub("{CUSTOM:"..tag.."}", value)
			end

			return newStr;
		end,
		['RegisterTag'] = function(tag: string, value: string)
			RegisteredTags[tag] = value
		end
	}
}

table.freeze(ServerHooks)

_G.SRPFramework  = {
	['ServerHooks'] = ServerHooks
}

for _, p in pairs(Plugins.Server:GetChildren()) do
	if p:IsA("ModuleScript") then
		require(p)()
	end
end

local ServerFunctions = {
	["UpdatePlayerRPName"] = function(player: Player, name: string) : boolean
		if not Config.RP_NAME.Allow_Player_Entry then return false end

		if #name > Config.RP_NAME.Max_Name_Length then
			return false, "RP Name is too long."
		end
		
		if player:FindFirstChild("RPName") then
			local RPName = player:FindFirstChild("RPName")

			if Config.ECONOMY.Enabled and player:FindFirstChild("Currency") then
				local Currency = player:FindFirstChild("Currency")

				if Currency.Value >= Config.RP_NAME.Name_Change_Cost then
					Currency.Value -= Config.RP_NAME.Name_Change_Cost
				else
					return false, "You do not have enough currency to change your name."
				end
			end

			RPName.Value = name
		end

		return true, "Name updated successfully."
	end,

	["GetCameraMode"] = function(player: Player)
		return Config.CAMERA_MODE
	end

}

ServerReplicator.OnServerInvoke = function(player: Player, ...) : (boolean, string)
	local args = { ... }
	if not ServerFunctions[args[1]] then
		return false, "Invalid callback."
	end

	return ServerFunctions[args[1]](player, unpack(args, 2))
end
--------------------------------------------------------------

Players.PlayerAdded:Connect(function(player: Player)
	ServerHooks.Events.PlayerAdded:Fire(player)

	if DataStore then
		DataStore:Load(player.UserId) 
		local PlayerData = DataStore:GetData(player.UserId)

		if not PlayerData then return end

		local dataFolder = Instance.new("Folder")
		dataFolder.Name = "Data"
		dataFolder.Parent = player

		for Name, Data in pairs(PlayerData) do
			local dataValue = nil
			local success, err = pcall(function()
				dataValue = Instance.new(typeof(Data):gsub("^%l", string.upper).."Value")
				dataValue.Name = Name
				dataValue.Value = Data
				dataValue.Parent = dataFolder
			end)

			if not success or not dataValue then 
				warn("[SRPFramework] " .. err) 
				continue 
			end
			

			dataValue.Changed:Connect(function()
				DataStore:SetData(player.UserId, Name, dataValue.Value)

				ServerHooks.Events.PlayerDataChanged:Fire(player, Name, dataValue.Value)
			end)
		end

		if PlayerDataLoaded[player.Name] then
			PlayerDataLoaded[player.Name]:Fire()
		end
	end
end)

Players.PlayerRemoving:Connect(function(player: Player)
	if DataStore then
		DataStore:Save(player.UserId)

		DataStore.Data[player.UserId] = nil

		if PlayerDataLoaded[player.Name] then
			PlayerDataLoaded[player.Name] = nil
		end
	end
end)

game:BindToClose(function()
	if DataStore then
		for _, player in pairs(Players:GetPlayers()) do
			DataStore:Save(player.UserId)
		end
	end
end)



return SRPFramework