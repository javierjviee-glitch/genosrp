AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/steve.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 99999999
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_MEDIUM_TALL
ENT.VJ_IsHugeMonster = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.2 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.3 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 160
ENT.BloodDecalDistance = 300 -- How far the decal can spawn
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.Immune_CombineBall = true -- Immune to Combine Ball
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.IgnoreCBDeath = true
ENT.Immune_AcidPoisonRadiation = true
ENT.EntitiesToNoCollide = {"npc_vj_g_steve life"}
ENT.Immune_Physics = true
ENT.Immune_Blast = true
ENT.FadeCorpse = true -- Fades the ragdoll on death
ENT.FadeCorpseTime = 1.3 -- How much time until the ragdoll fades | Unit = Seconds
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 1 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 14 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 5 -- How many reps?
ENT.FindEnemy_UseSphere = true
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 60 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 60 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 4 -- How much time until player's Speed resets
ENT.HasSlowPlayerSound = false -- Does it have a sound when it slows down the player?
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.4 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.HasSoundTrack = true -- Does the SNPC have a sound track?
ENT.GodMode = true
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"steve/foot1.wav","steve/foot2.wav"}
ENT.SoundTbl_Alert = {"steve/alert.wav"}
ENT.SoundTbl_MeleeAttack = {""}
ENT.SoundTbl_MeleeAttackMiss = {"steve/miss1.wav","steve/miss2.wav"}
ENT.SoundTbl_Pain = {""}
ENT.SoundTbl_Death = {""}
ENT.SoundTbl_SoundTrack = {"steve/HZ_grmost.wav","steve/Flash of Labyrinth.mp3"}


ENT.D1 = false
ENT.Change = false
ENT.ChangeT = 0
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
PrintMessage(HUD_PRINTCENTER, "Steve is invincible, killing four floater can make steve die, be careful, they will swap position!")
timer.Simple(1,function() if IsValid(self) then PrintMessage(HUD_PRINTCENTER, "Steve is invincible, killing four floater can make steve die, be careful, they will swap position!") end end)
te = ents.Create("npc_vj_g_steve life")
te:SetPos(self:GetPos() + self:GetForward()*40)
te:SetAngles(self:GetAngles())
te:Spawn()
te:Activate()
te:SetOwner(self)
self:DeleteOnRemove(te)

te1 = ents.Create("npc_vj_g_steve life")
te1:SetPos(self:GetPos() + self:GetForward()*-40)
te1:SetAngles(self:GetAngles())
te1:Spawn()
te1:Activate()
te1:SetOwner(self)
self:DeleteOnRemove(te1)

te2 = ents.Create("npc_vj_g_steve life")
te2:SetPos(self:GetPos() + self:GetRight()*40)
te2:SetAngles(self:GetAngles())
te2:Spawn()
te2:Activate()
te2:SetOwner(self)
self:DeleteOnRemove(te2)

te3 = ents.Create("npc_vj_g_steve life")
te3:SetPos(self:GetPos() + self:GetRight()*-40)
te3:SetAngles(self:GetAngles())
te3:Spawn()
te3:Activate()
te3:SetOwner(self)
self:DeleteOnRemove(te3)

end
---------------------------------
function ENT:CustomOnThink()
if not IsValid(te) and not IsValid(te1) and not IsValid(te2) and not IsValid(te3) and self.D1 == false then
self.D1 = true
self.GodMode = false
timer.Simple(0.2,function() if IsValid(self) then self:TakeDamage(99999999999,self,self)
ParticleEffect("vomit boom2",self:GetPos() + self:GetUp()*40,Angle(0,0,0),nil) end end)
end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
  local rand = math.random(1,7)
  if rand == 1 and IsValid(te) and self.Change == false and CurTime() > self.ChangeT then
  self.Change = true
   g = ents.Create("npc_vj_g_blood suker3")
g:SetPos(self:GetPos())
g:SetAngles(self:GetAngles())
g:Spawn()
g:Activate()
g:SetOwner(self)
self:DeleteOnRemove(g)
timer.Simple(0.1,function() if IsValid(self) and IsValid(te) then self:SetPos(te:GetPos())
  timer.Simple(0.15,function() if IsValid(self) and IsValid(te) then te:SetPos(g:GetPos())
 g1 = ents.Create("npc_vj_g_blood suker3")
g1:SetPos(self:GetPos())
g1:SetAngles(self:GetAngles())
g1:Spawn()
g1:Activate()
g1:SetOwner(self)
self:DeleteOnRemove(g1)
  end end) end end)
  self.Change = false
	self.ChangeT = CurTime() + math.random(4,10)	
	
	 elseif rand == 2 and IsValid(te1) and self.Change == false and CurTime() > self.ChangeT then
  self.Change = true
   g = ents.Create("npc_vj_g_blood suker3")
g:SetPos(self:GetPos())
g:SetAngles(self:GetAngles())
g:Spawn()
g:Activate()
g:SetOwner(self)
self:DeleteOnRemove(g)
timer.Simple(0.1,function() if IsValid(self) and IsValid(te1) then self:SetPos(te1:GetPos())
  timer.Simple(0.15,function() if IsValid(self) and IsValid(te1) then te1:SetPos(g:GetPos())
 g1 = ents.Create("npc_vj_g_blood suker3")
g1:SetPos(self:GetPos())
g1:SetAngles(self:GetAngles())
g1:Spawn()
g1:Activate()
g1:SetOwner(self)
self:DeleteOnRemove(g1)
  end end) end end)
  self.Change = false
	self.ChangeT = CurTime() + math.random(4.6,10)	
	
	 elseif rand == 3 and IsValid(te2) and self.Change == false and CurTime() > self.ChangeT then
  self.Change = true
   g = ents.Create("npc_vj_g_blood suker3")
g:SetPos(self:GetPos())
g:SetAngles(self:GetAngles())
g:Spawn()
g:Activate()
g:SetOwner(self)
self:DeleteOnRemove(g)
timer.Simple(0.1,function() if IsValid(self) and IsValid(te2) then self:SetPos(te2:GetPos())
  timer.Simple(0.15,function() if IsValid(self) and IsValid(te2) then te2:SetPos(g:GetPos())
 g1 = ents.Create("npc_vj_g_blood suker3")
g1:SetPos(self:GetPos())
g1:SetAngles(self:GetAngles())
g1:Spawn()
g1:Activate()
g1:SetOwner(self)
self:DeleteOnRemove(g1)
  end end) end end)
  self.Change = false
	self.ChangeT = CurTime() + math.random(4,10)	
	
	 elseif rand == 3 and IsValid(te3) and self.Change == false and CurTime() > self.ChangeT then
  self.Change = true
   g = ents.Create("npc_vj_g_blood suker3")
g:SetPos(self:GetPos())
g:SetAngles(self:GetAngles())
g:Spawn()
g:Activate()
g:SetOwner(self)
self:DeleteOnRemove(g)
timer.Simple(0.1,function() if IsValid(self) and IsValid(te3) then self:SetPos(te3:GetPos())
  timer.Simple(0.15,function() if IsValid(self) and IsValid(te3) then te3:SetPos(g:GetPos())
 g1 = ents.Create("npc_vj_g_blood suker3")
g1:SetPos(self:GetPos())
g1:SetAngles(self:GetAngles())
g1:Spawn()
g1:Activate()
g1:SetOwner(self)
self:DeleteOnRemove(g1)
  end end) end end)
  self.Change = false
	self.ChangeT = CurTime() + math.random(4,10)	
  end
  end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


