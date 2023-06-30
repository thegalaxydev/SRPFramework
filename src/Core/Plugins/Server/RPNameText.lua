--[[
	Server Plugin

	You can use this to hook into the server's events and data store.

	API:
	_G.SRPFramework: {
		ServerHooks: {
			Data: DataStoreInstance;

			Events: {
				PlayerAdded: Event;
				PlayerDataChanged: Event;
				PlayerDataLoaded: Event;
			};

			Functions: {
				FormatRoleplayName: (player: Player, name: string) -> string;
				RegisterTag: (tag: string, value: string) -> ();
			};
		}
	}
]]

return function()
	_G.SRPFramework.ServerHooks.Functions.RegisterTag("TEST", "Test")

	_G.SRPFramework.ServerHooks.Events.PlayerAdded:Connect(function(player: Player)
		print("Player added: " .. player.Name)
		
		_G.SRPFramework.ServerHooks.Events.DataLoadedForPlayer(player):Connect(function()
			local character = player.Character or player.CharacterAdded:Wait()
			local Nametag = game:GetService("ReplicatedStorage").Nametag:Clone()
			Nametag.Parent = character.Head

			Nametag.TextLabel.Text = _G.SRPFramework.ServerHooks.Functions.FormatRoleplayName(player, "Test")
		end)
	end)
end