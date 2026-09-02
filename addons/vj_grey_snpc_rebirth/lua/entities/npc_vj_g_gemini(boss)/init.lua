AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/gemini.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 10000
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.VJ_IsHugeMonster = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.Immune_Dissolve = true -- Immune to Dissolving | Example: Combine Ball
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiatio
ENT.FindEnemy_UseSphere = true
ENT.Immune_Electricity = true -- Immune to Electrical
ENT.Immune_Physics = true -- Immune to Physics
ENT.RangeAttackMinDistance = 60
ENT.RangeAttackMaxDistance = 3000 
ENT.RangeUseAttachmentForPos = true 
ENT.RangeUseAttachmentForPosID = "bone11"
ENT.AnimTbl_RangeAttack = {"range"} -- Range Attack Animations
ENT.RangeAttackProjectiles = "obj_dm_blood"	
ENT.TimeUntilRangeAttackProjectileRelease = 0.6 -- How much time until the projectile code is ran?
ENT.NextRangeAttackTime = math.random(1,4) -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.8
ENT.RangeAttackExtraTimers = {0.6,0.7,0.8,0.7}
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.HasSoundTrack = true -- Does the SNPC have a sound track?
ENT.ImmuneDamagesTable = {DMG_BURN} -- You can set Specific types of damages for the SNPC to be immune to
	-- ====== Flinching Code ====== --
ENT.Flinches = 2 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_SMALL_FLINCH} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
ENT.NextFlinch = 0.6 -- How much time until it can attack, move and flinch again
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"boss/foot1.wav","boss/foot2.wav","boss/foot3.wav"}
ENT.SoundTbl_Alert = {"boss/call.wav"}
ENT.SoundTbl_Idle = {"boss/Mom_063.wav","boss/Mom_039.wav","boss/Mom_040.wav"}
ENT.SoundTbl_MeleeAttack = {"boss/dogbite1.wav","boss/dogbite2.wav"}
ENT.SoundTbl_BeforeRangeAttack = {"boss/Mom_026.wav","boss/Mom_001.wav","boss/Mom_026.wav","boss/Mom_063.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"boss/claw_miss1.wav"}
ENT.SoundTbl_Pain = {"boss/Mom_001.wav","boss/Mom_026.wav","boss/Mom_028.wav"}
ENT.SoundTbl_Death = {""}
ENT.SoundTbl_SoundTrack = {"boss/Ash_whereiam.wav"}

ENT.BeforeRangeAttackSoundLevel = 130
ENT.AlertSoundLevel = 130
ENT.PainSoundLevel = 130
ENT.IdleSoundLevel = 130
-- Custom
ENT.Death = false
ENT.DeathT = 0
ENT.Cand = false
ENT.Curse = false
ENT.CurseT = 0
ENT.Last = false
ENT.LastT = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
if self:Health() == 10000 then
    local randattack = math.random(1,1)
		
	    if randattack == 1 then
		self.MeleeAttackDistance = 100
		self.TimeUntilMeleeAttackDamage = 0.5
		self.NextAnyAttackTime_Melee = 0.6
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamageAngleRadius = 180
		self.AnimTbl_MeleeAttack = {"bite"}
		self.MeleeAttackExtraTimers = {} 
		self.MeleeAttackDamage = math.random(14,23)
		self.MeleeAttackDamageDistance = 160
		self.MeleeAttackDamageType = DMG_SLASH
end		
end
		if self:Health() < 10000 then
    local randattack = math.random(1,2)
		
	    if randattack == 1 then
		self.MeleeAttackDistance = 100
		self.TimeUntilMeleeAttackDamage = 0.5
		self.NextAnyAttackTime_Melee = 0.6
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamageAngleRadius = 180
		self.AnimTbl_MeleeAttack = {"bite"}
		self.MeleeAttackExtraTimers = {} 
		self.MeleeAttackDamage = math.random(14,23)
		self.MeleeAttackDamageDistance = 160
		self.MeleeAttackDamageType = DMG_SLASH
	
		elseif randattack == 2 then
		self.MeleeAttackDistance = 600
		self.TimeUntilMeleeAttackDamage = 0.5
		self.NextAnyAttackTime_Melee = 1.6
		self.MeleeAttackAngleRadius = 100
		self.MeleeAttackAnimationFaceEnemy = false
		self.MeleeAttackDamageAngleRadius = 100
		self.AnimTbl_MeleeAttack = {"bite"}
		self.MeleeAttackExtraTimers = {} 
		self.MeleeAttackDamage = math.random(14,23)
		self.MeleeAttackDamageDistance = 160
		self.MeleeAttackDamageType = DMG_SLASH
end
end
end
---------------------------------------------------------------
function ENT:OnMeleeAttack(status, enemy)
if status == "Init" then
if self.MeleeAttackDistance == 100 then
local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood floor")
		effect1:SetPos(self:GetPos() + self:GetUp()*10)

		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",1.2)
		
local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","gem_blood attack")
		effect1:SetPos(self:GetPos() + self:GetForward()*100)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.5)
		effect1:Fire("Kill","",1.2)
timer.Simple(0.5,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*100,80,30,DMG_SLASH,true,true) end end)
		local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","gem_blood attack")
		effect1:SetPos(self:GetPos() + self:GetForward()*-100)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.5)
		effect1:Fire("Kill","",1.2)
		timer.Simple(0.5,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*-100,80,30,DMG_SLASH,true,true) end end)
		local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","gem_blood attack")
		effect1:SetPos(self:GetPos() + self:GetRight()*-100)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.5)
		effect1:Fire("Kill","",1.2)
		timer.Simple(0.5,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetRight()*-100,80,30,DMG_SLASH,true,true) end end)
		local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","gem_blood attack")
		effect1:SetPos(self:GetPos() + self:GetRight()*100)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.5)
		effect1:Fire("Kill","",1.2)
		timer.Simple(0.5,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetRight()*100,80,30,DMG_SLASH,true,true) end end)
	
end 
if self.MeleeAttackDistance == 600 then
timer.Simple(0.1,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*100 + self:GetUp()*20)

		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*100,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.2,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*150 + self:GetUp()*20)

		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*150,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.3,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*200 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*200,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.4,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*250 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*250,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.5,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*300 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*300,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.6,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*350 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*350,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.7,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*400 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*400,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.8,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*450 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*450,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(0.9,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*500 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*500,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(1,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*550 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*550,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(1.1,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*600 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*600,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(1.2,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*650 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*650,80,math.random(6,26),DMG_SLASH,true,true) end end)
		timer.Simple(1.3,function() if IsValid(self) then local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","blood_door")
		effect1:SetPos(self:GetPos() + self:GetForward()*700 + self:GetUp()*20)
	
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.1)
		effect1:Fire("Kill","",0.7)
		util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*700,80,math.random(6,26),DMG_SLASH,true,true) end end)
		end
		end
		end
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
PrintMessage(HUD_PRINTCENTER, "Kill these skulls, it can destroy the BOSS shield!")
self:SetCollisionBounds(Vector(20, 20, 70), Vector(-20, -20, 0))
self.GodMode = true
h7 = ents.Create("npc_vj_g_blood skull")
h7:SetPos(self:GetPos() + self:GetUp()*90 +self:GetRight()*-45)
h7:SetAngles(self:GetAngles())
h7:Spawn()
h7:SetParent(self)
h7:Activate()
h7:SetOwner(self)
h = ents.Create("npc_vj_g_blood skull")
h:SetPos(self:GetPos() + self:GetUp()*80 +self:GetRight()*-40)
h:SetAngles(self:GetAngles())
h:Spawn()
h:SetParent(self)
h:Activate()
h:SetOwner(self)
h1 = ents.Create("npc_vj_g_blood skull")
h1:SetPos(self:GetPos() + self:GetUp()*60 +self:GetRight()*-54)
h1:SetAngles(self:GetAngles())
h1:Spawn()
h1:SetParent(self)
h1:Activate()
h1:SetOwner(self)
h2 = ents.Create("npc_vj_g_blood skull")
h2:SetPos(self:GetPos() + self:GetUp()*110)
h2:SetAngles(self:GetAngles())
h2:Spawn()
h2:SetParent(self)
h2:Activate()
h2:SetOwner(self)
ParticleEffectAttach("blood_flyer2", PATTACH_POINT_FOLLOW, self, 1)
end
---------------------------------
function ENT:OnThink()
if not IsValid(h2) and not IsValid(h1) and not IsValid(h) and not IsValid(h7) and self.Cand == false then
self.Cand = true
self.GodMode = false
self.Curse = true
PrintMessage(HUD_PRINTCENTER, "BOSS was enraged, the attack will become more violent")
end
end

  function ENT:TranslateActivity(act)
	if act == ACT_RUN and self:Health() == self:GetMaxHealth() then
		return ACT_WALK
	end

	return self.BaseClass.TranslateActivity(self, act)
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
if self:Health() >= 7000 then
if self:GetEnemy() ~= nil then
	if not IsValid(h2) and not IsValid(h1) and not IsValid(h) and not IsValid(h7) and not self:IsBusy() and self.Death == false then
	if CurTime() > self.DeathT then
	self.Death = true
	self:StopMoving()
	self.DisableChasingEnemy = true
	self.GodMode = true	
	local p3 = self:LocalToWorld(Vector(math.random(-100,100),math.random(-100,100),0) + self:GetUp()*0)
	local p2 = self:LocalToWorld(Vector(math.random(-100,100),math.random(-100,100),0) + self:GetUp()*0)
	local p1 = self:LocalToWorld(Vector(math.random(-100,100),math.random(-100,100),0) + self:GetUp()*0)	
	local Poser = self:GetEnemy()
	timer.Simple(0.2,function() if IsValid(self) then self:SetNoDraw(true)
self:StopParticles() end end)

	VJ_EmitSound(self,"gur.wav",100,100)
	VJ_EmitSound(self,"gur.wav",100,100)
	util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(30,44),DMG_BLAST,true,true)
	ParticleEffectAttach("vomit boom2", PATTACH_POINT_FOLLOW, self, 0)
	ParticleEffect("vomit boom2",self:GetPos() + self:GetForward()*11 + self:GetUp()*40,Angle(0,0,0),nil)
	self.HasMeleeAttack = false
	self.HasRangeAttack = false
	self.VJ_NoTarget = true
						
		
timer.Simple(math.random(9,12),function() if IsValid(self) and IsValid(Poser) then
		
timer.Simple(0.2,function() if IsValid(self) then self:SetNoDraw(false) self.GodMode = false
self.HasMeleeAttack = true
	self.HasRangeAttack = true
	self.VJ_NoTarget = false
	VJ_EmitSound(self,"gur.wav",100,100)
	VJ_EmitSound(self,"gur.wav",100,100)
	
	util.VJ_SphereDamage(self,self,self:GetPos(),80,math.random(30,44),DMG_BLAST,true,true)
	ParticleEffectAttach("vomit boom2", PATTACH_POINT_FOLLOW, self, 0)
	ParticleEffect("vomit boom2",self:GetPos() + self:GetForward()*11 + self:GetUp()*40,Angle(0,0,0),nil)
	self.DisableMakingSelfEnemyToNPCs = false
	self.Death = false
	self.DeathT = CurTime() + math.random(10,30)
	self.DisableChasingEnemy = false

 end end)
timer.Simple(0.3,function() if IsValid(self) then ParticleEffectAttach("blood_flyer2", PATTACH_POINT_FOLLOW, self, 1)
 end end)
timer.Simple(0.2,function() if not IsValid(zom) and not IsValid(zom2) and not IsValid(zom3) then 
ParticleEffect("vomit boom2",p1,Angle(0,0,0),nil)
zom = ents.Create("npc_vj_g_gurulo")
zom:SetPos(p1)
zom:SetAngles(self:GetAngles())
zom:Spawn()
zom:Activate()
zom:SetOwner(self)
self:DeleteOnRemove(zom)
ParticleEffect("vomit boom2",p2,Angle(0,0,0),nil)
zom2 = ents.Create("npc_vj_g_gurulo")
zom2:SetPos(p2)
zom2:SetAngles(self:GetAngles())
zom2:Spawn()
zom2:Activate()
zom2:SetOwner(self)
self:DeleteOnRemove(zom2)
ParticleEffect("vomit boom2",p3,Angle(0,0,0),nil)
zom3 = ents.Create("npc_vj_g_gurulo")
zom3:SetPos(p3)
zom3:SetAngles(self:GetAngles())
zom3:Spawn()
zom3:Activate()
zom3:SetOwner(self)
self:DeleteOnRemove(zom3)
 end end)
	end end)
	end
	end
	end
	end
if self:Health() < 7000 then
	if not IsValid(self.wave6) and not self:IsBusy() and self.Last == false then
	if CurTime() > self.LastT then
	self.Last = true
	self.Death = true
	self.HasMeleeAttack = false
	self.HasRangeAttack = false
	self.VJ_NoTarget = true
	self.DisableMakingSelfEnemyToNPCs = true
	self.DisableWandering = true
	self.DisableChasingEnemy = true
	self:StopMoving()
	PrintMessage(HUD_PRINTCENTER, "BOSS into the final stage, be careful of those blood storms")
local door = self:LocalToWorld(Vector(math.random(-500,500),math.random(-500,500),0) + self:GetUp()*0)
local door2 = self:LocalToWorld(Vector(math.random(-500,500),math.random(-500,500),0) + self:GetUp()*0)
local door3 = self:LocalToWorld(Vector(math.random(-500,500),math.random(-500,500),0) + self:GetUp()*0)
local door4 = self:LocalToWorld(Vector(math.random(-500,500),math.random(-500,500),0) + self:GetUp()*0)		
local door5 = self:LocalToWorld(Vector(math.random(-500,500),math.random(-500,500),0) + self:GetUp()*0)
local door6 = self:LocalToWorld(Vector(math.random(-500,500),math.random(-500,500),0) + self:GetUp()*0)	

self.wave6 = ents.Create("npc_vj_g_blood suker")
self.wave6:SetPos(self:GetPos())
self.wave6:SetAngles(self:GetAngles())
self.wave6:Spawn()
self.wave6:Activate()
self.wave6:SetOwner(self)
self.wave6:SetParent(self)
self:DeleteOnRemove(self.wave6)
self.Last = false
self.LastT = CurTime() + math.random(1,3)
end
end
end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert()
	
	if math.random(1,1) == 1 then
		self:VJ_ACT_PLAYACTIVITY("range",true,1.2,true,0)
	end

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_BeforeStartTimer() 
local effect1 = ents.Create("info_particle_system")
		effect1:SetKeyValue("effect_name","raollblood")
		effect1:SetPos(self:GetAttachment(self:LookupAttachment("bone11")).Pos)
		effect1:SetAngles(self:GetAttachment(self:LookupAttachment("bone11")).Ang)
		effect1:Fire("SetParentAttachment","bone11")
		effect1:SetParent(self)
		effect1:Spawn()
		effect1:Activate()
		effect1:Fire("Start","",0.2)
		effect1:Fire("Kill","",1)
		end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackProjVel(projectile)
	return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(math.random(-30,60),math.random(-50,50),math.random(34,78))))*2 + self:GetUp()*220
end
-----------------------------------------------------------------------------------------------------
function ENT:CustomAttack()
if self:GetEnemy() ~= nil then
if self.Curse == false and CurTime() > self.CurseT then
local Curse = self:GetEnemy()
local pos = Curse:LocalToWorld(Vector(math.random(10,10),math.random(10,10),0) + self:GetUp()*10)
self.Curse = true
local effect11 = ents.Create("info_particle_system")
		effect11:SetKeyValue("effect_name","blood floor")
		effect11:SetPos(pos)
		effect11:Spawn()
		effect11:Activate()
		effect11:Fire("Start","",0.01)
		effect11:Fire("Kill","",3.3)
		local effect12 = ents.Create("info_particle_system")
		effect12:SetKeyValue("effect_name","curse blood")
		effect12:SetPos(pos)
		effect12:Spawn()
		effect12:Activate()
		effect12:Fire("Start","",1.4)
		effect12:Fire("Kill","",3.2)
		
	timer.Simple(1.4,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(1.6,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(1.8,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(2,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(2.2,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(2.4,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(2.6,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(2.8,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	timer.Simple(3,function() if IsValid(self) then util.VJ_SphereDamage(self,self,pos,160,math.random(30,44),DMG_BLAST,true,true) end end)
	self.Curse = false
	self.CurseT = CurTime() + math.random(4,12)	
	end
	end
	end
	-----------------------------------------
function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo,hitgroup)
mane = ents.Create("npc_vj_g_healther")
mane:SetPos(self:GetPos())
mane:SetAngles(self:GetAngles())
mane:Spawn()
mane:Activate()
mane:SetOwner(self)
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


