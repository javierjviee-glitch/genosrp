--[[
##################################################################################
	© 2023-2026 Ghost, Cuboxis y Bena (https://discord.com/invite/axhEYdVd9A)
	Creado para la comunidad G.E.N.O.S, quien tiene derechos de su uso.
##################################################################################
--]]

local timer = timer

CLASS.name = "Prefecto/a"
CLASS.faction = FACTION_ALUMNOS
CLASS.isDefault = false
CLASS_PREFECTO = CLASS.index

function CLASS:CanSwitchTo(client)
	return false
end

function CLASS:OnSpawn(client)
	timer.Simple(0.5, function() self:OnSet(client) end)
end

function CLASS:OnSet(client)
	local char = client:GetCharacter()
	client:Give("ix_arreststick")
	client:Give("ix_keys")

	char:Save() -- Sin esto no se guarda la clase y entonces no te da el stick en el OnSpawn
end

function CLASS:OnLeave(client)
	local char = client:GetCharacter()
	if (client:HasWeapon("ix_arreststick")) then
		client:StripWeapon("ix_arreststick")
	end

	if (client:HasWeapon("ix_keys")) then
		client:StripWeapon("ix_keys")
	end

	char:Save()
end