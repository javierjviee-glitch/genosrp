--[[
##################################################################################
	© 2023-2026 Ghost, Cuboxis y Bena (https://discord.com/invite/axhEYdVd9A)
	Creado para la comunidad G.E.N.O.S, quien tiene derechos de su uso.
##################################################################################
--]]

local Color = Color

FACTION.name = "Staff"
FACTION.description = "Staff de GenosRP"
FACTION.color = Color(255, 191, 0)
FACTION.pay = 5
FACTION.payTime = 180
FACTION.weapons = {"ix_arreststick"}

FACTION.models = {
	"models/genosrp/genosprofes/profe_7.mdl",
	"models/genosrp/genosprofes/profe_6.mdl",
	"models/genosrp/genosprofes/profe_3.mdl",
	"models/genosrp/profexdk/profexdk.mdl",
	"models/genosrp/genosprofes/genosprofemasc.mdl",
	"models/genosrp/genosprofes/genosprofemasc2.mdl",
}

function FACTION:CharacterLoaded(char)
	if !char:HasFlags("cenprt") then
		char:GiveFlags("cenprt")
	end
end

FACTION_STAFF = FACTION.index