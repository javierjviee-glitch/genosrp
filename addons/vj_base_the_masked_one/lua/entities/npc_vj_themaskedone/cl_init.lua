-- entities/cl_init.lua
---@diagnostic disable: undefined-global

include("shared.lua")

local dofActive = false

hook.Add("RenderScreenspaceEffects", "TMO_FogEffect", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local fogActive   = ply:GetNWBool("TMO_Fog", false)
    local isNightmare = ply:GetNWBool("TMO_Nightmare", false)
    local brightness  = ply:GetNWFloat("TMO_Brightness", 1.0)

    -- Efectos sutiles permanentes en fase 4 (sin jumpscare)
    if isNightmare and not fogActive then
        DrawSharpen(0.1, 0.2)
        DrawMotionBlur(0.01, 0.2, 0.01)
    end

    if fogActive then
        local alpha = ply:GetNWFloat("TMO_FogAlpha", 1.0)

        if alpha < 0.05 then
            if dofActive then
                RunConsoleCommand("pp_bokeh", "0")
                dofActive = false
            end
            if isNightmare then
                DrawSharpen(0.1, 0.2)
                DrawMotionBlur(0.01, 0.2, 0.01)
            end
        else
            -- VALORES AGRESIVOS: sharpen y blur fuertes al inicio, bajan con alpha
            DrawSharpen(0.9 * alpha, 1.0 * alpha)        -- más nitidez distorsionada
            DrawMotionBlur(0.12 * alpha, 1.0 * alpha, 0.01) -- motion blur más pronunciado

            -- Overlay negro semitransparente que se desvanece con el alpha
            -- Da sensación de "ceguera" real sin tapar todo
            surface.SetDrawColor(0, 0, 0, math.floor(alpha * 180))
            surface.DrawRect(0, 0, ScrW(), ScrH())
        end
    else
        if dofActive then
            RunConsoleCommand("pp_bokeh", "0")
            dofActive = false
        end
    end

    -- Oscuridad de fase 4
    if brightness < 1.0 then
        local darkness = math.Round((1.0 - brightness) * 200)
        surface.SetDrawColor(0, 0, 0, darkness)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end
end)

hook.Add("PlayerFullyLoaded", "TMO_SetProxies", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    ply:SetNWVarProxy("TMO_Fog", function(_, _, _, newVal)
        if newVal then
            -- Bokeh más agresivo al activarse
            RunConsoleCommand("pp_bokeh", "1")
            RunConsoleCommand("pp_bokeh_blur",  "14")  -- más desenfoque
            RunConsoleCommand("pp_bokeh_size",  "10")  -- área más grande
            RunConsoleCommand("pp_bokeh_focus", "0.1") -- foco más cerrado = más área borrosa
            dofActive = true
        elseif dofActive then
            RunConsoleCommand("pp_bokeh", "0")
            dofActive = false
        end
    end)

    ply:SetNWVarProxy("TMO_FogAlpha", function(_, _, _, newVal)
        if dofActive then
            -- Blur del bokeh se reduce con el alpha (de 14 a 0)
            local blurVal = math.floor(newVal * 14)
            RunConsoleCommand("pp_bokeh_blur", tostring(blurVal))
        end
    end)
end)