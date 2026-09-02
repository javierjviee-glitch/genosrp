AddCSLuaFile("shared.lua")
include("shared.lua")
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/spitball_medium.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 100 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = math.random(12,24) -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BURN -- Damage type
--ENT.DecalTbl_DeathDecals = {"BeerSplash"}
ENT.SoundTbl_Idle = {"hczombie/ropp.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableDrag(false)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
        self:SetNoDraw(true)
	ParticleEffectAttach("rollblood", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
function ENT:CustomOnThink()
ParticleEffect("blood_impact_red_01",self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("blood_impact_red_01",self:GetPos(), Angle(0,0,0), nil)
	end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects(data,phys)
	ParticleEffect("blood boomer2",self:GetPos(), Angle(0,0,0), nil)
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


