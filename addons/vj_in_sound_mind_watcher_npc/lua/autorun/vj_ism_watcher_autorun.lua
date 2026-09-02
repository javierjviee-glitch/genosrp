local PublicAddonName = "In Sound Mind Watcher NPC"
local AddonName = "In Sound Mind"
local AddonType = "SNPC"
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua", "GAME")

if VJExists then
	include('autorun/vj_controls.lua')
	local vCat = "In Sound Mind"
	VJ.AddNPC("Watcher", "npc_vj_ism_watcher", vCat)
else
	if CLIENT then
		chat.AddText(Color(0, 200, 200), PublicAddonName,
		Color(0, 255, 0), " was unable to install, you are missing ",
		Color(255, 100, 0), "VJ Base!")
	end
	timer.Simple(1, function()
		if not VJF then
			if CLIENT then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790, 560)
				VJF:SetPos((ScrW() - VJF:GetWide()) / 2, (ScrH() - VJF:GetTall()) / 2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8, 0, 0, VJF:GetWide(), VJF:GetTall(), Color(200, 0, 0, 150))
				end
				
				local VJURL = vgui.Create("DHTML", VJF)
				VJURL:SetPos(VJF:GetWide() * 0.005, VJF:GetTall() * 0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif SERVER then
				timer.Create("VJBASEMissing", 5, 0, function()
					print("VJ Base is Missing! Download it from the workshop!")
				end)
			end
		end
	end)
end