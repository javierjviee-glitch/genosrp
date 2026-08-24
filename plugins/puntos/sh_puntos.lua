PLUGIN = PLUGIN or ix.plugin.Get("puntos") or {}
local PLUGIN = PLUGIN

if SERVER then
    util.AddNetworkString("AbrirMenuPuntos")
    util.AddNetworkString("ActualizarPuntos")
    util.AddNetworkString("ResetPuntos")

    PLUGIN.puntos = PLUGIN.puntos or {
        Gryffindor = 0,
        Slytherin = 0,
        Ravenclaw = 0,
        Hufflepuff = 0
    }

    net.Receive("ActualizarPuntos", function(_, ply)
        if not IsValid(ply) or not ix.config.Get("permitirModificarPuntos", true) then return end

        local casa = net.ReadString()
        local cantidad = net.ReadInt(16)

        PLUGIN.puntos[casa] = math.max(0, PLUGIN.puntos[casa] + cantidad)

        net.Start("AbrirMenuPuntos")
        net.WriteTable(PLUGIN.puntos)
        net.Send(ply)
    end)

    net.Receive("ResetPuntos", function(_, ply)
        if not IsValid(ply) or not ix.config.Get("permitirModificarPuntos", true) then return end

        for casa in pairs(PLUGIN.puntos) do
            PLUGIN.puntos[casa] = 0
        end

        net.Start("AbrirMenuPuntos")
        net.WriteTable(PLUGIN.puntos)
        net.Send(ply)
    end)

    concommand.Add("abrir_puntos", function(ply)
        if not IsValid(ply) then return end

        net.Start("AbrirMenuPuntos")
        net.WriteTable(PLUGIN.puntos)
        net.Send(ply)
    end)
end



if CLIENT then


    hook.Add("OnPlayerChat", "AbrirMenuPuntosChat", function(ply, text)
        if ply == LocalPlayer() and string.lower(text) == "!puntos" then
            RunConsoleCommand("abrir_puntos")
            return true
        end
    end)

    net.Receive("AbrirMenuPuntos", function()
        local puntos = net.ReadTable()


        if IsValid(ixPuntosFrame) then
            ixPuntosFrame:Remove()
        end

        ixPuntosFrame = vgui.Create("DFrame")
        local frame = ixPuntosFrame
        frame:SetSize(300, 400)
        frame:Center()
        frame:SetTitle("Puntos de las Casas")
        frame:MakePopup()

        local casas = {
            {nombre = "Gryffindor", color = Color(200, 0, 0)},
            {nombre = "Slytherin", color = Color(0, 150, 0)},
            {nombre = "Ravenclaw", color = Color(0, 100, 200)},
            {nombre = "Hufflepuff", color = Color(200, 200, 0)}
        }

        local permitir = true
        if ix.config then
            permitir = ix.config.Get("permitirModificarPuntos", true)
        end

        for _, casa in ipairs(casas) do
            local panel = vgui.Create("DPanel", frame)
            panel:Dock(TOP)
            panel:SetTall(50)

            panel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, casa.color)
                draw.SimpleText(casa.nombre .. ": " .. puntos[casa.nombre], "DermaLarge", 10, 10, color_white)
            end

            local sub = vgui.Create("DButton", panel)
            sub:Dock(RIGHT)
            sub:SetText("-")
            sub:SetWide(40)
            sub:SetDisabled(not permitir)
            sub.DoClick = function()
                net.Start("ActualizarPuntos")
                net.WriteString(casa.nombre)
                net.WriteInt(-1, 16)
                net.SendToServer()
            end

            local add = vgui.Create("DButton", panel)
            add:Dock(RIGHT)
            add:SetText("+")
            add:SetWide(40)
            add:SetDisabled(not permitir)
            add.DoClick = function()
                net.Start("ActualizarPuntos")
                net.WriteString(casa.nombre)
                net.WriteInt(1, 16)
                net.SendToServer()
            end
        end

        local resetPanel = vgui.Create("DPanel", frame)
        resetPanel:Dock(TOP)
        resetPanel:SetTall(40)

        resetPanel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30))
        end

        local resetButton = vgui.Create("DButton", resetPanel)
        resetButton:Dock(FILL)
        resetButton:SetText("Resetear todos los puntos")
        resetButton:SetDisabled(not permitir)
        resetButton.DoClick = function()
            net.Start("ResetPuntos")
            net.SendToServer()
        end

        local statusLabel = vgui.Create("DLabel", frame)
        statusLabel:Dock(TOP)
        statusLabel:SetTall(20)
        statusLabel:SetText(permitir and "Modificación de puntos habilitada." or "Modificación de puntos deshabilitada.")
        statusLabel:SetTextColor(permitir and Color(0, 255, 0) or Color(255, 100, 100))
        statusLabel:SetContentAlignment(5)
    end)
end
