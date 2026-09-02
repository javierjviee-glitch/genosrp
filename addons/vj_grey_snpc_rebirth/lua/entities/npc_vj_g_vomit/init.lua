AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/zombie_vomit.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 300
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 40 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(25,37)
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
ENT.SoundTbl_FootStep = {"hczombie/foot1.wav","hczombie/foot2.wav","hczombie/foot3.wav","hczombie/foot4.wav"}
ENT.SoundTbl_Alert = {"hczombie/alert1.wav","hczombie/alert2.wav","hczombie/alert3.wav"}
ENT.SoundTbl_MeleeAttack = {"hczombie/attack1.wav","hczombie/attack2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"hczombie/miss1.wav","hczombie/miss2.wav"}
ENT.SoundTbl_RangeAttack = {"hczombie/attack1.wav"}
ENT.SoundTbl_Pain = {"hczombie/idle2.wav","hczombie/idle3.wav"}
ENT.SoundTbl_Death = {"hczombie/die2.wav"}

ENT.BLOOD = false
ENT.BLOODT = 0
ENT.B = false
ENT.BT = 0
------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
if self:GetEnemy() ~= nil then
local EnemyDistance = self:VJ_GetNearestPointToEntityDistance(self:GetEnemy(),self:GetPos():Distance(self:GetEnemy():GetPos()))
if self.B == false and CurTime() > self.BT then
if EnemyDistance > 200 and EnemyDistance < 500 then
self.B = true
effect3 = ents.Create("info_particle_system")
			effect3:SetKeyValue("effect_name","blood_spr")
			effect3:SetLocalPos(self:GetPos())
			effect3:SetOwner(self)
			effect3:SetParent(self)
			effect3:Fire("Start","",0)
		    effect3:Fire("Kill","",1.5)
			effect3:Fire("SetParentAttachmentMaintainOffset","maw")
			effect3:Fire("SetParentAttachment","maw")
			effect3:Spawn()
			effect3:Activate()
			self.B = false 
			self.BT = CurTime() + math.random(1.5,3.8)
			end
			end
			end
			end
-----------------------------------------
function ENT:CustomAttack()
local EnemyDistance = self:VJ_GetNearestPointToEntityDistance(self:GetEnemy(),self:GetPos():Distance(self:GetEnemy():GetPos()))
if self:GetEnemy() ~= nil then
if self.BLOOD == false and CurTime() > self.BLOODT then
if EnemyDistance > 0 and EnemyDistance < 100 then
self.BLOOD = true
effect3 = ents.Create("info_particle_system")
			effect3:SetKeyValue("effect_name","blood_spr")
			effect3:SetLocalPos(self:GetPos())
			effect3:SetOwner(self)
			effect3:SetParent(self)
			effect3:Fire("Start","",0.1)
		    effect3:Fire("Kill","",0.9)
			effect3:Fire("SetParentAttachmentMaintainOffset","maw")
			effect3:Fire("SetParentAttachment","maw")
			effect3:Spawn()
			effect3:Activate()
			
util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*40,30,11,DMG_BURN,true,true)
timer.Simple(0.2,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*43,40,math.random(10,28),DMG_BURN,true,true) end end)
timer.Simple(0.4,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*43,40,math.random(15,28),DMG_BURN,true,true) end end)
timer.Simple(0.6,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*43,40,math.random(15,28),DMG_BURN,true,true) end end)
timer.Simple(0.8,function() if IsValid(self) then util.VJ_SphereDamage(self,self,self:GetPos() + self:GetForward()*43,40,math.random(15,28),DMG_BURN,true,true) end end)
timer.Simple(math.random(1,1.5),function() if IsValid(self) then self.BLOOD = false 
self.BLOODT = CurTime() + math.random(0.9,1.4)
 end end)
end
end
end
end
-----------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
local exp = math.random(1,2)
if exp == 1 then
ParticleEffect("vomt boom",self:GetPos() + self:GetUp()*30,Angle(0,0,0),nil)
util.VJ_SphereDamage(self,self,self:GetPos(),100,math.random(28,45),DMG_BLAST,true,true)
end
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


