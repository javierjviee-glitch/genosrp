AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString("vj_ism_shade_darkness_fx")

ENT.Model = {"models/in_sound_mind/shade.mdl"}
ENT.StartHealth = 1500
ENT.HealthRegenParams = {
	Enabled = false, -- Can it regenerate its health?
	Amount = 150, -- How much should the health increase after every delay?
	Delay = VJ.SET(1, 2), -- How much time until the health increases
	ResetOnDmg = false, -- Should the delay reset when it receives damage?
}
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_GROUND
ENT.HullSizeNormal = false
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE
ENT.EnemyXRayDetection = true
ENT.VJ_NPC_Class = {"CLASS_ISM_MONSTERS"}
ENT.FootStepTimeWalk = 1
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 5
ENT.DeathDelayTime = 5
ENT.SightDistance = 4000
ENT.TurningSpeed = 20
ENT.CanTurnWhileMoving = true
ENT.HasPoseParameterLooking = false
ENT.AIType = VJ_AI_TYPE_COMBAT
ENT.DisableChasingEnemy = false
ENT.DisableWandering = false

-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {ACT_IDLE} -- The idle animation table when AI is enabled | DEFAULT: {ACT_IDLE}
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {ACT_RUN} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
ENT.IdleAlwaysWander = false -- If set to true, it will make the SNPC always wander when idling
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
ENT.DisableChasingEnemy = false -- Disables the SNPC chasing the enemy
	-- ====== No Chase After Certain Distance Variables ====== --
ENT.NoChaseAfterCertainRange = false -- Should the SNPC not be able to chase when it's between number x and y?
ENT.NoChaseAfterCertainRange_FarDistance = 2000 -- How far until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
ENT.NoChaseAfterCertainRange_CloseDistance = 100 -- How near until it can chase again? | "UseRangeDistance" = Use the number provided by the range attack instead
	-- ====== Sound Detection Variables ====== --
ENT.InvestigateSoundDistance = 2000 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
	-- ====== Miscellaneous Variables ====== --
ENT.AttackProps = false -- Should it attack props when trying to move?
ENT.PushProps = true -- Should it push props when trying to move?
ENT.PropAP_MaxSize = 1 -- This is a scale number for the max size it can attack/push | x < 1  = Smaller props & x > 1  = Larger props | Default base value: 1
	-- ====== Call For Help ====== --
ENT.CallForHelp = true -- Can the NPC request allies for help while in combat?
ENT.CallForHelpDistance = 20000 -- -- How far away the NPC's call for help travels
ENT.NextCallForHelpTime = 4 -- Time until it calls for help again
ENT.HasCallForHelpAnimation = false -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {}
ENT.CallForHelpAnimationFaceEnemy = false -- Should it face the enemy when playing the animation?
ENT.NextCallForHelpAnimationTime = 30 -- How much time until it can play the animation again?
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 40
ENT.MeleeAttackDamageType = DMG_NERVEGAS -- Type of Damage
	-- ====== Animation Variables ====== --
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.MeleeAttackAnimationAllowOtherTasks = false -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
	-- ====== Distance Variables ====== --
ENT.MeleeAttackDistance = 20 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 40 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer Variables ====== --
	-- To use event-based attacks, set this to false:
ENT.TimeUntilMeleeAttackDamage = 0.1 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 1 -- How much time until it can use a melee attack?
ENT.NextMeleeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Melee = 1 -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Melee_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = nil -- Extra melee attack timers, EX: {1, 1.4} | it will run the damage code after the given amount of seconds
ENT.StopMeleeAttackAfterFirstHit = false -- Should it stop the melee attack from running rest of timers when it hits an enemy?
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
ENT.DisableDefaultMeleeAttackCode = false -- When set to true, it will completely disable the melee attack code
ENT.DisableDefaultMeleeAttackDamageCode = false -- Disables the default melee attack damage code
	-- ====== Miscellaneous Variables ====== --
ENT.MeleeAttack_NoProps = false -- If set to true, it won't attack or push any props (Mostly used with multiple melee attacks)
	-- ====== Player Speed Modifier ====== --
ENT.MeleeAttackPlayerSpeed = true -- Should it modify the movement speed of players that got damaged?
ENT.MeleeAttackPlayerSpeedWalk = 25
ENT.MeleeAttackPlayerSpeedRun = 50
ENT.MeleeAttackPlayerSpeedTime = 3 -- How much time until player's speed resets back to normal
	-- ====== Immunity ====== --
ENT.GodMode = false -- Immune to everything
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = false -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = false -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = true -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.Immune_Sonic = true -- Immune to sonic-type damages
ENT.ForceDamageFromBosses = false -- Should the NPC get damaged by bosses regardless if it's not supposed to by skipping immunity checks, etc. | Bosses are attackers tagged with "VJ_ID_Boss"
ENT.AllowIgnition = false -- Can this NPC be set on fire?

ENT.CanFlinch = 2 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST,DMG_FIRE,DMG_BURN} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 15 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextMoveAfterFlinchTime = 5 -- How much time until it can move, attack, etc.
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextFlinchTime = 15 -- How much time until it can flinch again?
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- The regular flinch animations to play
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = false -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.FootStepTimeRun = 0.5
ENT.FootStepTimeWalk = 1

ENT.SoundTbl_Breath = {"in_sound_mind/shade/shade_voice_exposed_breath_1.wav","in_sound_mind/shade/shade_voice_exposed_breath_2.wav","in_sound_mind/shade/shade_voice_exposed_breath_3.wav","in_sound_mind/shade/shade_voice_deep_breath_1.wav","in_sound_mind/shade/shade_voice_deep_breath_2.wav","in_sound_mind/shade/shade_voice_deep_breath_3.wav","in_sound_mind/shade/shade_voice_deep_breath_4.wav"}
ENT.SoundTbl_Idle = {"in_sound_mind/shade/shade_voice_roam_losing_my_mind_1.wav","in_sound_mind/shade/shade_voice_roam_losing_my_mind_2.wav","in_sound_mind/shade/shade_voice_roam_so_dark_2.wav","in_sound_mind/shade/shade_voice_roam_so_dark_3.wav","in_sound_mind/shade/shade_voice_roam_what_happened_to_me_1.wav","in_sound_mind/shade/shade_voice_roam_what_happened_to_me_2.wav"}
ENT.SoundTbl_Alert = {"in_sound_mind/shade/shade_voice_alert_1.wav","in_sound_mind/shade/shade_voice_alert_2.wav","in_sound_mind/shade/shade_voice_alert_3.wav","in_sound_mind/shade/shade_voice_alert_4.wav","in_sound_mind/shade/shade_voice_alert_5.wav","in_sound_mind/shade/shade_voice_chase_there_you_are_1.wav","in_sound_mind/shade/shade_voice_chase_there_you_are_2.wav"}
ENT.SoundTbl_CombatIdle = {"in_sound_mind/shade/shade_voice_chase_come_here_1.wav","in_sound_mind/shade/shade_voice_chase_come_here_2.wav","in_sound_mind/shade/shade_voice_chase_i_gotta_show_you_something_1.wav","in_sound_mind/shade/shade_voice_chase_i_gotta_show_you_something_2.wav","in_sound_mind/shade/shade_voice_chase_ill_drown_you_1.wav","in_sound_mind/shade/shade_voice_chase_ill_drown_you_2.wav","in_sound_mind/shade/shade_voice_chase_quit_running_1.wav","in_sound_mind/shade/shade_voice_chase_quit_running_2.wav","in_sound_mind/shade/shade_voice_drowning_lets_share_the_darkness_1.wav","in_sound_mind/shade/shade_voice_drowning_lets_share_the_darkness_2.wav","in_sound_mind/shade/shade_voice_drowning_lets_share_the_darkness_3.wav","in_sound_mind/shade/shade_voice_misc_get_me_out_of_here_2.wav","in_sound_mind/shade/shade_voice_misc_get_me_out_of_here_3.wav","in_sound_mind/shade/shade_voice_misc_help_me_1.wav","in_sound_mind/shade/shade_voice_roam_afraid_anymore_2.wav","in_sound_mind/shade/shade_voice_roam_afraid_anymore_3.wav","in_sound_mind/shade/shade_voice_roam_im_drowning_2.wav","in_sound_mind/shade/shade_voice_roam_its_everywhere_1.wav","in_sound_mind/shade/shade_voice_roam_its_everywhere_2.wav","in_sound_mind/shade/shade_voice_roam_its_everywhere_3.wav"}
ENT.SoundTbl_Pain = {"in_sound_mind/shade/shade_voice_hurt_hit_ah_1.wav","in_sound_mind/shade/shade_voice_hurt_hit_ah_2.wav","in_sound_mind/shade/shade_voice_hurt_hit_ah_3.wav","in_sound_mind/shade/shade_voice_hurt_hit_ah_6.wav","in_sound_mind/shade/shade_voice_hurt_hit_gah_1.wav","in_sound_mind/shade/shade_voice_hurt_hit_gah_2.wav","in_sound_mind/shade/shade_voice_hurt_hit_gah_3.wav","in_sound_mind/shade/shade_voice_hurt_hit_gah_4.wav","in_sound_mind/shade/shade_voice_hurt_hit_gah_5.wav","in_sound_mind/shade/shade_voice_hurt_hit_gah_6.wav","in_sound_mind/shade/shade_voice_hurt_hit_this_is_how_you_help_1.wav","in_sound_mind/shade/shade_voice_hurt_hit_this_is_how_you_help_2.wav","in_sound_mind/shade/shade_voice_hurt_hit_this_is_how_you_help_3.wav","in_sound_mind/shade/shade_voice_hurt_hit_why_would_you_hurt_me_1.wav","in_sound_mind/shade/shade_voice_hurt_hit_why_would_you_hurt_me_2.wav","in_sound_mind/shade/shade_voice_running_no_1.wav","in_sound_mind/shade/shade_voice_running_no_2.wav"}
ENT.SoundTbl_Death = {"in_sound_mind/shade/shade_voice_misc_how_it_ends_1.wav","in_sound_mind/shade/shade_voice_misc_how_it_ends_2.wav","in_sound_mind/shade/shade_voice_misc_im_dying_1.wav","in_sound_mind/shade/shade_voice_scream_1.wav","in_sound_mind/shade/shade_voice_scream_2.wav","in_sound_mind/shade/shade_voice_scream_3.wav","in_sound_mind/shade/shade_voice_scream_4.wav","in_sound_mind/shade/shade_voice_scream_5.wav"}
ENT.SoundTbl_MeleeAttack = {"in_sound_mind/shade/shade_voice_drowning_do_you_feel_it_1.wav","in_sound_mind/shade/shade_voice_drowning_do_you_feel_it_2.wav","in_sound_mind/shade/shade_voice_drowning_do_you_feel_it_3.wav","in_sound_mind/shade/shade_voice_drowning_drown_with_me_1.wav","in_sound_mind/shade/shade_voice_drowning_get_down_here_2.wav","in_sound_mind/shade/shade_voice_drowning_surrender_to_me_1.wav","in_sound_mind/shade/shade_voice_drowning_surrender_to_me_2.wav","in_sound_mind/shade/shade_voice_drowning_that_light_is_mine_1.wav","in_sound_mind/shade/shade_voice_drowning_that_light_is_mine_2.wav","in_sound_mind/shade/shade_voice_drowning_you_failed_me_2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"in_sound_mind/shade/shade_voice_roam_growing_darker_3.wav","in_sound_mind/shade/shade_voice_roam_how_do_i_fight_1.wav","in_sound_mind/shade/shade_voice_roam_how_do_i_fight_2.wav",""}

ENT.BreathSoundLevel = 75
ENT.IdleSoundLevel = 100
ENT.AlertSoundLevel = 100
ENT.CombatIdleSoundLevel = 100
ENT.PainSoundLevel = 100
ENT.DeathSoundLevel = 100
ENT.MeleeAttackSoundLevel = 100
ENT.MeleeAttackMissSoundLevel = 100


function ENT:CustomOnInitialize()
    self:SetCollisionBounds(Vector(10, 5, 75), Vector(-10, -5, 0))
    self:SetSurroundingBounds(Vector(10, 5, 75), Vector(-10, -5, 0))
    ParticleEffectAttach("darkness", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("darkness"))
    ParticleEffectAttach("void", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("darkness"))
    ParticleEffectAttach("void1", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("darkness"))
    ParticleEffectAttach("void2", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("darkness"))
end

function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
    
    local damageType = dmginfo:GetDamageType()
    local pain = math.random(1,100)    
    local laugh = math.random(1,70)
    
    if damageType == DMG_BLAST then
        dmginfo:ScaleDamage(2)
        if pain == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_get_it_off_of_me_1.wav",100,100)
            
          elseif pain == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_get_it_off_of_me_2.wav",100,100)
            
          elseif pain == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_i_cant_see_1.wav",100,100)
            
          elseif pain == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_1.wav",100,100)
         
          elseif pain == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_2.wav",100,100)       
          
          elseif pain == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_2.wav",100,100) 
          
          elseif pain == 7 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_1.wav",100,100) 
          
          elseif pain == 8 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_2.wav",100,100)
          
          elseif pain == 9 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_3.wav",100,100)
          
          elseif pain == 10 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_4.wav",100,100)
          
          elseif pain == 11 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_cant_see_bright_side_1.wav",100,100)
          
          elseif pain == 12 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_cant_see_bright_side_2.wav",100,100)
          
          elseif pain == 13 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_1.wav",100,100)
          
          elseif pain == 14 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_2.wav",100,100)
            
          elseif pain == 15 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_3.wav",100,100)  
          
          elseif pain == 16 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_not_what_i_meant_1.wav",100,100)  
          
          elseif pain == 17 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_not_what_i_meant_2.wav",100,100)
          end
        self.PainSoundChance = 0
        self:Retreat()
        
   elseif damageType == DMG_BURN then  
        dmginfo:ScaleDamage(2)
        if pain == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_get_it_off_of_me_1.wav",100,100)
            
          elseif pain == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_get_it_off_of_me_2.wav",100,100)
            
          elseif pain == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_i_cant_see_1.wav",100,100)
            
          elseif pain == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_1.wav",100,100)
         
          elseif pain == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_2.wav",100,100)       
          
          elseif pain == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_2.wav",100,100) 
          
          elseif pain == 7 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_1.wav",100,100) 
          
          elseif pain == 8 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_2.wav",100,100)
          
          elseif pain == 9 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_3.wav",100,100)
          
          elseif pain == 10 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_4.wav",100,100)
          
          elseif pain == 11 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_cant_see_bright_side_1.wav",100,100)
          
          elseif pain == 12 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_cant_see_bright_side_2.wav",100,100)
          
          elseif pain == 13 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_1.wav",100,100)
          
          elseif pain == 14 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_2.wav",100,100)
            
          elseif pain == 15 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_3.wav",100,100)  
          
          elseif pain == 16 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_not_what_i_meant_1.wav",100,100)  
          
          elseif pain == 17 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_not_what_i_meant_2.wav",100,100)
          end
        self.PainSoundChance = 0
        self:Retreat()
        
   elseif damageType == DMG_FIRE then  
        dmginfo:ScaleDamage(2)
        if pain == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_get_it_off_of_me_1.wav",100,100)
            
          elseif pain == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_get_it_off_of_me_2.wav",100,100)
            
          elseif pain == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_i_cant_see_1.wav",100,100)
            
          elseif pain == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_1.wav",100,100)
         
          elseif pain == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_2.wav",100,100)       
          
          elseif pain == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_it_burns_2.wav",100,100) 
          
          elseif pain == 7 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_1.wav",100,100) 
          
          elseif pain == 8 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_2.wav",100,100)
          
          elseif pain == 9 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_3.wav",100,100)
          
          elseif pain == 10 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_hurt_light_my_eyes_4.wav",100,100)
          
          elseif pain == 11 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_cant_see_bright_side_1.wav",100,100)
          
          elseif pain == 12 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_cant_see_bright_side_2.wav",100,100)
          
          elseif pain == 13 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_1.wav",100,100)
          
          elseif pain == 14 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_2.wav",100,100)
            
          elseif pain == 15 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_roam_not_what_i_meant_3.wav",100,100)  
          
          elseif pain == 16 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_not_what_i_meant_1.wav",100,100)  
          
          elseif pain == 17 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_not_what_i_meant_2.wav",100,100)
          end
        self.PainSoundChance = 0
        self:Retreat()
        
   elseif damageType == DMG_BULLET then  
        dmginfo:ScaleDamage(0.25)
        if laugh == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_1.wav",100,100)
            
          elseif laugh == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_2.wav",100,100)
            
          elseif laugh == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_3.wav",100,100)
            
          elseif laugh == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_4.wav",100,100)
         
          elseif laugh == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_5.wav",100,100)       
          
          elseif laugh == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_6.wav",100,100) 
          
          elseif laugh == 7 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_7.wav",100,100) 
          
          elseif laugh == 8 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_lets_do_this_again_1.wav",100,100)
          
          elseif laugh == 9 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_lets_do_this_again_2.wav",100,100)
        end 
        self.PainSoundChance = 0
        
   elseif damageType == DMG_BUCKSHOT then  
        dmginfo:ScaleDamage(0.25)  
        if laugh == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_1.wav",100,100)
            
          elseif laugh == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_2.wav",100,100)
            
          elseif laugh == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_3.wav",100,100)
            
          elseif laugh == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_4.wav",100,100)
         
          elseif laugh == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_5.wav",100,100)       
          
          elseif laugh == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_6.wav",100,100) 
          
          elseif laugh == 7 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_7.wav",100,100) 
          
          elseif laugh == 8 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_lets_do_this_again_1.wav",100,100)
          
          elseif laugh == 9 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_lets_do_this_again_2.wav",100,100)
        end         
        self.PainSoundChance = 0
        
   elseif damageType == DMG_AIRBOAT then  
        dmginfo:ScaleDamage(0.25)        
        if laugh == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_1.wav",100,100)
            
          elseif laugh == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_2.wav",100,100)
            
          elseif laugh == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_3.wav",100,100)
            
          elseif laugh == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_4.wav",100,100)
         
          elseif laugh == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_5.wav",100,100)       
          
          elseif laugh == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_6.wav",100,100) 
          
          elseif laugh == 7 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_laughter_7.wav",100,100) 
          
          elseif laugh == 8 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_lets_do_this_again_1.wav",100,100)
          
          elseif laugh == 9 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_lets_do_this_again_2.wav",100,100)
        end 
        self.PainSoundChance = 0
   end

end


function ENT:Retreat()
  if self.IsRetreating then return end -- ��� ���������, �� ��������� �����
     self.IsRetreating = true

  self.Behavior = VJ_BEHAVIOR_PASSIVE
  self.HealthRegenParams = {
	  Enabled = true, -- Can it regenerate its health?
	  Amount = 150, -- How much should the health increase after every delay?
	  Delay = VJ.SET(1, 2), -- How much time until the health increases
	  ResetOnDmg = false, -- Should the delay reset when it receives damage?
  }

  timer.Simple(5,function() if IsValid(self) then
    self.HealthRegenParams = {
	  Enabled = false, -- Can it regenerate its health?
	  Amount = 150, -- How much should the health increase after every delay?
	  Delay = VJ.SET(1, 2), -- How much time until the health increases
	  ResetOnDmg = false, -- Should the delay reset when it receives damage?
    }
    self.Behavior = VJ_BEHAVIOR_AGGRESSIVE
    self.MeleeAttackDamage = 80
    
    local rage = math.random(1,6)
    
    if rage == 1 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_ill_never_stop_1.wav",100,100)
            
          elseif rage == 2 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_misc_ill_never_stop_2.wav",100,100)
            
          elseif rage == 3 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_we_were_friends_1.wav",100,100)
            
          elseif rage == 4 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_i_just_wanted_to_help_1.wav",100,100)
         
          elseif rage == 5 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_i_just_wanted_to_help_2.wav",100,100)       
          
          elseif rage == 6 then
            VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_running_we_were_friends_2.wav",100,100) 
    end
    
        
      timer.Simple(20,function() if IsValid(self) then
      self.MeleeAttackDamage = 40
      self.IsRetreating = false 
    end
    end)
    
    end
    end)
end

function ENT:CustomOnTakeDamage_AfterDamage()

  if self:Health() < 500 then
    VJ_EmitSound(self,"in_sound_mind/shade/shade_voice_lowhp_1.wav",100,100)
  end

end

function ENT:CustomOnThink()
    self:DarknessEffectNearbyPlayer()
    self:ApplyLightDamage()
end

function ENT:ApplyLightDamage()
    if self.NextLightDamage and self.NextLightDamage > CurTime() then return end
    self.NextLightDamage = CurTime() + 0.5

    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() and ply:FlashlightIsOn() then
            local dist = self:GetPos():Distance(ply:GetPos())
            if dist <= 350 then
                self:TakeDamage(8, ply, ply)
            end
        end
    end
end

function ENT:DarknessEffectNearbyPlayer()
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() then
            local dist = self:GetPos():Distance(ply:GetPos())

            local fadeDist = 500
            local maxDarkDist = 100
            local intensity = math.Clamp(1 - ((dist - maxDarkDist) / (fadeDist - maxDarkDist)), 0, 1)

            net.Start("vj_ism_shade_darkness_fx")
            net.WriteFloat(intensity)
            net.Send(ply)
        end
    end
end

function ENT:CustomOnRemove()
    self:ResetDarknessForPlayers()
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
    self:ResetDarknessForPlayers()
end

function ENT:ResetDarknessForPlayers()
    for _, ply in ipairs(player.GetAll()) do
        net.Start("vj_ism_shade_darkness_fx")
        net.WriteFloat(0)
        net.Send(ply)
    end
end