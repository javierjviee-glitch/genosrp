local PLUGIN = PLUGIN or ix.plugin.Get("hechizos")

if SERVER then
    util.AddNetworkString("AbrirMenuHechizos")
    util.AddNetworkString("EjecutarHechizo")

    ------------------------------------------------------------------------
    -- COMANDO /HECHIZOS
    ------------------------------------------------------------------------

    ix.command.Add("hechizos", {
        description = "Abre el libro de hechizos.",
        OnRun = function(_, client)
            net.Start("AbrirMenuHechizos")
            net.Send(client)
        end
    })

    ------------------------------------------------------------------------
    -- EJECUTAR HECHIZO
    ------------------------------------------------------------------------

    net.Receive("EjecutarHechizo", function(_, ply)

        local hechizo = string.lower(net.ReadString())

        --------------------------------------------------------------------
        -- LUMOS
        --------------------------------------------------------------------

        if hechizo == "lumos" then

            -- Evitamos tener varias luces del mismo jugador
            if IsValid(ply.LumosLight) then
                ply.LumosLight:Remove()
            end

            local light = ents.Create("light_dynamic")

            if not IsValid(light) then
                return
            end

            light:SetPos(
                ply:GetPos()
                + Vector(0, 0, 55)
                + ply:GetForward() * 20
            )

            light:SetKeyValue("brightness", "5")
            light:SetKeyValue("distance", "350")
            light:SetKeyValue("style", "0")
            light:SetKeyValue("color", "255 255 220")

            light:Spawn()
            light:Activate()
            light:Fire("TurnOn")

            ply.LumosLight = light

            -- Hacemos que la luz siga al jugador
            light:FollowBone(ply, 0)

            timer.Simple(10, function()

                if IsValid(light) then
                    light:Remove()
                end

                if IsValid(ply) then
                    ply.LumosLight = nil
                end

            end)

        --------------------------------------------------------------------
        -- LEVIOSA
        --------------------------------------------------------------------

        elseif hechizo == "leviosa" then

            local tr = ply:GetEyeTrace()
            local target = tr.Entity

            if not IsValid(target) then
                return
            end

            -- Jugadores / NPCs / entidades físicas
            if target:IsPlayer() or target:IsNPC() then

                target:SetVelocity(Vector(0, 0, 300))

            elseif target:GetPhysicsObject():IsValid() then

                local phys = target:GetPhysicsObject()

                phys:SetVelocity(Vector(0, 0, 300))

            end

        --------------------------------------------------------------------
        -- PROTEGO
        --------------------------------------------------------------------

        elseif hechizo == "protego" then

            if ply:GetNWBool("protego", false) then
                return
            end

            ply:SetNWBool("protego", true)

            -- Efecto visual
            local effect = EffectData()
            effect:SetOrigin(ply:GetPos() + Vector(0, 0, 40))
            effect:SetNormal(ply:GetForward())

            util.Effect("cball_explode", effect)

            timer.Simple(5, function()

                if IsValid(ply) then
                    ply:SetNWBool("protego", false)
                end

            end)

        --------------------------------------------------------------------
        -- BOMBARDA
        --------------------------------------------------------------------

        elseif hechizo == "bombarda" then

            local tr = ply:GetEyeTrace()
            local pos = tr.HitPos

            ---------------------------------------------------------------
            -- EFECTO DE EXPLOSIÓN
            ---------------------------------------------------------------

            local effect = EffectData()
            effect:SetOrigin(pos)
            effect:SetScale(1.5)
            effect:SetMagnitude(2)
            effect:SetRadius(150)

            util.Effect("Explosion", effect)

            ---------------------------------------------------------------
            -- DAÑO
            ---------------------------------------------------------------

            local radius = 150
            local damage = 35

            for _, ent in ipairs(ents.FindInSphere(pos, radius)) do

                if IsValid(ent) and ent ~= ply then

                    -- Jugadores
                    if ent:IsPlayer() then

                        local dmg = DamageInfo()

                        dmg:SetAttacker(ply)
                        dmg:SetInflictor(ply)
                        dmg:SetDamage(damage)
                        dmg:SetDamageType(DMG_BLAST)
                        dmg:SetDamagePosition(pos)

                        ent:TakeDamageInfo(dmg)

                    -- NPCs
                    elseif ent:IsNPC() then

                        local dmg = DamageInfo()

                        dmg:SetAttacker(ply)
                        dmg:SetInflictor(ply)
                        dmg:SetDamage(damage)
                        dmg:SetDamageType(DMG_BLAST)
                        dmg:SetDamagePosition(pos)

                        ent:TakeDamageInfo(dmg)

                    end
                end
            end
        end
    end)
end


--------------------------------------------------------------------------------
-- CLIENTE
--------------------------------------------------------------------------------

if CLIENT then

    ------------------------------------------------------------------------
    -- ABRIR MENÚ
    ------------------------------------------------------------------------

    net.Receive("AbrirMenuHechizos", function()

        -- Si ya existe un menú, no crear otro
        if IsValid(HechizosMenu) then
            HechizosMenu:Remove()
        end

        HechizosMenu = vgui.Create("DFrame")

        HechizosMenu:SetSize(350, 350)
        HechizosMenu:Center()
        HechizosMenu:SetTitle("Libro de Hechizos")
        HechizosMenu:MakePopup()

        local hechizos = {
            {
                nombre = "Lumos",
                id = "lumos"
            },

            {
                nombre = "Wingardium Leviosa",
                id = "leviosa"
            },

            {
                nombre = "Protego",
                id = "protego"
            },

            {
                nombre = "Bombarda",
                id = "bombarda"
            }
        }

        for _, hechizo in ipairs(hechizos) do

            local btn = vgui.Create("DButton", HechizosMenu)

            btn:Dock(TOP)
            btn:DockMargin(10, 10, 10, 0)
            btn:SetTall(55)
            btn:SetText(hechizo.nombre)

            btn.DoClick = function()

                net.Start("EjecutarHechizo")
                net.WriteString(hechizo.id)
                net.SendToServer()

                HechizosMenu:Close()

            end
        end
    end)
end