-- autorun/themaskedone_menu.lua
---@diagnostic disable: undefined-global
if CLIENT then

    -- =========================
    -- REGISTRO NPC
    -- =========================
    list.Set("NPC", "npc_vj_themaskedone", {
        Name      = "The Masked One",
        Class     = "npc_vj_themaskedone",
        Category  = "Paranormal",
        AdminOnly = false
    })

    local function RegisterTMOInVJMenu()
        if not VJ or not VJ.AddNPC or TMO_VJNPCRegistered then return end
        VJ.AddNPC("The Masked One", "npc_vj_themaskedone", "The Masked One")
        TMO_VJNPCRegistered = true
    end

    hook.Add("InitPostEntity", "TMO_RegisterVJNPC", RegisterTMOInVJMenu)
    hook.Add("VJBase_PostInit", "TMO_RegisterVJNPC", RegisterTMOInVJMenu)
    timer.Simple(1, RegisterTMOInVJMenu)

    -- =========================
    -- MENU
    -- =========================
    hook.Add("PopulateToolMenu", "TheMaskedOneMenu", function()

        spawnmenu.AddToolMenuOption("Options", "The Masked One", "TMO_Settings", "The Masked One", "", "",
        function(panel)

            panel:ClearControls()

            -- =========================
            -- FUNCION TRADUCCION DINAMICA
            -- =========================
            local function T(en, es)
                return GetConVar("tmo_language"):GetInt() == 1 and en or es
            end

            -- =========================
            -- LANGUAGE / IDIOMA
            -- =========================
            local langCombo = panel:ComboBox("Language / Idioma", "tmo_language")
            langCombo:AddChoice("Español", 0)
            langCombo:AddChoice("English", 1)

            panel:ControlHelp("Change language / Cambiar idioma")

            -- =========================
            -- MODO
            -- =========================
            panel:Help(T("— Mode —", "— Modo —"))

            local combo = panel:ComboBox(T("Behavior Mode", "Modo de comportamiento"), "tmo_mode")
            combo:AddChoice(T("Progressive (automatic)",         "Progresivo (automático)"),      0)
            combo:AddChoice(T("Phase 0 — Total Calm",            "Fase 0 — Calma total"),          1)
            combo:AddChoice(T("Phase 1 — Sounds only",           "Fase 1 — Solo sonidos"),         2)
            combo:AddChoice(T("Phase 2 — Poltergeist",           "Fase 2 — Poltergeist"),          3)
            combo:AddChoice(T("Phase 3 — Apparitions",           "Fase 3 — Apariciones"),          4)
            combo:AddChoice(T("Phase 4 — Nightmare (30s)",       "Fase 4 — Pesadilla (30s)"),      5)
            combo:AddChoice(T("Phase 5 — Absolute Terror",       "Fase 5 — Terror absoluto"),      6)
            -- combo:AddChoice(T("Test Mode",                       "Modo Test"),                     7)

            panel:ControlHelp(T(
                "In progressive mode, the entity becomes more active over time.\nPhase 5 requires a map with NavMesh generated.",
                "En modo progresivo el fantasma escala su actividad con el tiempo.\nLa Fase 5 requiere un mapa con NavMesh generado."
            ))

            -- =========================
            -- DURACION FASES
            -- =========================
            panel:Help(T("— Phase Duration —", "— Duración de fases —"))
            panel:ControlHelp(T(
                "Each slider defines how long each phase lasts (60 = 1 minute).",
                "Cada slider controla cuánto dura cada fase (60 = 1 minuto)."
            ))

            panel:NumSlider(T("Phase 0 — Calm (sec)",        "Fase 0 — Calma (seg)"),        "tmo_phase0_duration", 10, 300, 0)
            panel:NumSlider(T("Phase 1 — Sounds (sec)",      "Fase 1 — Sonidos (seg)"),      "tmo_phase1_duration", 10, 300, 0)
            panel:NumSlider(T("Phase 2 — Poltergeist (sec)", "Fase 2 — Poltergeist (seg)"),  "tmo_phase2_duration", 10, 300, 0)
            panel:NumSlider(T("Phase 3 — Apparitions (sec)", "Fase 3 — Apariciones (seg)"),  "tmo_phase3_duration", 10, 300, 0)

            panel:ControlHelp(T(
                "Phase 4 (Nightmare) lasts exactly 30 seconds and then transitions to Phase 5 if NavMesh is available.",
                "La Fase 4 (Pesadilla) dura exactamente 30 segundos y luego pasa a la Fase 5 si hay NavMesh disponible."
            ))

            -- =========================
            -- POLTERGEIST
            -- =========================
            panel:Help(T("— Poltergeist —", "— Poltergeist —"))

            panel:NumSlider(T("Object radius", "Radio de objetos"), "tmo_poltergeist_radius", 50, 800, 0)
            panel:NumSlider(T("Lift height",   "Altura de levitar"), "tmo_poltergeist_height", 10, 150, 0)

            -- =========================
            -- EXTRA
            -- =========================
            panel:Help(T("— Extra —", "— Extra —"))

            panel:CheckBox(
                T("Kill player on jumpscare", "Matar al jugador en jumpscare"),
                "tmo_allow_kill"
            )

            -- =========================
            -- RESET
            -- =========================
            panel:Help(T("— Reset —", "— Reset —"))

            panel:ControlHelp(T(
                "Restore all default values.",
                "Restaura todos los valores a los predeterminados."
            ))

            local resetBtn = panel:Button(T("Reset to defaults", "Restaurar valores por defecto"))

            resetBtn.DoClick = function()
                local defaults = {
                    tmo_mode = "0",
                    tmo_phase0_duration = "120",
                    tmo_phase1_duration = "180",
                    tmo_phase2_duration = "180",
                    tmo_phase3_duration = "240",
                    tmo_aggressiveness = "3",
                    tmo_look_delay = "0.05",
                    tmo_poltergeist_radius = "300",
                    tmo_poltergeist_height = "40",
                    tmo_allow_kill = "0",
                    tmo_language = "0"
                }
                for cvar, value in pairs(defaults) do
                    RunConsoleCommand(cvar, value)
                end
            end

        end)

    end)

end
