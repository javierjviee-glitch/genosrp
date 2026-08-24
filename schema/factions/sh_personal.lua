--[[
##################################################################################
	© 2023-2026 Ghost, Cuboxis y Bena (https://discord.com/invite/axhEYdVd9A)
	Creado para la comunidad G.E.N.O.S, quien tiene derechos de su uso.
##################################################################################
--]]

local Color = Color

FACTION.name = "Personal de Hogwarts"
FACTION.description = "Facción Personal de Hogwarts."
FACTION.color = Color(233, 150, 122)
FACTION.isGloballyRecognized = true
FACTION.pay = 2
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

FACTION_PERSONAL = FACTION.index