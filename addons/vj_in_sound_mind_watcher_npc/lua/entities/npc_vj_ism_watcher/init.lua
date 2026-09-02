AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	Copyright (c) 2012-2016 by DrVrej, All rights reserved.
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
]]
ENT.Model = {"models/in_sound_mind/watcher.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 900
ENT.SightDistance = 2500
ENT.HullType = HULL_HUMAN
ENT.HasDeathAnimation = true -- Should it play death animations?
ENT.AnimTbl_Death = {ACT_DIESIMPLE}

ENT.AA_GroundLimit = 50 -- If the NPC's distance from itself to the ground is less than this, it will attempt to move up
ENT.AA_MinWanderDist = 150 -- Minimum distance that it should move when wandering
ENT.AA_MoveAccelerate = 5 -- It will gradually speed up to the max movement speed as it moves towards its destination | Calculation = FrameTime * x
	-- 0 = Constant max speed | 1 = Slight acceleration | 50 = Rapid acceleration

ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_ShouldBeFlying = true
ENT.DisableMeleeAttackAnimation = false
ENT.Aerial_FlyingSpeed_Calm = 50 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 2000
ENT.Aerial_AnimTbl_Calm = {"walk"} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {"run"}
ENT.FindEnemy_UseSphere = true
ENT.Aerial_CurrentMoveAnimationType = "Wander"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AerialMove_Stop()
	if self:GetVelocity():Length() == 0 then
		self:SetLocalVelocity(Vector(0,0,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ISM_MONSTERS"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.Behavior = VJ_BEHAVIOR_NEUTRAL
ENT.CanOpenDoors = true
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Can it melee attack?
ENT.MeleeAttackDamage = 25
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.HasMeleeAttackKnockBack = false -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
ENT.DisableDefaultMeleeAttackCode = false -- Completely disable the default melee attack code
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
	-- ====== Animation ====== --
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1 -- Animations to play when it melee attacks | false = Don't play an animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- Decreases animation time | Use it to fix animations that have extra frames at the end
	-- ====== Distance ====== --
ENT.MeleeAttackDistance = 50 -- How close an enemy has to be to trigger a melee attack | false = Auto calculate on initialize based on its collision bounds
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of it | 180 = All around it
ENT.MeleeAttackDamageDistance = 50 -- How far does the damage go? | false = Auto calculate on initialize based on its collision bounds
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of it | 180 = All around it
-- ====== Investigation ====== --
ENT.CanInvestigate = true -- Can it detect and investigate disturbances? | EX: Sounds, movement, flashlight, bullet hits
ENT.InvestigateSoundMultiplier = 500 -- Max sound hearing distance multiplier | This multiplies the calculated volume of the sound
	-- ====== Timer ====== --
ENT.TimeUntilMeleeAttackDamage = 0.45 -- How much time until it executes the damage? | false = Make the attack event-based
ENT.NextMeleeAttackTime = 1 -- How much time until it can use a melee attack? | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.NextAnyAttackTime_Melee = 1.5 -- How much time until it can do any attack again? | false = Base auto calculates the duration | number = Specific time | VJ.SET = Randomized between the 2 numbers
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = false -- Extra melee attack timers, EX: {1, 1.4}
ENT.MeleeAttackStopOnHit = false -- Should it stop executing the melee attack after it hits an enemy?
	-- ====== Bleeding System ====== --
	-- Causes the enemy to continue taking damage after it's hit based on the given parameters:
ENT.MeleeAttackBleedEnemy = false -- Should it bleed enemies it hits?
ENT.MeleeAttackBleedEnemyChance = 3 -- Chance that the enemy bleeds | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage per repetition
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next repetition?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many repetitions?
	-- ====== Player Speed Modifier ====== --
ENT.MeleeAttackPlayerSpeed = false -- Should it modify the movement speed of players that got damaged?
ENT.MeleeAttackPlayerSpeedWalk = 100
ENT.MeleeAttackPlayerSpeedRun = 100
ENT.MeleeAttackPlayerSpeedTime = 5 -- How much time until player's speed resets back to normal
	-- ====== Immunity Variables ====== --
ENT.GodMode = false -- Immune to everything
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = true -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = true -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = false -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.Immune_Physics = false -- Immune to physics impacts, won't take damage from props
ENT.Immune_Sonic = true -- Immune to sonic-type damages
ENT.ImmuneDamagesTable = {} -- Makes the SNPC immune to specific type of damages | Takes DMG_ enumerations

ENT.HasIdleSounds = true
ENT.HasInvestigateSounds = true -- Can it play sounds when it investigates something?
ENT.HasLostEnemySounds = true -- Can it play sounds when it looses its enemy?
ENT.HasAlertSounds = true -- Can it play alert sounds?
ENT.HasCombatIdleSounds = true
ENT.HasMeleeAttackSounds = true -- Can it play melee attack sounds? | Controls "self.SoundTbl_BeforeMeleeAttack", "self.SoundTbl_MeleeAttack", "self.SoundTbl_MeleeAttackExtra"
ENT.HasMeleeAttackMissSounds = true -- Can it play melee attack miss sounds?
ENT.HasPainSounds = true -- Can it play pain sounds?
ENT.HasDeathSounds = true -- Can it play death sounds?

ENT.InvestigateSoundChance = 1
ENT.LostEnemySoundChance = 1

	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"ism/watcher/watcher_cry.wav","ism/watcher/watcher_whisper_hate_myself_1.wav","ism/watcher/watcher_whisper_ill_kill_you_1.wav","ism/watcher/watcher_whisper_im_a_monster_1.wav","ism/watcher/watcher_whisper_im_already_in_pain_2.wav","ism/watcher/watcher_whisper_im_so_sorry_1.wav","ism/watcher/watcher_whisper_leave_me_alone_1.wav","ism/watcher/watcher_whisper_let_me_hide_2.wav","ism/watcher/watcher_whisper_not_my_fault_1.wav","ism/watcher/watcher_whisper_people_let_me_be_2.wav","ism/watcher/watcher_whisper_shattered_2.wav","ism/watcher/watcher_whisper_stop_it_2.wav","ism/watcher/watcher_whisper_stop_watching_me_4.wav","ism/watcher/watcher_whisper_they_all_judge_1.wav","ism/watcher/watcher_whisper_they_all_watch_1.wav","ism/watcher/watcher_whisper_you_hurting_me_1.wav","ism/watcher/watcher_whisper_you_laughing_at_me_2.wav","ism/watcher/watcher_whisper_broken_1.wav","ism/watcher/watcher_whisper_dont_judge_me_1.wav","ism/watcher/watcher_whisper_dont_look_at_me_2.wav","ism/watcher/watcher_whisper_falling_apart_1.wav","ism/watcher/watcher_whisper_go_away_1.wav","ism/watcher/watcher_hum_ah_1.wav","ism/watcher/watcher_hum_ah_2.wav","ism/watcher/watcher_hum_ah_3.wav","ism/watcher/watcher_hum_hu_1.wav","ism/watcher/watcher_hum_hu_2.wav","ism/watcher/watcher_hum_hu_3.wav","ism/watcher/watcher_hum_um_2.wav"}
ENT.SoundTbl_Investigate = {"ism/watcher/watcher_inv_1.wav","ism/watcher/watcher_inv_2.wav","ism/watcher/watcher_inv_3.wav","ism/watcher/watcher_inv_4.wav"}
ENT.SoundTbl_LostEnemy = {"ism/watcher/watcher_post_falling_apart_1.wav","ism/watcher/watcher_post_go_away_1.wav","ism/watcher/watcher_post_i_hate_myself_1.wav","ism/watcher/watcher_post_im_so_sorry_1.wav","ism/watcher/watcher_post_let_me_be_1.wav","ism/watcher/watcher_post_let_me_hide_1.wav","ism/watcher/watcher_post_they_all_judge_1.wav","ism/watcher/watcher_post_why_1.wav"}
ENT.SoundTbl_Alert = {"ism/watcher/watcher_chase_die_2.wav","ism/watcher/watcher_chase_enough_1.wav","ism/watcher/watcher_chase_go_away_1.wav","ism/watcher/watcher_chase_how_dare_you_1.wav","ism/watcher/watcher_chase_i_will_end_you_1.wav","ism/watcher/watcher_chase_ill_kill_you_1.wav","ism/watcher/watcher_chase_leave_me_alone_1.wav","ism/watcher/watcher_chase_stop_watching_me_1.wav"}
ENT.SoundTbl_CombatIdle = {"ism/watcher/watcher_roaming_1.wav","ism/watcher/watcher_roaming_4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"ism/watcher/mirror_piece_swing_3.wav"}
ENT.SoundTbl_MeleeAttack = {"ism/watcher/watcher_melee_hit_1.wav","ism/watcher/watcher_melee_hit_2.wav","ism/watcher/watcher_melee_hit_3.wav"}
ENT.SoundTbl_Pain = {"ism/watcher/watcher_hit_1.wav","ism/watcher/watcher_hit_2.wav","ism/watcher/watcher_hit_3.wav","ism/watcher/watcher_hit_5.wav","ism/watcher/watcher_hit_6.wav","ism/watcher/watcher_hit_7.wav","ism/watcher/watcher_hit_8.wav","ism/watcher/watcher_hit_9.wav","ism/watcher/watcher_hit_10.wav","ism/watcher/watcher_scared_no_1.wav","ism/watcher/watcher_scared_stop_it_1.wav"}
ENT.SoundTbl_Death = {"ism/watcher/watcher_scream_4.wav","ism/watcher/watcher_scream_5.wav","ism/watcher/watcher_scream_7.wav"}

ENT.IdleSoundLevel = 750
ENT.InvestigateSoundLevel = 750
ENT.LostEnemySoundLevel = 750
ENT.AlertSoundLevel = 750
ENT.CombatIdleSoundLevel = 750
ENT.MeleeAttackMissSoundLevel = 450
ENT.MeleeAttackSoundLevel = 450
ENT.PainSoundLevel = 750
ENT.DeathSoundLevel = 750

function ENT:CustomOnInitialize()
    self:SetCollisionBounds(Vector(10, 5, 75), Vector(-10, -5, 0))
    self:SetSurroundingBounds(Vector(10, 5, 75), Vector(-10, -5, 0))
    ParticleEffectAttach("smoke_exhaust_01",PATTACH_POINT_FOLLOW,self,self:LookupAttachment("smoke"))
    
    local maskLight = ents.Create("light_dynamic")
    if IsValid(maskLight) then
        maskLight:SetKeyValue("_light", "48 15 85 255")
        maskLight:SetKeyValue("spotlight_radius", 1)
        maskLight:SetKeyValue("distance", 40)
        maskLight:SetKeyValue("brightness", 0)
        maskLight:Fire("SetParentAttachment", "light")
        maskLight:Spawn()
        maskLight:SetParent(self)
        self:DeleteOnRemove(maskLight)
    end
      
    self:SetEnemy(nil)
    self:SetSkin(0)
    self.IsAggressive = false
    self.LookTime = 0
end

function ENT:CustomOnThink()
    if not self.LastPlayerCheck or CurTime() - self.LastPlayerCheck > 0.1 then
        local ply = self:FindNearestPlayer(2500)
        self.LastPlayerCheck = CurTime()
        
        if IsValid(ply) and self:PlayerIsLookingAtMe(ply) and self:Visible(ply) then
            if not self.IsAggressive then
                self.LookTime = self.LookTime + FrameTime()
                if self.LookTime >= 0.5 then
                    self:OnPlayerSight(ply)
                end
            end
            timer.Remove("calm_timer_" .. self:EntIndex())
        else
            self.LookTime = 0
            if self.IsAggressive and not timer.Exists("calm_timer_" .. self:EntIndex()) then
                timer.Create("calm_timer_" .. self:EntIndex(), 20, 1, function()
                    if IsValid(self) then
                        self:BecomeNeutral()
                    end
                end)
            end
        end
    end
end

function ENT:OnPlayerSight(ent)
    if not IsValid(ent) or not ent:IsPlayer() then return end

    -- ���� NPC ��� �� ����������, �� ���������� �����������
    if not self.IsAggressive then
        self:OnAlert(ent)
    end
end

function ENT:OnAlert(ent)
    if not IsValid(ent) then return end

    self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
    self:SetLastPosition(ent:GetPos())
    self:VJ_TASK_GOTO_LASTPOS("TASK_RUN")
    self:SetSkin(1)
    self.IsAggressive = true
    timer.Remove("calm_timer_" .. self:EntIndex())
end

function ENT:BecomeNeutral()
    self.Behavior = VJ_BEHAVIOR_NEUTRAL
    self.VJ_NoTarget = true
    self:SetEnemy(nil)
    self:SetSkin(0)
    self.IsAggressive = false
    timer.Remove("calm_timer_" .. self:EntIndex())
end

function ENT:PlayerIsLookingAtMe(ply)
    local npcPos = self:EyePos()
    local plyPos = ply:EyePos()
    
    -- Short distance always returns true
    if plyPos:DistToSqr(npcPos) < 10000 then return true end
    
    local dir = (npcPos - plyPos):GetNormalized()
    local aimVec = ply:GetAimVector()

    return aimVec:Dot(dir) > 0.95
end

function ENT:FindNearestPlayer(range)
    local nearestPly, nearestDist = nil, range
    local myPos = self:GetPos()

    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() then
            local dist = myPos:DistToSqr(ply:GetPos())
            if dist < nearestDist * nearestDist then
                nearestDist = math.sqrt(dist)
                nearestPly = ply
            end
        end
    end

    return nearestPly
end

function ENT:CustomOnTakeDamage_AfterDamage()
	local health = self:Health()
	local bodygroup = 5 -- Default to 5 (healed state)

	if not self.HasHealed then
		if health >= 750 then
			bodygroup = 0
		elseif health >= 600 then
			bodygroup = 1
		elseif health >= 450 then
			bodygroup = 2
		elseif health >= 300 then
			bodygroup = 3
		elseif health >= 150 then
			bodygroup = 4
		else
			-- Heal at 150 HP
			self:SetHealth(900)
			self.HasHealed = true
		end
	end

	self:SetBodygroup(2, bodygroup)
end


-- Attack configurations table to avoid code duplication
local ATTACK_CONFIGS = {
	[1] = {
		anim = {"attack2"},
		damageDistance = 70,
		extraTimers = {0.45, 0.9},
		bleedChance = 1,
		bleedReps = 5
	},
	[2] = {
		anim = {"attack"},
		damageDistance = 70,
		extraTimers = {0.45},
		bleedChance = 70,
		bleedReps = 4
	},
	[3] = {
		anim = {"attack"},
		damageDistance = 70,
		extraTimers = {0.45},
		bleedChance = 70,
		bleedReps = 4
	}
}

function ENT:MultipleMeleeAttacks()
	local randomattack = math.random(1, 3)
	local cfg = ATTACK_CONFIGS[randomattack]

	self.MeleeAttackDamage = 25
	self.MeleeAttackDamageType = DMG_SLASH
	self.HasMeleeAttackKnockBack = false
	self.DisableDefaultMeleeAttackCode = false
	self.DisableDefaultMeleeAttackDamageCode = false
	self.AnimTbl_MeleeAttack = cfg.anim
	self.MeleeAttackAnimationFaceEnemy = true
	self.MeleeAttackAnimationDecreaseLengthAmount = 0
	self.MeleeAttackDistance = 50
	self.MeleeAttackAngleRadius = 100
	self.MeleeAttackDamageDistance = cfg.damageDistance
	self.MeleeAttackDamageAngleRadius = 100
	self.TimeUntilMeleeAttackDamage = 0.45
	self.NextMeleeAttackTime = 1
	self.NextAnyAttackTime_Melee = 1
	self.MeleeAttackReps = 1
	self.MeleeAttackExtraTimers = cfg.extraTimers
	self.MeleeAttackStopOnHit = false
	self.MeleeAttackBleedEnemy = true
	self.MeleeAttackBleedEnemyChance = cfg.bleedChance
	self.MeleeAttackBleedEnemyDamage = 5
	self.MeleeAttackBleedEnemyTime = 1
	self.MeleeAttackBleedEnemyReps = cfg.bleedReps
end

ENT.LastPosCheck = 0
ENT.LastPosition = nil
ENT.StuckTime = 0
ENT.StuckThreshold = 2

-- Find a safe position for the NPC when stuck
local function FindSafePosition(self, startPos, direction, maxDistance, step)
    step = step or 20
    maxDistance = maxDistance or 200

    for dist = step, maxDistance, step do
        local checkPos = startPos + direction * dist
        local tr = util.TraceHull({
            start = checkPos + Vector(0, 0, 10),
            endpos = checkPos + Vector(0, 0, 10),
            mins = Vector(-16, -16, 0),
            maxs = Vector(16, 16, 72),
            filter = self,
            mask = MASK_SOLID_BRUSHONLY
        })
        if not tr.Hit then return checkPos end
    end
    return nil
end

function ENT:CustomOnThink_AIEnabled()
    if self:GetEnemy() then
        local enemy = self:GetEnemy()
        local dist = self:GetPos():Distance(enemy:GetPos())
        local los = self:Visible(enemy)

        if dist > 300 and los and not self:IsMoving() then
            self:SetLastPosition(enemy:GetPos())
            self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
        end

        local curTime = CurTime()
        if curTime - self.LastPosCheck > 1 then
            self.LastPosCheck = curTime
            local curPos = self:GetPos()

            if self.LastPosition and curPos:DistToSqr(self.LastPosition) < 25 then
                self.StuckTime = self.StuckTime + 1
            else
                self.StuckTime = 0
            end

            self.LastPosition = curPos

            if self.StuckTime >= self.StuckThreshold then
                local dir = (enemy:GetPos() - self:GetPos()):GetNormalized()
                local safePos = FindSafePosition(self, self:GetPos(), dir, 200, 20)
                if safePos then
                    self:SetPos(safePos)
                end
                self.StuckTime = 0
            end
        end
    end
end

--[[
	Copyright (c) 2012-2016 by DrVrej, All rights reserved.
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
]]