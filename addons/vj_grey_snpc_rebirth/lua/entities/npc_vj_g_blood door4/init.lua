AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/gibs/hgibs.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 110
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.HullType = HULL_TINY
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GREY"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.HasLeapAttack = false -- Should the SNPC have a leap attack?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.Immune_Blast = true 
ENT.GodMode = true
ENT.SoundTbl_Death = {"doll/idle1.wav","doll/idle3.wav"}
ENT.DeathSoundLevel = 110


---Custom
ENT.Cand = false
ENT.CandT = 0
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
self:SetNoDraw(true)
timer.Simple(0.02,function() if IsValid(self) then self:SetPos(self:GetPos() + self:GetUp()* 50) end end)
self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
ParticleEffectAttach("blood_door", PATTACH_POINT_FOLLOW, self, 0)
self.VJ_NoTarget = true
						
				for _, x in ipairs(ents.GetAll()) do
					if (x:GetClass() ~= self:GetClass() and x:GetClass() ~= "npc_grenade_frag") and x:IsNPC() and self:Visible(x) then
						self.DisableMakingSelfEnemyToNPCs = true
						x:AddEntityRelationship(self,D_NU,99)
						if x.IsVJBaseSNPC == true then
							x.MyEnemy = NULL
							x:SetEnemy(NULL)
							x:ClearEnemyMemory()
						end
						if table.HasValue(self.NPCTbl_Combine,x:GetClass()) or table.HasValue(self.NPCTbl_Resistance,x:GetClass()) then
							x:VJ_SetSchedule(SCHED_RUN_RANDOM)
							x:SetEnemy(NULL)
							x:ClearEnemyMemory()
							end
							end
							end	
end
---------------------------------
function ENT:CustomOnThink()

if not IsValid(kaer4) then
local rand = math.random(1,5)
if rand == 1 then
kaer4 = ents.Create("npc_vj_g_doll")
kaer4:SetPos(self:GetPos())
kaer4:SetAngles(self:GetAngles())
kaer4:Spawn()
kaer4:Activate()
kaer4:SetOwner(self)
self:DeleteOnRemove(kaer4)

elseif rand == 2 then
kaer4 = ents.Create("npc_vj_g_dog")
kaer4:SetPos(self:GetPos())
kaer4:SetAngles(self:GetAngles())
kaer4:Spawn()
kaer4:Activate()
kaer4:SetOwner(self)
self:DeleteOnRemove(kaer4)

elseif rand == 3 then
kaer4 = ents.Create("npc_vj_g_headmonster")
kaer4:SetPos(self:GetPos())
kaer4:SetAngles(self:GetAngles())
kaer4:Spawn()
kaer4:Activate()
kaer4:SetOwner(self)
self:DeleteOnRemove(kaer4)

elseif rand == 4 then
kaer4 = ents.Create("npc_vj_g_floaters")
kaer4:SetPos(self:GetPos())
kaer4:SetAngles(self:GetAngles())
kaer4:Spawn()
kaer4:Activate()
kaer4:SetOwner(self)
self:DeleteOnRemove(kaer4)

elseif rand == 5 then
kaer4 = ents.Create("npc_vj_g_baby")
kaer4:SetPos(self:GetPos())
kaer4:SetAngles(self:GetAngles())
kaer4:Spawn()
kaer4:Activate()
kaer4:SetOwner(self)
self:DeleteOnRemove(kaer4)

end
end
end
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


