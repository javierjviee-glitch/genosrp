AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/classic2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1000
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.VJ_IsHugeMonster = true 
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.3 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(22,33)
ENT.Immune_CombineBall = true -- Immune to Combine Ball
ENT.IgnoreCBDeath = true
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Physics = true
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.FootStepTimeRun = 0.7 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.7 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {""}
ENT.SoundTbl_Alert = {"hczombie/alert1.wav","hczombie/alert2.wav","hczombie/alert3.wav","hczombie/zombie_voice_idle1.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"hczombie/attack1.wav","hczombie/attack2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"hczombie/miss1.wav","hczombie/miss2.wav"}
ENT.SoundTbl_Pain = {"hczombie/idle1.wav","hczombie/idle2.wav","hczombie/idle3.wav","hczombie/zombie_idle2.wav"}
ENT.SoundTbl_Death = {"hczombie/die1.wav","hczombie/die2.wav"}
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
ParticleEffectAttach("blood_flyer2", PATTACH_POINT_FOLLOW, self, 0)
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


