local darknessIntensity = 0
local targetDarkness = 0

net.Receive("vj_ism_shade_darkness_fx", function()
    targetDarkness = net.ReadFloat()
end)

hook.Add("RenderScreenspaceEffects", "vj_ism_shade_darkness", function()
    darknessIntensity = Lerp(FrameTime() * 4, darknessIntensity, targetDarkness)

    if darknessIntensity > 0.01 then
        DrawColorModify({
            ["$pp_colour_brightness"] = -0.7 * darknessIntensity,
            ["$pp_colour_contrast"] = 1 - (0.25 * darknessIntensity),
            ["$pp_colour_colour"] = 1 - (1.2 * darknessIntensity),
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0
        })

        DrawMotionBlur(0.15 * darknessIntensity, 0.8 * darknessIntensity, 0.01)
    else
        DrawMotionBlur(0, 0, 0)
    end
end)
