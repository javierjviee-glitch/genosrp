--[[
	=============== Autorun File ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
]]
------------------ Addon Information ------------------
local PublicAddonName = "[VJ Base] The Hidden SNPC"
local AddonName = "[VJ Base] The Hidden SNPC"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_the_ghost_autorun.lua"
-------------------------------------------------------
if file.Exists("lua/autorun/vj_base_autorun.lua", "GAME") then
	include("autorun/vj_controls.lua")
	VJ.AddNPC("The White One", "npc_vj_the_ghost", "Horror")
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName, AddonType)
else
	if CLIENT then
		chat.AddText(
			Color(0, 200, 200), PublicAddonName,
			Color(0, 255, 0), " was unable to install, you are missing ",
			Color(255, 100, 0), "VJ Base!"
		)
		timer.Simple(1, function()
			if not VJGUI_ErrorFrame then
				VJGUI_ErrorFrame = vgui.Create("DFrame")
				VJGUI_ErrorFrame:SetTitle("ERROR!")
				VJGUI_ErrorFrame:SetSize(790, 560)
				VJGUI_ErrorFrame:SetPos((ScrW() - VJGUI_ErrorFrame:GetWide()) / 2, (ScrH() - VJGUI_ErrorFrame:GetTall()) / 2)
				VJGUI_ErrorFrame:MakePopup()
				VJGUI_ErrorFrame.Paint = function(self)
					draw.RoundedBox(8, 0, 0, self:GetWide(), self:GetTall(), Color(200, 0, 0, 150))
				end
				
				local VJURL = vgui.Create("DHTML", VJGUI_ErrorFrame)
				VJURL:SetPos(VJGUI_ErrorFrame:GetWide() * 0.005, VJGUI_ErrorFrame:GetTall() * 0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			end
		end)
	elseif SERVER then
		timer.Create("VJBASEMissing", 5, 0, function()
			print("VJ Base is Missing! Download it from the workshop!")
		end)
	end
end