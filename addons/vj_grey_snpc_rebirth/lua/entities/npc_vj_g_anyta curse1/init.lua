AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/babu.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 800
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Oil"
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.FadeCorpse = true -- Fades the ragdoll on death
ENT.FadeCorpseTime = 0.5 -- How much time until the ragdoll fades | Unit = Seconds
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(30,56)
ENT.DisableWandering = true
ENT.ImmuneDamagesTable = {DMG_BURN,DMG_SLASH}
ENT.Immune_CombineBall = true -- Immune to Combine Ball
ENT.IgnoreCBDeath = true
ENT.FindEnemy_UseSphere = true
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Physics = true
ENT.Immune_Blast = true
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_Electricity = true -- Immune to Electrical
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.FootStepTimeRun = 0.53 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.53 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.Cu = false
ENT.CuT = 0
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {""}
ENT.SoundTbl_Alert = {""}
ENT.SoundTbl_BeforeMeleeAttack = {""}
ENT.SoundTbl_MeleeAttackMiss = {"babu/miss1.wav","babu/miss2.wav"}
ENT.SoundTbl_Pain = {""}
ENT.SoundTbl_Death = {"babu/die1.wav","babu/die2.wav"}
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
PrintMessage(HUD_PRINTCENTER, "Curse start, kill them in 13 seconds")
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
	if self.Cu == false and not IsValid(cu2) and not IsValid(cu1) and CurTime() > self.CuT then
	self.Cu = true

cu1 = ents.Create("npc_vj_g_anyta curse")
cu1:SetPos(self:GetPos() + self:GetRight()*10)
cu1:SetAngles(self:GetAngles())
cu1:Spawn()
cu1:SetColor(Color(0,0,0,110))
cu1:Activate()
cu1:SetOwner(self)
self:DeleteOnRemove(cu1)

cu2 = ents.Create("npc_vj_g_anyta curse")
cu2:SetPos(self:GetPos() + self:GetRight()*-10)
cu2:SetAngles(self:GetAngles())
cu2:Spawn()
cu2:SetColor(Color(0,0,0,110))
cu2:Activate()
cu2:SetOwner(self)
self:DeleteOnRemove(cu2)
	self.Cu = false
	self.CuT = CurTime() + math.random(6,11)
	end
	end
	end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


