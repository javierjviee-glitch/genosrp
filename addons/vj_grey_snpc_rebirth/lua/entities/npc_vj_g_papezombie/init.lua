AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/paperzombie.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 240
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.4 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(23,36)
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.FootStepTimeRun = 0.1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.1 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.LeapDistance = 500 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.HasLeapAttack = true
ENT.LeapToMeleeDistance = 160 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.66 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = math.random(2,4) -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.7 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackVelocityForward = 700 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 170 -- How much upward force should it apply?
ENT.LeapAttackDamageDistance = 70 -- How far does the damage go?
ENT.LeapAttackDamage = math.random(20,33)
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {""}
ENT.SoundTbl_Alert = {"papezombie/fz_alert_far1.wav","papezombie/fz_alert_close1.wav"}
ENT.SoundTbl_Idle = {"papezombie/idle2.wav","papezombie/idle3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"papezombie/fz_frenzy1.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"papezombie/claw_miss1.wav","papezombie/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"papezombie/gurgle_loop1.wav"}
ENT.SoundTbl_Death = {"papezombie/wake1.wav","papezombie/leap1.wav"}

--------Custom
ENT.Death = false
ENT.DeathT = 0
--------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
self:RemoveAllDecals()
if self:GetEnemy() ~= nil then
if self:GetPos():Distance(self:GetEnemy():GetPos()) > 300 then
self:SetMaterial("models/effects/vol_light001.mdl")
end
if self:GetPos():Distance(self:GetEnemy():GetPos()) < 300 then
self:SetMaterial("")
end
end end
------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:GetEnemy() ~= nil then
	if not self:IsBusy() and self.Death == false then
	if CurTime() > self.DeathT then
	self.Death = true
	self:StopMoving()
	self.DisableChasingEnemy = true
	self.GodMode = true
	timer.Simple(0.2,function() if IsValid(self) then self:SetNoDraw(true) end end)
	VJ_EmitSound(self,"gur.wav",100,100)
	VJ_EmitSound(self,"gur.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(30,44),DMG_BLAST,true,true)
	ParticleEffectAttach("gurzo", PATTACH_POINT_FOLLOW, self, 3)
	ParticleEffect("gur_spawn",self:GetPos() + self:GetForward()*10 + self:GetUp()*26,Angle(0,0,0),nil)
	self.HasMeleeAttack = false
	self.HasLeapAttack = false
	self.VJ_NoTarget = true
						
	self:AddFlags(FL_NOTARGET)
	
	timer.Simple(math.random(3,8),function() if IsValid(self) then self.GodMode = false
timer.Simple(0.2,function() if IsValid(self) then self:SetNoDraw(false) end end)
self:RemoveFlags(FL_NOTARGET)
	self.HasMeleeAttack = true
	self.HasLeapAttack = true
	self.VJ_NoTarget = false
	VJ_EmitSound(self,"gur.wav",100,100)
	VJ_EmitSound(self,"gur.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(30,44),DMG_BLAST,true,true)
	ParticleEffectAttach("gurzo", PATTACH_POINT_FOLLOW, self, 3)
	ParticleEffect("gur_spawn",self:GetPos() + self:GetForward()*10 + self:GetUp()*26,Angle(0,0,0),nil)
	self.DisableMakingSelfEnemyToNPCs = false
	self.Death = false
	self.DeathT = CurTime() + math.random(8,14)
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


