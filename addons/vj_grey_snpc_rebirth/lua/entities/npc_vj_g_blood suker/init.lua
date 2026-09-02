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
ENT.SoundTbl_Death = {"doll/idle1.wav","doll/idle3.wav"}
ENT.DeathSoundLevel = 110
ENT.GodMode = true

ENT.D = false

ENT.DT = 0
-------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
self:SetNoDraw(true)
self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
self.VJ_NoTarget = true
						
							end
					
---------------------------------
function ENT:CustomOnThink()
if self.D == false and CurTime() > self.DT then
self.D = true
local d = self:LocalToWorld(Vector(math.random(-4000,4000),math.random(-4000,4000),0) + self:GetUp()*3)
local d2 = self:LocalToWorld(Vector(math.random(-4000,4000),math.random(-4000,4000),0) + self:GetUp()*3)
local d3 = self:LocalToWorld(Vector(math.random(-4000,4000),math.random(-4000,4000),0) + self:GetUp()*3)
local d4 = self:LocalToWorld(Vector(math.random(-4000,4000),math.random(-4000,4000),0) + self:GetUp()*3)
local d5 = self:LocalToWorld(Vector(math.random(-4000,4000),math.random(-4000,4000),0) + self:GetUp()*3)
local d6 = self:LocalToWorld(Vector(math.random(-4000,4000),math.random(-4000,4000),0) + self:GetUp()*3)

timer.Simple(0.5,function() if IsValid(self) then a = ents.Create("npc_vj_g_blood suker2")
a:SetPos(d)
a:SetAngles(self:GetAngles())
a:Spawn()
a:Activate()
a:SetOwner(self)
self:DeleteOnRemove(a) 
 end end)


timer.Simple(0.5,function() if IsValid(self) then a1 = ents.Create("npc_vj_g_blood suker2")
a1:SetPos(d2)
a1:SetAngles(self:GetAngles())
a1:Spawn()
a1:Activate()
a1:SetOwner(self)
self:DeleteOnRemove(a1)
 end end)

timer.Simple(0.5,function() if IsValid(self) then a3 = ents.Create("npc_vj_g_blood suker2")
a3:SetPos(d3)
a3:SetAngles(self:GetAngles())
a3:Spawn()
a3:Activate()
a3:SetOwner(self)
self:DeleteOnRemove(a3) 
 end end)



timer.Simple(0.5,function() if IsValid(self) then a4 = ents.Create("npc_vj_g_blood suker2")
a4:SetPos(d4)
a4:SetAngles(self:GetAngles())
a4:Spawn()
a4:Activate()
a4:SetOwner(self)
self:DeleteOnRemove(a4)
 end end) 

timer.Simple(0.5,function() if IsValid(self) then a5 = ents.Create("npc_vj_g_blood suker2") 
a5:SetPos(d5)
a5:SetAngles(self:GetAngles())
a5:Spawn()
a5:Activate()
a5:SetOwner(self)
self:DeleteOnRemove(a5)
 end end)

timer.Simple(0.5,function() if IsValid(self) then a6 = ents.Create("npc_vj_g_blood suker2")
a6:SetPos(d6)
a6:SetAngles(self:GetAngles())
a6:Spawn()
a6:Activate()
a6:SetOwner(self) 
self:DeleteOnRemove(a6)
end end)

self.D = false
self.DT = CurTime() + math.random(0.8,1.5)
end
end

--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


