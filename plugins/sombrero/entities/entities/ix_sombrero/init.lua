AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SombreroSeleccionador")

local casas = {
    "Gryffindor",
    "Slytherin",
    "Ravenclaw",
    "Hufflepuff"
}

function ENT:Initialize()
    self:SetModel("models/treakdown/choixpeau/tabouret.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.NextUse = 0
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if self.NextUse and self.NextUse > CurTime() then return end

    self.NextUse = CurTime() + 1
    local casa = table.Random(casas)

    net.Start("SombreroSeleccionador")
        net.WriteEntity(activator)
        net.WriteString(casa)
    net.Broadcast()

    sound.Play("genosrp/" .. string.lower(casa) .. ".wav", self:GetPos(), 75, 100, 1)
end
