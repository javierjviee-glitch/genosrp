--[[
##################################################################################
	© 2023-2026 Ghost, Cuboxis y Bena (https://discord.com/invite/axhEYdVd9A)
	Creado para la comunidad G.E.N.O.S, quien tiene derechos de su uso.
##################################################################################
--]]

CLASS.name = "Conserje"
CLASS.faction = FACTION_PERSONAL
CLASS.isDefault = false
CLASS_CONSERJE = CLASS.index

function CLASS:OnSpawn(client)
	client:Give("broom")
end