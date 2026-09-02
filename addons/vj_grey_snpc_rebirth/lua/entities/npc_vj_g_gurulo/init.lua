AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/gurulo.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 250
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 99999999999
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 78 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.4 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(20,33)
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.MeleeAttackBleedEnemy = ture -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 1 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"legless/foot1.wav","legless/foot2.wav"}
ENT.SoundTbl_Alert = {"legless/alert1.wav","legless/alert2.wav","legless/alert3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"legless/attack1.wav","legless/attack2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"legless/miss1.wav","legless/miss2.wav"}
ENT.SoundTbl_Pain = {"legless/pain1.wav","legless/pain2.wav","legless/pain3.wav"}
ENT.SoundTbl_Death = {"legless/die1.wav","legless/die2.wav"}


ENT.ATTACK = false
ENT.ATTACKT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
        self:SetCollisionBounds(Vector(15, 15, 40), Vector(-15, -15, 0))

end
------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:GetEnemy() ~= nil then
	if not self:IsBusy() and self.ATTACK == false then
	if CurTime() > self.ATTACKT then
	local Poser = self:GetEnemy()
	self.ATTACK = true
	ParticleEffect("gurzo",self:GetPos() + self:GetUp()*16,Angle(0,0,0),nil)
timer.Simple(0.2,function() if IsValid(self) then 
self:DoChangeMovementType(VJ_MOVETYPE_STATIONARY)
self:StopMoving()
 end end)
VJ_EmitSound(self,"gur.wav",90,100)
self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.FindEnemy_UseSphere = true
	self.FindEnemy_CanSeeThroughWalls = true
	self:SetNoDraw(true)
	self.HasMeleeAttack = false
	self.GodMode = true
	self.VJ_NoTarget = true
						
		
	timer.Simple(math.random(9,12),function() if IsValid(self) and IsValid(Poser) then
	self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
self:StopMoving()
	self:SetPos(Poser:GetPos() + Poser:GetForward()*-50)
	ParticleEffect("gurzo",self:GetPos() + self:GetUp()*16,Angle(0,0,0),nil)
	VJ_EmitSound(self,"gur.wav",100,100)
	VJ_EmitSound(self,"gur.wav",100,100)
	self.VJ_NoTarget = false
	self.GodMode = false
	self.DisableMakingSelfEnemyToNPCs = false
	self.FindEnemy_UseSphere = false
	self.FindEnemy_CanSeeThroughWalls = false
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self:SetNoDraw(false)
	self.HasMeleeAttack = true
	self.ATTACK = false
	self.ATTACKT = CurTime() + math.random(6,12)
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


