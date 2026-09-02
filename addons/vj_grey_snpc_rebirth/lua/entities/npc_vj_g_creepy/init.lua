AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/kuszo.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 270
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.4 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(20,30)
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 56 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 20 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 3 -- How much time until player's Speed resets
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
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
ENT.SoundTbl_FootStep = {"kuszo/foot1.wav","kuszo/foot2.wav","kuszo/foot3.wav","kuszo/foot4.wav"}
ENT.SoundTbl_Alert = {"kuszo/alert1.wav","kuszo/alert2.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"kuszo/hurt1.wav","kuszo/hurt2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"kuszo/claw_strike1.wav","kuszo/claw_strike2.wav","kuszo/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"kuszo/claw_miss1.wav","kuszo/claw_miss2.wav"}
ENT.SoundTbl_Pain = {"kuszo/hurt1.wav","kuszo/hurt2.wav"}
ENT.SoundTbl_Death = {"kuszo/die1.wav","kuszo/die2.wav"}
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


