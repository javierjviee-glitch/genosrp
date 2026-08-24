include("shared.lua")

net.Receive("SombreroSeleccionador", function()
    local ply = net.ReadEntity()
    local casa = net.ReadString()

    if IsValid(ply) and ply == LocalPlayer() then
        chat.AddText(Color(255, 215, 0), "[Sombrero Seleccionador] ", Color(255, 255, 255), "Has sido elegido para ", Color(100, 149, 237), casa)
    end
end)
