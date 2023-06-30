local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ClientReplicator = Remotes:WaitForChild("ClientReplicator")

local ClientFunctions = {

}

ClientReplicator.OnClientInvoke = function(...) : (boolean, string)
	local args = { ... }
	if not ClientFunctions[args[1]] then
		return false, "Invalid callback."
	end

	ClientFunctions[args[1]](unpack(args, 2))

	return true, "Callback successful."
end
