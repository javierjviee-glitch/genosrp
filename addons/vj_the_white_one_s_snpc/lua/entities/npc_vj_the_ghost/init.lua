AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = "models/player/morko.mdl"
ENT.StartHealth = 250
ENT.VJ_NPC_Class = {"CLASS_GHOST"}
ENT.UsePoseParameterMovement = true
ENT.BloodColor = VJ.BLOOD_COLOR_RED

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = "vjges_" .. ACT_GMOD_GESTURE_RANGE_ZOMBIE
ENT.MeleeAttackDamage = 30

ENT.HasExtraMeleeAttackSounds = true
ENT.FootstepSoundTimerWalk = 0.5
ENT.FootstepSoundTimerRun = 0.3


ENT.SoundTbl_CombatIdle = {
	"hidden/imhere.wav", "hidden/imhere01.wav", "hidden/imhere02.wav", "hidden/imhere03.wav", "hidden/imhere04.wav",
	"hidden/behindyou.wav", "hidden/behindyou01.wav", "hidden/behindyou02.wav",
	"hidden/overhere01.wav", "hidden/overhere02.wav", "hidden/overhere03.wav",
	"hidden/turnaround01.wav", "hidden/turnaround02.wav"
}
ENT.SoundTbl_Alert = {
	"hidden/comingforyou01.wav", "hidden/comingforyou02.wav", "hidden/comingforyou03.wav",
	"hidden/iseeyou.wav", "hidden/iseeyou01.wav", "hidden/iseeyou02.wav", "hidden/iseeyou03.wav",
	"hidden/you'renext01.wav", "hidden/you'renext02.wav"
}
ENT.SoundTbl_BeforeMeleeAttack = {"hidden/pigstick01.wav", "hidden/pigstick02.wav", "hidden/pigstick03.wav", "hidden/pigstick04.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/fast_zombie/claw_strike1.wav"}
ENT.SoundTbl_Pain = {"hidden/pain04.wav", "npc/fast_zombie/claw_strike2.wav", "npc/fast_zombie/claw_strike3.wav"}
ENT.SoundTbl_OnKilledEnemy = {"hidden/freshmeat01.wav", "hidden/freshmeat02.wav", "hidden/freshmeat03.wav"}
ENT.SoundTbl_Death = {"hidden/death01.wav", "hidden/death02.wav", "hidden/death03.wav", "hidden/death04.wav", "hidden/death05.wav", "hidden/death06.wav"}

local DEFAULT_PITCH = 100
ENT.CombatIdleSoundPitch1 = DEFAULT_PITCH
ENT.CombatIdleSoundPitch2 = DEFAULT_PITCH
ENT.AlertSoundPitch1 = DEFAULT_PITCH
ENT.AlertSoundPitch2 = DEFAULT_PITCH
ENT.MeleeAttackSoundPitch1 = DEFAULT_PITCH
ENT.MeleeAttackSoundPitch2 = DEFAULT_PITCH
ENT.PainSoundPitch1 = DEFAULT_PITCH
ENT.PainSoundPitch2 = DEFAULT_PITCH
ENT.DeathSoundPitch1 = DEFAULT_PITCH
ENT.DeathSoundPitch2 = DEFAULT_PITCH
ENT.OnKilledEnemySoundPitch1 = DEFAULT_PITCH
ENT.OnKilledEnemySoundPitch2 = DEFAULT_PITCH

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CustomOnInitialize()
	self:SetMaterial("Models/effects/vol_light001")
	self:DrawShadow(false)
	self:SetRenderFX(kRenderFxDistort)
	self.VJ_NoTarget = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo, hitgroup)
	self:SetMaterial("models/morko/mask_001")
	local ent = self
	timer.Simple(0.2, function()
		if IsValid(ent) then
			ent:SetMaterial("Invisible")
		end
	end)
	if self.HasSounds and self.HasImpactSounds then
		local soundPath = "vj_impact_metal/bullet_metal/metalsolid" .. math.random(1, 10) .. ".wav"
		VJ_EmitSound(self, soundPath, 70)
	end
	dmginfo:ScaleDamage(0.5)
end
---------------------------------------------------------------------------------------------------------------------------------------------
local animsWalk = {ACT_HL2MP_WALK_CROUCH_KNIFE}

function ENT:SetAnimationTranslations(wepHoldType)
	self.AnimationTranslations[ACT_IDLE] = ACT_HL2MP_IDLE_CROUCH_KNIFE
	self.AnimationTranslations[ACT_WALK] = animsWalk[1]
	self.AnimationTranslations[ACT_RUN] = ACT_HL2MP_RUN_KNIFE
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
]]