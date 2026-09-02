AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/1.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 25
ENT.SightDistance = 9999000
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_ShouldBeFlying = true
ENT.Aerial_FlyingSpeed_Calm = 440 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 440
ENT.Aerial_AnimTbl_Calm = {"fly","fly2","fly3"} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {"fly","fly2","fly3"}
ENT.FindEnemy_UseSphere = true
ENT.Aerial_CurrentMoveAnimationType = "Wander"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AerialMove_Stop()
	if self:GetVelocity():Length() == 0 then
		self:SetLocalVelocity(Vector(0,0,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Oil" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- How close does it have to be until it attacks?
ENT.MeleeAttackDistance = 50
ENT.EntitiesToNoCollide = {"npc_vj_g_curse"}
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.1 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.8 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(6,11)
ENT.DisableMeleeAttackAnimation = true
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 1 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 3 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 5 -- How many reps?
ENT.HasDeathRagdoll = false

	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 8 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextMoveAfterFlinchTime = 1.3 -- How much time until it can move, attack, etc. | Use this for schedules or else the base will set the time 0.6 if it sees it's a schedule!
ENT.NextFlinchTime = 5 -- How much time until it can flinch again?
ENT.AnimTbl_Flinch = {"am_hurt_left_leg","am_hurt_right_leg"} 
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Pain = {""}
ENT.SoundTbl_Death = {""}

ENT.IdleSoundLevel = 150
----------------------------------------------------------------
function ENT:CustomOnInitialize()
ParticleEffectAttach("curse fly", PATTACH_POINT_FOLLOW, self, 0)
self:SetCollisionBounds(Vector(10, 10, 10), Vector(-10, -10, 0))
	self.VJ_NoTarget = true
						
		
end

---------------------------------------------------------------
function ENT:CustomOnMeleeAttack_BeforeStartTimer()
timer.Simple(0.1,function() if IsValid(self) then self:Remove() end end)
ParticleEffectAttach("curse fly2", PATTACH_POINT_FOLLOW, self, 0)
util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(18,25),DMG_BLAST,true,true)
end
--[[

	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


