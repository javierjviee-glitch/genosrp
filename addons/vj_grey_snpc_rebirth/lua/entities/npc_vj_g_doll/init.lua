AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/2.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 25
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.AnimTbl_LeapAttack = {"attack"} -- Melee Attack Animations
ENT.LeapDistance = 260 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.7 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 1.4 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.6 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackVelocityForward = 180 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 260 -- How much upward force should it apply?
ENT.LeapAttackDamageDistance = 60 -- How far does the damage go?
ENT.LeapAttackDamage = math.random(10,20)
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.TimeUntilLeapAttackVelocity = 0.3
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {""}
ENT.SoundTbl_Death = {"doll/idle1.wav","doll/idle3.wav"}
ENT.SoundTbl_BeforeLeapAttack = {"doll/pain1.wav","doll/pain2.wav","doll/pain3.wav"}
ENT.SoundTbl_LeapAttackDamage = {"kuszo/claw_strike1.wav","kuszo/claw_strike2.wav","kuszo/claw_strike3.wav"}
ENT.DeathSoundLevel = 110
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


