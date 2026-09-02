AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.Bleeds = false
ENT.GodMode = true
ENT.FadeCorpse = true -- Fades the ragdoll on death
ENT.FadeCorpseTime = 0.5 -- How much time until the ragdoll fades | Unit = Seconds
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.AnimTbl_LeapAttack = {"attack"} -- Melee Attack Animations
ENT.ImmuneDamagesTable = {DMG_BURN,DMG_SLASH}
ENT.LeapDistance = 260 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.NextAnyAttackTime_Leap = 0.6 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackVelocityForward = 180 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 260 -- How much upward force should it apply?
ENT.TimeUntilLeapAttackDamage = 0.7 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 1.4 -- How much time until it can use a leap attack?
ENT.LeapAttackDamageDistance = 60 -- How far does the damage go?
ENT.LeapAttackDamage = math.random(10,28)
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.DisableWandering = true
ENT.Immune_CombineBall = true -- Immune to Combine Ball
ENT.IgnoreCBDeath = true
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_Electricity = true -- Immune to Electrical
ENT.Immune_Physics = true
ENT.Immune_Bullet = true
ENT.Immune_Blast = true
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.TimeUntilLeapAttackVelocity = 0.3
ENT.Death = false
ENT.DeathT = 0
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
self:SetRenderFX(kRenderFxFadeFast)
	self.VJ_NoTarget = true
						
			
end
---------------------------------
function ENT:CustomOnThink()
	self:RemoveAllDecals()
end
------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:GetEnemy() ~= nil then
	if self.MeleeAttacking == false and self.LeapAttacking == false and self.Death == false then
	if CurTime() > self.DeathT then
	self.Death = true
	self:StopMoving()
	self.DisableChasingEnemy = true
	timer.Simple(0.2,function() if IsValid(self) then self:SetNoDraw(true)
	end end)
	timer.Simple(0.21  ,function() if IsValid(self)	then self.VJ_NoTarget = true
						
				
	end end)
	util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(20,33),DMG_BLAST,true,true)
	self.HasLeapAttack = false					
	timer.Simple(math.random(4,8),function() if IsValid(self) then
self:SetNoDraw(false)
timer.Simple(0.2,function() if IsValid(self) then self.VJ_NoTarget = true
						
				end end)
	self.HasLeapAttack = true
	self.Death = false
	self.DeathT = CurTime() + math.random(4,13)
	self.DisableChasingEnemy = false
	end end) 
	end
	end
	end
	end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


