AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/babu.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 30000
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.Bleeds = false
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(30,56)
ENT.DisableWandering = true
ENT.ImmuneDamagesTable = {DMG_BURN,DMG_SLASH}
ENT.Immune_CombineBall = true -- Immune to Combine Ball
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.IgnoreCBDeath = true
ENT.FadeCorpse = true -- Fades the ragdoll on death
ENT.FadeCorpseTime = 0.5 -- How much time until the ragdoll fades | Unit = Seconds
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_Electricity = true -- Immune to Electrical
ENT.Immune_Physics = true
ENT.Immune_Blast = true
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.FootStepTimeRun = 0.53 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.53 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.HasSoundTrack = true
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
ENT.SoundTbl_SoundTrack = {"anyta/Claustrophobia.mp3","anyta/Clau.mp3"}
ENT.Curse = false
ENT.CurseT = 0
ENT.Death = false
ENT.DeathT = 0
ENT.hit = true
ENT.hit2 = true
ENT.hit3 = true
ENT.Curse5 = false
ENT.Curse5T = 0
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
self:SetColor(Color(0,0,0,110))
self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
self:SetRenderFX(kRenderFxFadeFast)
	self.VJ_NoTarget = true
						
		
end
--------------------------------- 
function ENT:CustomOnThink()
	self:RemoveAllDecals()
	if not IsValid(ghost4) and self.hit == false then
	self.GodMode = false
	self.hit = true
timer.Simple(0.2,function() if IsValid(self) then self:TakeDamage(10000,self,self) end end)
	ghost:Remove()
	ghost1:Remove()
	ghost2:Remove()
	ghost3:Remove()
	ghost5:Remove()
	ghost6:Remove()
	ghost7:Remove()
	ghost8:Remove()
	ghost9:Remove()
	ghost91:Remove()
	ghost92:Remove()
	ghost93:Remove()
end
if not IsValid(life3) and self.hit2 == false then
	self.GodMode = false
	self.hit2 = true
timer.Simple(0.2,function() if IsValid(self) then self:TakeDamage(1000,self,self) end end)
end
if not IsValid(life42) and self.hit3 == false then
	self.GodMode = false
	self.hit3 = true
	life4:Remove()
	life41:Remove()
timer.Simple(0.2,function() if IsValid(self) then self:TakeDamage(1000,self,self) end end)
end
end
------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self:GetEnemy() ~= nil then
	if self:Health() > 10000 then
	if not self:IsBusy() and self.Death == false then
	if CurTime() > self.DeathT then
	self.Death = true
	self:StopMoving()
	self.DisableChasingEnemy = true
	timer.Simple(0.2,function() if IsValid(self) then self:SetNoDraw(true) end end)
timer.Simple(0.21  ,function() if IsValid(self)	then self.VJ_NoTarget = true
						
	end end)
 if IsValid(self) and not IsValid(ghost) and not IsValid(ghost1) and not IsValid(ghost2) and not IsValid(ghost3) and not IsValid(ghost4) then 
 PrintMessage(HUD_PRINTCENTER, "Look for Anita's doll and kill it")
ghost = ents.Create("npc_vj_g_anyta toy")
ghost:SetPos(self:GetPos() + self:GetRight()*-20)
ghost:SetAngles(self:GetAngles())
ghost:Spawn()
ghost:SetColor(Color(0,0,0,110))
ghost:Activate()
ghost:SetOwner(self)
ghost:SetRenderFX(kRenderFxFadeFast)
self:DeleteOnRemove(ghost)
ghost1 = ents.Create("npc_vj_g_anyta toy")
ghost1:SetPos(self:GetPos() + self:GetRight()*20)
ghost1:SetAngles(self:GetAngles())
ghost1:Spawn()
ghost1:SetColor(Color(0,0,0,110))
ghost1:SetRenderFX(kRenderFxFadeFast)
ghost1:Activate()
ghost1:SetOwner(self)
self:DeleteOnRemove(ghost1)
ghost2 = ents.Create("npc_vj_g_anyta toy")
ghost2:SetPos(self:GetPos() + self:GetRight()*-10)
ghost2:SetAngles(self:GetAngles())
ghost2:Spawn()
ghost2:SetColor(Color(0,0,0,110))
ghost2:Activate()
ghost2:SetOwner(self)
ghost2:SetRenderFX(kRenderFxFadeFast)
self:DeleteOnRemove(ghost2)
ghost3 = ents.Create("npc_vj_g_anyta toy")
ghost3:SetPos(self:GetPos() + self:GetRight()*10)
ghost3:SetAngles(self:GetAngles())
ghost3:Spawn()
ghost3:SetColor(Color(0,0,0,110))
ghost3:SetRenderFX(kRenderFxFadeFast)
ghost3:Activate()
ghost3:SetOwner(self)
self:DeleteOnRemove(ghost3)
ghost4 = ents.Create("npc_vj_g_anyta doll")
ghost4:SetPos(self:GetPos() + self:GetRight()*10)
ghost4:SetAngles(self:GetAngles())
ghost4:Spawn()
ghost4:SetColor(Color(0,0,0,110))
ghost4:SetRenderFX(kRenderFxFadeFast)
ghost4:Activate()
ghost4:SetOwner(self)
self:DeleteOnRemove(ghost4)
ghost9 = ents.Create("npc_vj_g_anyta doll2")
ghost9:SetPos(self:GetPos())
ghost9:SetAngles(self:GetAngles())
ghost9:Spawn()
ghost9:SetColor(Color(0,0,0,110))
ghost9:SetRenderFX(kRenderFxFadeFast)
ghost9:Activate()
ghost9:SetOwner(self)
self:DeleteOnRemove(ghost9)

ghost93 = ents.Create("npc_vj_g_anyta doll2")
ghost93:SetPos(self:GetPos())
ghost93:SetAngles(self:GetAngles())
ghost93:Spawn()
ghost93:SetColor(Color(0,0,0,110))
ghost93:SetRenderFX(kRenderFxFadeFast)
ghost93:Activate()
ghost93:SetOwner(self)
self:DeleteOnRemove(ghost93)

ghost91 = ents.Create("npc_vj_g_anyta doll2")
ghost91:SetPos(self:GetPos() + self:GetRight()*-10)
ghost91:SetAngles(self:GetAngles())
ghost91:Spawn()
ghost91:SetColor(Color(0,0,0,110))
ghost91:SetRenderFX(kRenderFxFadeFast)
ghost91:Activate()
ghost91:SetOwner(self)
self:DeleteOnRemove(ghost91)

ghost92 = ents.Create("npc_vj_g_anyta doll2")
ghost92:SetPos(self:GetPos() + self:GetRight()*-6)
ghost92:SetAngles(self:GetAngles())
ghost92:Spawn()
ghost92:SetColor(Color(0,0,0,110))
ghost92:SetRenderFX(kRenderFxFadeFast)
ghost92:Activate()
ghost92:SetOwner(self)
self:DeleteOnRemove(ghost92)

ghost5 = ents.Create("npc_vj_g_anyta doll1")
ghost5:SetPos(self:GetPos() + self:GetRight()*-10)
ghost5:SetAngles(self:GetAngles())
ghost5:Spawn()
ghost5:SetColor(Color(0,0,0,200))
ghost5:SetRenderFX(kRenderFxFadeFast)
ghost5:Activate()
ghost5:SetOwner(self)
self:DeleteOnRemove(ghost5)
ghost6 = ents.Create("npc_vj_g_anyta doll1")
ghost6:SetPos(self:GetPos() + self:GetRight()*20)
ghost6:SetAngles(self:GetAngles())
ghost6:Spawn()
ghost6:SetColor(Color(0,0,0,200))
ghost6:SetRenderFX(kRenderFxFadeFast)
ghost6:Activate()
ghost6:SetOwner(self)
self:DeleteOnRemove(ghost6)
ghost7 = ents.Create("npc_vj_g_anyta doll1")
ghost7:SetPos(self:GetPos() + self:GetRight()*-20)
ghost7:SetAngles(self:GetAngles())
ghost7:Spawn()
ghost7:SetColor(Color(0,0,0,200))
ghost7:SetRenderFX(kRenderFxFadeFast)
ghost7:Activate()
ghost7:SetOwner(self)
self:DeleteOnRemove(ghost7)
ghost8 = ents.Create("npc_vj_g_anyta doll1")
ghost8:SetPos(self:GetPos())
ghost8:SetAngles(self:GetAngles())
ghost8:Spawn()
ghost8:SetColor(Color(0,0,0,200))
ghost8:SetRenderFX(kRenderFxFadeFast)
ghost8:Activate()
ghost8:SetOwner(self)
self:DeleteOnRemove(ghost8)
self.hit = false
end
	util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(30,44),DMG_BLAST,true,true)
	self.HasMeleeAttack = false					
	timer.Simple(math.random(4,8),function() if IsValid(self) then 

 timer.Simple(0.2,function() if IsValid(self) then self.VJ_NoTarget = true
						
				
							end end)
self:SetNoDraw(false)
	self.HasMeleeAttack = true
	self.Death = false
	self.DeathT = CurTime() + math.random(8,18)
	self.DisableChasingEnemy = false
	end end) 
	end
	end
	end
	end
if self:GetEnemy() ~= nil then
	if self:Health() <= 10000 and self:Health() > 5000 and self.Curse == false and not IsValid(life3) and CurTime() > self.CurseT then
	self.Curse = true
	self.Death = true
	 PrintMessage(HUD_PRINTCENTER, "Look for Anita's doll and kill it")
life3 = ents.Create("npc_vj_g_anyta curse1")
life3:SetPos(self:GetPos() + self:GetRight()*10)
life3:SetAngles(self:GetAngles())
life3:Spawn()
life3:SetColor(Color(213,0,0,110))
life3:Activate()
life3:SetOwner(self)
self:DeleteOnRemove(life3)
self.hit2 = false
	self.Curse = false
	self.CurseT = CurTime() + math.random(8,20)
	end
	end
	if self:GetEnemy() ~= nil then
	if self:Health() <= 5000 and self.Curse5 == false and not IsValid(life4) and not IsValid(life41) and not IsValid(life42) and CurTime() > self.Curse5T then
	self.Curse5 = true
	self.Death = true
	life4 = ents.Create("npc_vj_g_curse mother2")
life4:SetPos(self:GetPos() + self:GetRight()*10)
life4:SetAngles(self:GetAngles())
life4:Spawn()
life4:SetColor(Color(0,0,0,110))
life4:Activate()
life4:SetOwner(self)
self:DeleteOnRemove(life4)

life41 = ents.Create("npc_vj_g_curse mother")
life41:SetPos(self:GetPos() + self:GetRight()*-10)
life41:SetAngles(self:GetAngles())
life41:Spawn()
life41:SetColor(Color(0,0,0,110))
life41:Activate()
life41:SetOwner(self)
self:DeleteOnRemove(life41)

life42 = ents.Create("npc_vj_g_anyta curse1")
life42:SetPos(self:GetPos())
life42:SetAngles(self:GetAngles())
life42:Spawn()
life42:SetColor(Color(213,0,0,110))
life42:Activate()
life42:SetOwner(self)
self:DeleteOnRemove(life42)
self.hit3 = false
	self.Curse5 = false
	self.Curse5T = CurTime() + math.random(8,20)
	end
	end
	end

--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


