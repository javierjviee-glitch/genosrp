AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=50,vRight=0,vUp=0},Entities = {"npc_vj_g_babu","npc_vj_g_baby","npc_vj_g_creepy","npc_vj_g_vomit","npc_vj_g_hatred","npc_vj_g_doll","npc_vj_g_dog","npc_vj_g_floaters","npc_vj_g_floaters2","npc_vj_g_floaters3"}},
	{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=100,vUp=0},Entities = {"npc_vj_g_babu","npc_vj_g_baby","npc_vj_g_creepy","npc_vj_g_vomit","npc_vj_g_hatred","npc_vj_g_doll","npc_vj_g_dog","npc_vj_g_floaters","npc_vj_g_floaters2","npc_vj_g_floaters3"}},
	{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=100,vUp=0},Entities = {"npc_vj_g_babu","npc_vj_g_baby","npc_vj_g_creepy","npc_vj_g_vomit","npc_vj_g_hatred","npc_vj_g_doll","npc_vj_g_dog","npc_vj_g_floaters","npc_vj_g_floaters2","npc_vj_g_floaters3"}},
	{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-100,vUp=0},Entities = {"npc_vj_g_babu","npc_vj_g_baby","npc_vj_g_creepy","npc_vj_g_vomit","npc_vj_g_hatred","npc_vj_g_doll","npc_vj_g_dog","npc_vj_g_floaters","npc_vj_g_floaters2","npc_vj_g_floaters3"}},
	{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-100,vUp=0},Entities = {"npc_vj_g_babu","npc_vj_g_baby","npc_vj_g_creepy","npc_vj_g_vomit","npc_vj_g_hatred","npc_vj_g_doll","npc_vj_g_dog","npc_vj_g_floaters","npc_vj_g_floaters2","npc_vj_g_floaters3"}},
}
--[[
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--]]


