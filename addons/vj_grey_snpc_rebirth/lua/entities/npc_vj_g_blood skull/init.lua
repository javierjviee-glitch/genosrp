AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/gibs/hgibs.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 110
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasLeapAttack = false -- Should the SNPC have a leap attack?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_Blast = true 
ENT.SoundTbl_Death = {"doll/idle1.wav","doll/idle3.wav"}
ENT.DeathSoundLevel = 110

-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


