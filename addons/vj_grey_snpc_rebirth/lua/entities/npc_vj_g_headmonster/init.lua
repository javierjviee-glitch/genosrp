AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/Zombie/1.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 25
ENT.SightDistance = 5000
ENT.HullType = HULL_TINY
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.TurningSpeed = 24
ENT.DisableMeleeAttackAnimation = true
ENT.AA_GroundLimit = 100 
ENT.AA_MinWanderDist = 180 
ENT.AA_MoveAccelerate = 2.5 
ENT.AA_MoveDecelerate = 2.5 
ENT.Aerial_FlyingSpeed_Calm = 360 
ENT.Aerial_FlyingSpeed_Alerted = 360 
ENT.Aerial_AnimTbl_Calm = {"fly","fly2","fly2"}
ENT.Aerial_AnimTbl_Alerted = {"fly","fly2","fly2"}
ENT.FindEnemy_UseSphere = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AerialMove_Stop()
	if self:GetVelocity():Length() == 0 then
		self:SetLocalVelocity(Vector(0,0,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- How close does it have to be until it attacks?
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 60 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.1 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.4 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = math.random(6,11)
ENT.DisableMeleeAttackAnimation = false
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 1 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 3 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 5 -- How many reps?
ENT.HasDeathRagdoll = false
ENT.LimitChaseDistance = true 
ENT.LimitChaseDistance_Min = 1 
ENT.LimitChaseDistance_Max = 1000
ENT.TurningUseAllAxis = true
ENT.ConstantlyFaceEnemy = true
ENT.ConstantlyFaceEnemy_IfVisible = true 
ENT.ConstantlyFaceEnemy_IfAttacking = false 
ENT.ConstantlyFaceEnemy_Postures = "Both" 
ENT.ConstantlyFaceEnemy_MinDistance = 1500
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 8 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.NextMoveAfterFlinchTime = 1.3 -- How much time until it can move, attack, etc. | Use this for schedules or else the base will set the time 0.6 if it sees it's a schedule!
ENT.NextFlinchTime = 5 -- How much time until it can flinch again?
ENT.AnimTbl_Flinch = {"am_hurt_left_leg","am_hurt_right_leg"} 
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_MeleeAttack = {"head/fly.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"head/fly.wav"}
ENT.SoundTbl_Pain = {""}
ENT.SoundTbl_Death = {""}
ENT.SoundTbl_Breath = {"head/fly.wav"}

ENT.IdleSoundLevel = 150
ENT.nextcharge = 0
ENT.startcharge = 0
----------------------------------------------------------------
function ENT:CustomOnInitialize()
timer.Simple(0.01, function() if IsValid(self) then
self:SetPos(self:GetPos() + self:GetUp()*10) end end)

self:SetCollisionBounds(Vector(10, 10, 10), Vector(-10, -10, 0))
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 0)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
ParticleEffectAttach("skull blood", PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:OnThinkActive()
    local enemy = self:GetEnemy()
	
    if enemy ~= nil and CurTime() > self.nextcharge and IsValid(enemy) and self:Visible(enemy) and self:GetPos():Distance(enemy:GetPos()) <= 1200 then
        if not self:IsBusy() and self.Dead == false then
			self:DoChangeMovementType(VJ_MOVETYPE_STATIONARY)
            self.startcharge = true
            self:SetTurnTarget(self:GetEnemy(), 1)	
            timer.Simple(1, function()
                if IsValid(self) then
                    self.startcharge = false
					self:DoChangeMovementType(VJ_MOVETYPE_AERIAL)
                end
            end)
            
            self.nextcharge = CurTime() + math.random(4, 6)
        end
    end
    
    if self.startcharge == true and enemy ~= nil and IsValid(enemy) and self:Visible(enemy) and self.Dead == false then

        local toEnemy = (enemy:GetPos() - self:GetPos()):GetNormalized()
        self:SetVelocity(toEnemy * 120)
    end
end


  function ENT:TranslateActivity(act)
  self.flyanimation  = self:GetSequenceActivity(self:LookupSequence(VJ.PICK("fly","fly2","fly3")))
	if act == ACT_IDLE then
		return self.flyanimation
	end

	return self.BaseClass.TranslateActivity(self, act)
end
-----------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
ParticleEffect("blood_impact_red_01",self:GetPos(),Angle(0,0,0),nil)
ParticleEffect("blood_impact_red_01",self:GetPos(),Angle(0,0,0),nil)
ParticleEffect("blood_impact_red_01",self:GetPos(),Angle(0,0,0),nil)
end
--[[

	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


