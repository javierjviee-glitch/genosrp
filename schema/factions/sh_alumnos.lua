--[[
##################################################################################
	© 2023-2026 Ghost, Cuboxis y Bena (https://discord.com/invite/axhEYdVd9A)
	Creado para la comunidad G.E.N.O.S, quien tiene derechos de su uso.
##################################################################################
--]]

local Color = Color
local timer = timer

FACTION.name = "Alumnos"
FACTION.description = "Facción alumnos."
FACTION.color = Color(204, 239, 227)
FACTION.isDefault = true
FACTION.pay = 1
FACTION.payTime = 180

FACTION.models = {
	"models/player/genosrp/alumnos2/chicos_peques/alumnopequeneutro.mdl",
	"models/player/genosrp/alumnos2/chicas_peques/alumnapequeneutro.mdl",
	"models/wolfar/genosrp/alumnos/wolfaralumno.mdl",
	"models/wolfar/genosrp/alumnos/wolfaralumna.mdl",
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
	inventory:Add("varita")

	if (weapons.Get("weapon_suitcase")) then
		timer.Simple(0.1, function()
			client:Give("weapon_suitcase")
			client:SelectWeapon("weapon_suitcase")
			local weapon = client:GetActiveWeapon()
			client:SetWepRaised(true, weapon)
		end)
	end

	client:Notify("Bienvenido/a a Genos RP.\n\nDirígete hacia el castillo para ser seleccionado/a en una casa y comenzar tu aventura.")
end

FACTION_ALUMNOS = FACTION.index