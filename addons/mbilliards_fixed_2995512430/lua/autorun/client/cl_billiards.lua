----------------------------------------------------------
-- MBilliards by Athos Arantes Pereira
-- Contact: athosarantes@hotmail.com
------------------------------------------------------------
physenv.AddSurfaceData([["billiard_ball"
{
	"scraperough"	"DoorSound.Null"
	"scrapesmooth"	"DoorSound.Null"
	"impacthard"	"DoorSound.Null"
	"impactsoft"	"DoorSound.Null"

	"audioreflectivity"		"0.66"
	"audiohardnessfactor"	"0.0"
	"audioroughnessfactor"	"0.0"

	"elasticity"	"1000"
	"friction"		"0.4"
	"density"		"10000"
}

"billiard_table"
{
	"scraperough"	"DoorSound.Null"
	"scrapesmooth"	"DoorSound.Null"
	"impacthard"	"DoorSound.Null"
	"impactsoft"	"DoorSound.Null"

	"audioreflectivity"		"0.66"
	"audiohardnessfactor"	"0.0"
	"audioroughnessfactor"	"0.0"

	"scrapeRoughThreshold"	"1.0"
	"impactHardThreshold"	"1.0"
	"friction"		"0.4"
}]])
language.Add("billiard_table", "Billiard Table")
language.Add("billiard_cue", "Billiard Cue")
language.Add("billiard_ball", " Billiard Ball")
b_MouseSensitivity = CreateClientConVar("billiard_cl_mouse_sensitivity", "2", true, true)
b_InvCueMouseX = CreateClientConVar("billiard_cl_cue_invmouse_h", "0", true, true)
b_InvCueMouseY = CreateClientConVar("billiard_cl_cue_invmouse_v", "0", true, true)
b_InvMouseX = CreateClientConVar("billiard_cl_invmouse_h", "0", true, false)
b_InvMouseY = CreateClientConVar("billiard_cl_invmouse_v", "0", true, false)
BILLIARD_GAMETYPE_8BALL = 0
BILLIARD_GAMETYPE_9BALL = 1
BILLIARD_GAMETYPE_SNOOKER = 2
BILLIARD_GAMETYPE_ROTATION = 3
BILLIARD_GAMETYPE_CARAMBOL = 4
RequestedPlayers = {}
PocketedBalls_tmp = {}
PocketedBalls = {}
b_GameType = 0
b_SpecEnt = nil
b_SpecBaseEnt = nil
b_BilliardTime = nil
b_LastAngles = nil
b_FPerson = false
b_ThirdPersonLocked = false
b_ThirdPersonBodyAngles = nil
b_ThirdPersonPreviousRenderAngles = nil
b_BilliardPlaying = false
b_BilliardThirdPersonState = nil
b_RunTime = true
b_CScore = nil
b_OScore = nil
b_ShotForce = 150
b_Zoom = 30
constObjective = ""
opponentName = nil
b_FoulReason = nil
b_Objective = ""
b_scrTitle = nil
b_scrText = nil
b_BarInfo = nil
b_strike_pressed = false
b_requests_panel = nil
b_client_panel = nil
billiard_mainGUI_tex = surface.GetTextureID("vgui/panel/billiard_gui")
billiard_mainSGUI_tex = surface.GetTextureID("vgui/panel/billiard_sgui")
billiard_mainCRGUI_tex = surface.GetTextureID("vgui/panel/billiard_crgui")
billiard_subGUI_tex = surface.GetTextureID("vgui/panel/billiard_subgui")
billiard_needle_tex = surface.GetTextureID("vgui/panel/needle")
billiard_meter_tex = surface.GetTextureID("vgui/panel/meter")
billiard_ball_tex = {}

for i = 1, 15 do
  billiard_ball_tex[i] = surface.GetTextureID(string.format("vgui/panel/ball%02d", i))
end

surface.CreateFont("HudCText", {
  font = "default",
  size = 35,
  weight = 700,
  antialias = true
})

surface.CreateFont("HudCSubText", {
  font = "default",
  size = 18,
  weight = 700,
  antialias = true
})

surface.CreateFont("HUDPoolText", {
  font = "default",
  size = 16,
  weight = 700,
  antialias = true
})

surface.CreateFont("BilliardMenuBody", {
  font = "default",
  size = 20,
  weight = 700,
  antialias = true
})

surface.CreateFont("BilliardMenuButton", {
  font = "default",
  size = 18,
  weight = 700,
  antialias = true
})

concommand.Add("incbzoom", function(ply, cmd, args)
  if b_FPerson then
    b_Zoom = math.Clamp(b_Zoom + 1, 15, 40)
  else
    b_ShotForce = math.Clamp(b_ShotForce + 5, 1, 400)
  end
end)

concommand.Add("decbzoom", function(ply, cmd, args)
  if b_FPerson then
    b_Zoom = math.Clamp(b_Zoom - 1, 15, 40)
  else
    b_ShotForce = math.Clamp(b_ShotForce - 5, 1, 400)
  end
end)

hook.Add("PlayerButtonDown", "CBilliardStrike", function(player, button)
  if player ~= LocalPlayer() or button ~= MOUSE_LEFT then return end
  if b_FPerson or player:KeyDown(IN_SPEED) then return end

  RunConsoleCommand("billiard_strike", b_ShotForce)
end)

hook.Add("PlayerBindPress", "CBilliardBlockThirdPerson", function(player, bind)
  if player ~= LocalPlayer() or not b_BilliardPlaying then return end

  bind = string.lower(bind or "")
  if string.find(bind, "thirdperson", 1, true) then return true end
end)

-- Input.IsMouseDown with mouse wheel don't work...
--[[
	if(input.IsMouseDown(MOUSE_WHEEL_DOWN)) then
		b_Zoom = math.Clamp(b_Zoom + 1, 15, 40)
	end
	if(input.IsMouseDown(MOUSE_WHEEL_UP)) then
		b_Zoom = math.Clamp(b_Zoom - 1, 15, 40)
	end]]
--
function hook.Exist(name)
  for i, t in pairs(hook.GetTable()) do
    for k, v in pairs(t) do
      if type(k) == "string" and type(name) == "string" and (string.lower(k) == string.lower(name)) then return true end
    end
  end

  return false
end

function hook.RemoveAll(name)
  local count = 0

  for i, t in pairs(hook.GetTable()) do
    for k, v in pairs(t) do
      if k == name then
        hook.Remove(i, k)
        count = count + 1
      end
    end
  end

  return count
end

-- I didn't want to use textures to do this effect, so I made this nice gradient function =P
-- Thanks to all people at FacePunch forums that helped me to optimize it!
local g_grds, g_wgrd, g_sz

function draw.GradientBox(x, y, w, h, al, ...)
  g_grds = {...}

  al = math.Clamp(math.floor(al), 0, 1)
  local n

  if al == 1 then
    n = w
    w, h = h, n
  end

  g_wgrd = w / (#g_grds - 1)

  for i = 1, w do
    for c = 1, #g_grds do
      n = c
      if i <= g_wgrd * c then break end
    end

    g_sz = i - (g_wgrd * (n - 1))
    surface.SetDrawColor(Lerp(g_sz / g_wgrd, g_grds[n].r, g_grds[n + 1].r), Lerp(g_sz / g_wgrd, g_grds[n].g, g_grds[n + 1].g), Lerp(g_sz / g_wgrd, g_grds[n].b, g_grds[n + 1].b), Lerp(g_sz / g_wgrd, g_grds[n].a, g_grds[n + 1].a))

    if al == 1 then
      surface.DrawRect(x, y + i, h, 1)
    else
      surface.DrawRect(x + i, y, 1, h)
    end
  end
end

function GetTimeLeft()
  if not b_RunTime then return "--:--" end
  local sec = b_BilliardTime - CurTime()
  if not sec or sec <= 0 then return "00:00" end

  return string.format("%02d:%02d", math.floor(sec / 60), math.fmod(sec, 60))
end

function BilliardSpectate(ply, pos, angles, fov)
  local m_ent = ents.GetByIndex(b_SpecEnt)
  local base = ents.GetByIndex(b_SpecBaseEnt)

  if IsValid(m_ent) then
    local view = {}
    local dist = 30 + b_Zoom

    if m_ent:GetClass() == "billiard_cue" and IsValid(base) then
      local fwrd = m_ent:GetForward() * -1
      view.origin = base:GetPos() + Vector(0, 0, 5) + (fwrd * dist * -1)
      view.angles = fwrd:Angle() + Angle(0, -0.07, 0) -- We need an angle offset
    else
      local fwrd = LocalPlayer():GetAimVector()
      view.origin = m_ent:GetPos() + (fwrd * dist * -1)
      view.angles = angles
    end

    view.fov = 30

    return view
  end
end

------------------------------------------------------------
-- FIRST PERSON / THIRD PERSON DE ACUERDO AL TURNO
--
-- FIX: antes se comparaba un NWInt (numero) con ply:UniqueID() (string),
-- por lo que "isPlayerTurn" nunca daba true. Ahora se usa EntIndex(),
-- que es un numero, igual que el NWInt que manda el servidor.
--
-- FIX: se elimino el uso de GetConVar("thirdperson"), porque
-- "thirdperson" es un concommand, no una convar, y eso provocaba
-- el error "Tried to look up command thirdperson as if it were a
-- variable" repetido cada frame. Ahora solo se controla la vista
-- devolviendo (o no) la tabla de CalcView.
------------------------------------------------------------
function BilliardFirstPersonView(ply, pos, angles, fov)
  if hook.Exist("CBilliardSpectate") then return end
  if not IsValid(ply) then return end

  local tableID = ply.BilliardTableID
  if not tableID then return end

  local billiardTable = Entity(tableID)
  if not IsValid(billiardTable) then return end

  -- IMPORTANTE: el servidor debe mandar SetNWInt("CurrentPlayerID", jugador:EntIndex())
  local currentPlayerID = billiardTable:GetNWInt("CurrentPlayerID", 0)
  local isPlayerTurn = (currentPlayerID == ply:EntIndex())

  if isPlayerTurn then
    -- Es su turno: primera persona
    return {
      origin = ply:EyePos(),
      angles = ply:EyeAngles(),
      fov = fov,
      drawviewer = false
    }
  end

  -- No es su turno: deja la camara por defecto (tercera persona)
  return nil
end

local function BilliardRestoreShotView()
  hook.Remove("CalcView", "CBilliardShotFirstPerson")
  hook.Remove("ShouldDrawLocalPlayer", "CBilliardShotFirstPerson")
end

local function BilliardEnterFirstPerson()
  -- La vista en si la controla BilliardFirstPersonView (CalcView) segun el turno.
  -- No hace falta tocar ninguna convar aqui.
end

local function BilliardLeaveFirstPerson()
  -- Igual que arriba: nada que restaurar, CalcView deja de forzar nada
  -- en cuanto se quita el hook al terminar la partida.
end

local function BilliardForceFirstPerson()
  -- Ya no se fuerza nada por convar; CalcView (BilliardFirstPersonView)
  -- se encarga de la vista cada frame segun el turno.
end

function BilliardShotFirstPersonView(ply, pos, angles, fov)
  if not IsValid(ply) then return end

  return {
    origin = ply:EyePos(),
    angles = ply:EyeAngles(),
    fov = fov,
    drawviewer = false
  }
end

function BilliardInputMouseApply(cmd, x, y, angles)
  if not b_FPerson and LocalPlayer():KeyDown(IN_SPEED) then
    return true
  elseif b_FPerson and LocalPlayer():KeyDown(IN_ATTACK2) then
    return true
  end

  local s = math.Clamp(b_MouseSensitivity:GetFloat(), 0.5, 10) / 100
  x, y = x * -s, y * s

  if b_InvMouseX:GetBool() then
    x = -x
  end

  if b_InvMouseY:GetBool() then
    y = -y
  end

  cmd:SetViewAngles(angles + Angle(y, x, 0))

  return true
end

local b_w, b_h, b_px, b_py, b_obj, b_c, b_nm, b_onm

function BilliardHUDPaint()
  b_nm = 128
  surface.SetDrawColor(255, 255, 255, 255)
  -- The main GUI Image
  surface.SetTexture(billiard_mainGUI_tex)

  if b_GameType == BILLIARD_GAMETYPE_SNOOKER or b_GameType == BILLIARD_GAMETYPE_ROTATION then
    surface.SetTexture(billiard_mainSGUI_tex)
  elseif b_GameType == BILLIARD_GAMETYPE_CARAMBOL then
    surface.SetTexture(billiard_mainCRGUI_tex)
    b_nm = 64
  end

  surface.DrawTexturedRect(ScrW() / 2 - 512, 0, 1024, b_nm)

  -- The pocketed balls
  if b_GameType == BILLIARD_GAMETYPE_8BALL then
    if b_Objective == "OpenTable" and PocketedBalls["OpenBalls"] ~= nil then
      surface.SetTexture(billiard_subGUI_tex)
      surface.DrawTexturedRect(ScrW() / 2 - 256, 74, 512, 64)
      draw.SimpleText("Open Balls", "HUDPoolText", ScrW() / 2 - 86, 92, white, 1, 1)
      b_c = 0

      for k, v in pairs(PocketedBalls["OpenBalls"]) do
        if b_c >= 7 then break end
        b_c = b_c + 1
        surface.SetTexture(billiard_ball_tex[v])
        surface.DrawTexturedRect(ScrW() / 2 - 60 + (22 * k), 75, 32, 32)
      end
    end
  end

  for i, t in pairs(PocketedBalls) do
    if b_GameType == BILLIARD_GAMETYPE_8BALL and b_Objective == "OpenTable" then break end
    if t and type(t) == "table" then
      b_c = 0

      for k, v in pairs(t) do
        if b_c >= 8 then break end
        b_px = ScrW() / 2 + 65 + (22 * k)

        if i == constObjective or i == "me" then
          b_px = ScrW() / 2 - 96 - (22 * k)
        end

        b_c = b_c + 1
        surface.SetTexture(billiard_ball_tex[v])
        surface.DrawTexturedRect(b_px, 2, 32, 32)
      end
    end
  end

  -- The infos, such as timeleft, objective, etc
  b_obj = b_Objective

  if b_GameType == BILLIARD_GAMETYPE_8BALL then
    if b_Objective == "Solids" then
      b_obj = "Lisas"
    elseif b_Objective == "Stripes" then
      b_obj = "Rayadas"
    elseif b_Objective == "OpenTable" then
      b_obj = "Mesa abierta"
    end
  end

  if b_GameType == BILLIARD_GAMETYPE_9BALL or b_GameType == BILLIARD_GAMETYPE_ROTATION then
    local objectiveNumber = tonumber(b_Objective) or 0

    if b_GameType == BILLIARD_GAMETYPE_9BALL and objectiveNumber == 9 then
      b_obj = "9-Ball"
    else
      b_obj = string.format("Ball: %d", objectiveNumber)
    end
  end

  b_px, b_py = ScrW() / 2 - 203, 55
  local onmX, onmY = ScrW() / 2 + 203, 55
  b_nm = LocalPlayer():GetName()
  b_onm = opponentName or "N/A"

  if b_GameType == BILLIARD_GAMETYPE_8BALL then
    if b_Objective == "Solids" then
      b_nm = string.format("%s :: Lisas", b_nm)
    elseif b_Objective == "Stripes" then
      b_nm = string.format("%s :: Rayadas", b_nm)
    end
  end

  if b_GameType == BILLIARD_GAMETYPE_SNOOKER or b_GameType == BILLIARD_GAMETYPE_ROTATION or b_GameType == BILLIARD_GAMETYPE_CARAMBOL then
    b_px, b_py = ScrW() / 2 - 190, 18
    onmX, onmY = ScrW() / 2 + 190, 18

    if b_GameType == BILLIARD_GAMETYPE_CARAMBOL then
      b_px = ScrW() / 2 - 169
      onmX = ScrW() / 2 + 169
    end

    b_nm = string.format("%s :: %d", b_nm, b_CScore or 0)
    b_onm = string.format("%d :: %s", b_OScore or 0, b_onm)
  end

  b_w, b_h = ScrW() / 2, ScrH() / 2
  local tpos = b_w

  if b_GameType ~= BILLIARD_GAMETYPE_CARAMBOL then
    tpos = b_w + 42
    draw.SimpleText(b_obj or "", "HUDPoolText", b_w - 42, 18, white, 1, 1)
  end

  draw.SimpleText(GetTimeLeft(), "HUDPoolText", tpos, 18, white, 1, 1)
  draw.SimpleText(b_BarInfo or "", "HUDPoolText", b_w, 55, white, 1, 1)
  draw.SimpleText(b_nm, "HUDPoolText", b_px, b_py, white, 1, 1)
  draw.SimpleText(b_onm, "HUDPoolText", onmX, onmY, white, 1, 1)

  if b_FoulReason ~= nil then
    b_py = 75

    if b_Objective == "OpenTable" and PocketedBalls["OpenBalls"] ~= nil then
      b_py = 111
    end

    draw.GradientBox(b_w - 160, b_py, 64, 25, 0, Color(0, 0, 0, 0), Color(0, 0, 0, 160))
    draw.GradientBox(b_w + 96, b_py, 64, 25, 0, Color(0, 0, 0, 160), Color(0, 0, 0, 0))
    surface.SetDrawColor(0, 0, 0, 160)
    surface.DrawRect(b_w - 95, b_py, 192, 25)
    draw.SimpleText(b_FoulReason, "HUDPoolText", b_w, b_py + 12, white, 1, 1)
  end

  if not b_FPerson then
    b_c = (150 / 400) * -b_ShotForce
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetTexture(billiard_meter_tex)
    surface.DrawTexturedRect(b_w - 128, ScrH() - 128, 256, 128)
    surface.SetTexture(billiard_needle_tex)
    surface.DrawTexturedRectRotated(b_w, ScrH() - 2, 128, 64, math.Clamp(b_c, -150, 0))
  end
end

function BilliardScrMsg()
  if not b_scrTitle or b_scrTitle == "" then return hook.RemoveAll("CBilliardScrMsg") end
  b_w, b_h = ScrW() / 2, ScrH() / 2
  b_h = b_h + b_h / 2.5
  draw.GradientBox(b_w - 256, b_h, 128, 100, 0, Color(0, 0, 0, 0), Color(0, 0, 0, 160))
  draw.GradientBox(b_w + 128, b_h, 128, 100, 0, Color(0, 0, 0, 160), Color(0, 0, 0, 0))
  surface.SetDrawColor(0, 0, 0, 160)
  surface.DrawRect(b_w - 127, b_h, 256, 100)
  draw.SimpleText(b_scrTitle, "HudCText", b_w, b_h + 20, white, 1, 1)
  draw.DrawText(b_scrText or "", "HudCSubText", b_w, b_h + 50, white, 1)
end

------------------------------------------------------------
-- USERMESSAGES FUNCTIONS
------------------------------------------------------------
usermessage.Hook("billiard_toggleHUD", function(um)
  local c_b = um:ReadBool()
  b_GameType = um:ReadShort()
  b_FPerson = um:ReadBool()
  b_strike_pressed = false
  b_BilliardPlaying = c_b

  local player = LocalPlayer()
  if c_b then
    BilliardEnterFirstPerson()
  else
    BilliardRestoreShotView()
    BilliardLeaveFirstPerson()
  end

  if c_b and not b_FPerson and IsValid(player) then
    b_ThirdPersonLocked = true
    b_ThirdPersonBodyAngles = Angle(0, player:GetAngles().y, 0)
    b_ThirdPersonPreviousRenderAngles = player:GetRenderAngles()
  elseif not c_b then
    b_ThirdPersonLocked = false
    b_ThirdPersonBodyAngles = nil
    if IsValid(player) and b_ThirdPersonPreviousRenderAngles then
      player:SetRenderAngles(b_ThirdPersonPreviousRenderAngles)
    end
    b_ThirdPersonPreviousRenderAngles = nil
  end

  b_BarInfo = nil
  b_FoulReason = nil
  b_CScore = nil
  b_OScore = nil
  PocketedBalls = {}
  PocketedBalls_tmp = {}

  if c_b then
    if not hook.Exist("CBilliardFirstPersonView") then
      hook.Add("CalcView", "CBilliardFirstPersonView", BilliardFirstPersonView)
    end

    if hook.Exist("PoolHUDWinner") then
      hook.RemoveAll("PoolHUDWinner")
    end

    if hook.Exist("CBilliardHUD") then return end
    hook.Add("HUDPaint", "CBilliardHUD", BilliardHUDPaint)

    return
  end

  if hook.Exist("CBilliardHUD") then
    hook.Remove("HUDPaint", "CBilliardHUD")
  end

  hook.Remove("CalcView", "CBilliardFirstPersonView")

  hook.Remove("InputMouseApply", "CBilliardMouseLock")
  BilliardRestoreShotView()
  opponentName = nil
end)

usermessage.Hook("billiard_setObjective", function(um)
  b_Objective = um:ReadString()
  PocketedBalls_tmp["OpenBalls"] = nil
  PocketedBalls["OpenBalls"] = nil

  if b_Objective ~= "8-Ball" and b_Objective ~= "OpenTable" then
    constObjective = b_Objective
  end
end)

usermessage.Hook("billiard_syncTime", function(um)
  b_RunTime = um:ReadBool()
  PocketedBalls = table.Copy(PocketedBalls_tmp)
  if not b_RunTime then return end
  b_BilliardTime = CurTime() + um:ReadShort() - (LocalPlayer():Ping() / 1000)
end)

usermessage.Hook("billiard_scrMsg", function(um)
  local title = um:ReadString()
  local text = um:ReadString()

  if not title then
    b_scrTitle = nil
    b_scrText = nil

    return
  end

  b_scrTitle = title
  b_scrText = text

  if not hook.Exist("CBilliardScrMsg") then
    hook.Add("HUDPaint", "CBilliardScrMsg", BilliardScrMsg)
  end

  timer.Create("billiard_timerMsgDel", 6, 1, function()
    if not hook.Exist("CBilliardScrMsg") then return end
    hook.RemoveAll("CBilliardScrMsg")
  end)
end)

usermessage.Hook("billiard_sendSMsg", function(um)
  local title = um:ReadString()
  local fReason = um:ReadString()

  if not title then
    b_BarInfo = nil
    b_FoulReason = nil

    return
  end

  if fReason == "" then
    fReason = nil
  end

  b_BarInfo = title
  b_FoulReason = fReason
end)

usermessage.Hook("billiard_pocketBall", function(um)
  local nBall = um:ReadShort()
  local uID = um:ReadString()

  if b_GameType == BILLIARD_GAMETYPE_8BALL then
    local bType = nil

    if nBall <= 7 then
      bType = "Solids"
    else
      bType = "Stripes"
    end

    if b_Objective == "OpenTable" then
      if not PocketedBalls_tmp["OpenBalls"] then
        PocketedBalls_tmp["OpenBalls"] = {}
      end

      table.insert(PocketedBalls_tmp["OpenBalls"], nBall)
    end

    if not PocketedBalls_tmp[bType] then
      PocketedBalls_tmp[bType] = {}
    end

    table.insert(PocketedBalls_tmp[bType], nBall)
  elseif b_GameType == BILLIARD_GAMETYPE_9BALL then
    if LocalPlayer():UniqueID() == uID then
      if not PocketedBalls_tmp["me"] then
        PocketedBalls_tmp["me"] = {}
      end

      table.insert(PocketedBalls_tmp["me"], nBall)
    else
      if not PocketedBalls_tmp["opp"] then
        PocketedBalls_tmp["opp"] = {}
      end

      table.insert(PocketedBalls_tmp["opp"], nBall)
    end
  end
end)

usermessage.Hook("billiard_updateScore", function(um)
  b_CScore = um:ReadShort()
  b_OScore = um:ReadShort()
end)

usermessage.Hook("billiard_sendRequest", function(um)
  local plyid = um:ReadString()
  local name = um:ReadString()
  local player = {}
  player.ID = plyid
  player.Name = name --player.GetByUniqueID(plyid):GetName()
  table.insert(RequestedPlayers, player)

  if type(b_requests_panel) == "Panel" then
    b_requests_panel:Remove()
  end

  guiRequestPlayer()
end)

usermessage.Hook("billiard_removeRequest", function(um)
  local plyid = um:ReadString()

  for i = 1, table.Count(RequestedPlayers) do
    if RequestedPlayers[i].ID == plyid then
      RequestedPlayers[i] = nil
    end
  end

  if type(b_requests_panel) == "Panel" then
    b_requests_panel:Remove()

    if table.Count(RequestedPlayers) >= 1 then
      guiRequestPlayer()
    end
  end
end)

usermessage.Hook("billiard_spectate", function(um)
  local c_b = um:ReadBool()
  local c_e = um:ReadShort()
  local c_cb = um:ReadShort() or nil

  if c_b then
    b_SpecEnt = c_e
    b_SpecBaseEnt = c_cb

    if not b_LastAngles and IsValid(LocalPlayer()) then
      b_LastAngles = LocalPlayer():EyeAngles()
    end

    if hook.Exist("CBilliardSpectate") then return end
    hook.Add("CalcView", "CBilliardSpectate", BilliardSpectate)

    return
  end

  if not hook.Exist("CBilliardSpectate") then return end
  hook.Remove("CalcView", "CBilliardSpectate")
  if IsValid(LocalPlayer()) and b_LastAngles then
    LocalPlayer():SetEyeAngles(b_LastAngles)
  end
  b_LastAngles = nil
  b_SpecEnt = nil
  b_SpecBaseEnt = nil
end)

usermessage.Hook("billiard_mouseLock", function(um)
  local c_b = um:ReadBool()

  if c_b then
    if hook.Exist("CBilliardMouseLock") then return end
    hook.Add("InputMouseApply", "CBilliardMouseLock", BilliardInputMouseApply)

    return
  end

  if not hook.Exist("CBilliardMouseLock") then return end
  hook.Remove("InputMouseApply", "CBilliardMouseLock")
end)

usermessage.Hook("billiard_updateInfo", function(um)
  local id = um:ReadString()
  --if(!id || !player.GetByUniqueID(id)) then opponentName = nil return end
  --opponentName = player.GetByUniqueID(id):GetName()
  opponentName = id or nil
end)

usermessage.Hook("billiard_resetInfos", function(um)
  BilliardRestoreShotView()
  PocketedBalls = {}
  PocketedBalls_tmp = {}
  b_CScore = 0
  b_OScore = 0
end)

------------------------------------------------------------
--	BILLIARD TABLE CLIENT CONFIGURATION GUI
------------------------------------------------------------
local billiardColors = {
  background = Color(18, 24, 23, 250),
  surface = Color(27, 38, 35, 255),
  surfaceLight = Color(39, 55, 49, 255),
  green = Color(34, 112, 78, 255),
  greenHover = Color(45, 143, 96, 255),
  gold = Color(224, 176, 76, 255),
  text = Color(235, 239, 228, 255),
  muted = Color(167, 187, 174, 255),
  danger = Color(157, 61, 53, 255),
  dangerHover = Color(190, 73, 62, 255)
}

local function StyleBilliardFrame(frame, title, subtitle)
  frame:SetTitle("")
  frame:SetDraggable(false)
  frame:ShowCloseButton(false)
  frame.Paint = function(panel, width, height)
    draw.RoundedBox(8, 0, 0, width, height, billiardColors.background)
    draw.RoundedBoxEx(8, 0, 0, width, 38, billiardColors.green, true, true, false, false)
    surface.SetDrawColor(billiardColors.gold)
    surface.DrawRect(0, 36, width, 2)
    draw.SimpleText(title, "DermaLarge", 20, 12, billiardColors.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    if subtitle then
      draw.SimpleText(subtitle, "DefaultSmall", width - 18, 14, billiardColors.muted, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
  end
  frame:MakePopup()
end

local function StyleBilliardPanel(panel)
  panel:SetBackgroundColor(billiardColors.surface)
  panel.Paint = function(self, width, height)
    draw.RoundedBox(5, 0, 0, width, height, billiardColors.surface)
  end
end

local function StyleBilliardButton(button, isDanger)
  button:SetTextColor(billiardColors.text)
  button:SetFont("BilliardMenuButton")
  button:SetContentAlignment(5)
  button.Paint = function(self, width, height)
    local color = isDanger and billiardColors.danger or billiardColors.green
    if self:IsHovered() then
      color = isDanger and billiardColors.dangerHover or billiardColors.greenHover
    end
    draw.RoundedBox(5, 0, 0, width, height, color)
  end
end

function guiBilliardClientConfig()
  if type(b_client_panel) == "Panel" then
    b_client_panel:Remove()
  end

  b_client_panel = vgui.Create("DFrame")
  b_client_panel:SetSize(200, 265)
  b_client_panel:Center()
  b_client_panel:SetVisible(true)
  StyleBilliardFrame(b_client_panel, "MBilliards", "CONTROLES")
  ------------------------------------------------------------
  local MSPanel = vgui.Create("DPanel", b_client_panel)
  MSPanel:SetPos(10, 27)
  MSPanel:SetSize(180, 50)
  StyleBilliardPanel(MSPanel)
  local cfSen = math.Clamp(b_MouseSensitivity:GetFloat(), 0.5, 10)
  local mSen = vgui.Create("DNumSlider", MSPanel)
  mSen:SetText("Sensibilidad del raton")
  mSen:SetPos(5, 5)
  mSen:SetWide(170)
  mSen:SetMin(0.5)
  mSen:SetMax(10)
  mSen:SetDecimals(1)
  mSen:SetValue(math.Clamp(b_MouseSensitivity:GetFloat(), 0.5, 10))

  mSen.ValueChanged = function(panel, val)
    cfSen = val
  end

  ------------------------------------------------------------
  local CIHPanel = vgui.Create("DPanel", b_client_panel)
  CIHPanel:SetPos(10, 85)
  CIHPanel:SetSize(180, 25)
  local cfCIH = b_InvCueMouseX:GetInt()
  local mCInvH = vgui.Create("DCheckBoxLabel", CIHPanel)
  mCInvH:SetText("Invertir raton del taco horizontal")
  mCInvH:SetPos(5, 5)
  mCInvH:SetValue(cfCIH)
  mCInvH:SizeToContents()

  mCInvH.OnChange = function()
    if mCInvH:GetChecked() then
      cfCIH = 1
    else
      cfCIH = 0
    end
  end

  ------------------------------------------------------------
  local CIVPanel = vgui.Create("DPanel", b_client_panel)
  CIVPanel:SetPos(10, 115)
  CIVPanel:SetSize(180, 25)
  local cfCIV = b_InvCueMouseY:GetInt()
  local mCInvV = vgui.Create("DCheckBoxLabel", CIVPanel)
  mCInvV:SetText("Invertir raton del taco vertical")
  mCInvV:SetPos(5, 5)
  mCInvV:SetValue(cfCIV)
  mCInvV:SizeToContents()

  mCInvV.OnChange = function()
    if mCInvV:GetChecked() then
      cfCIV = 1
    else
      cfCIV = 0
    end
  end

  ------------------------------------------------------------
  local IHPanel = vgui.Create("DPanel", b_client_panel)
  IHPanel:SetPos(10, 145)
  IHPanel:SetSize(180, 25)
  local cfIH = b_InvMouseX:GetInt()
  local mInvH = vgui.Create("DCheckBoxLabel", IHPanel)
  mInvH:SetText("Invertir raton horizontal")
  mInvH:SetPos(5, 5)
  mInvH:SetValue(cfIH)
  mInvH:SizeToContents()

  mInvH.OnChange = function()
    if mInvH:GetChecked() then
      cfIH = 1
    else
      cfIH = 0
    end
  end

  ------------------------------------------------------------
  local IVPanel = vgui.Create("DPanel", b_client_panel)
  IVPanel:SetPos(10, 175)
  IVPanel:SetSize(180, 25)
  local cfIV = b_InvMouseY:GetInt()
  local mInvV = vgui.Create("DCheckBoxLabel", IVPanel)
  mInvV:SetText("Invertir raton vertical")
  mInvV:SetPos(5, 5)
  mInvV:SetValue(cfIV)
  mInvV:SizeToContents()

  mInvV.OnChange = function()
    if mInvV:GetChecked() then
      cfIV = 1
    else
      cfIV = 0
    end
  end

  ------------------------------------------------------------
  local OKBtn = vgui.Create("DButton", b_client_panel)
  OKBtn:SetPos(10, 205)
  OKBtn:SetSize(180, 25)
  OKBtn:SetText("Guardar ajustes")
  StyleBilliardButton(OKBtn)

  OKBtn.DoClick = function()
    RunConsoleCommand("billiard_cl_mouse_sensitivity", tostring(cfSen))
    RunConsoleCommand("billiard_cl_cue_invmouse_h", tostring(cfCIH))
    RunConsoleCommand("billiard_cl_cue_invmouse_v", tostring(cfCIV))
    RunConsoleCommand("billiard_cl_invmouse_h", tostring(cfIH))
    RunConsoleCommand("billiard_cl_invmouse_v", tostring(cfIV))
    b_client_panel:Remove()
  end

  ------------------------------------------------------------
  local CancelBtn = vgui.Create("DButton", b_client_panel)
  CancelBtn:SetPos(10, 235)
  CancelBtn:SetSize(180, 25)
  CancelBtn:SetText("Cancelar")
  StyleBilliardButton(CancelBtn, true)

  CancelBtn.DoClick = function()
    b_client_panel:Remove()
  end
end

------------------------------------------------------------
--	BILLIARD TABLE CONFIGURATION GUI
------------------------------------------------------------
usermessage.Hook("billiard_setConfig", function(um)
  local bid = um:ReadShort()
  local gmtype = um:ReadShort()
  local rdtime = um:ReadShort()
  local abmet = um:ReadShort()
  local skin = um:ReadShort()
  local fpcue = um:ReadBool()
  local trn = um:ReadBool()
  local sc = um:ReadBool()
  local mgp = um:ReadBool()
  local MainFrame = vgui.Create("DFrame")
  MainFrame:SetSize(424, 212)
  MainFrame:Center()
  MainFrame:SetVisible(true)
  StyleBilliardFrame(MainFrame, "CONFIGURAR MESA", "EDITAR MESA")
  local BPanel = vgui.Create("DPanel", MainFrame)
  BPanel:SetPos(148, 30)
  BPanel:SetSize(266, 62)
  StyleBilliardPanel(BPanel)
  local BPanelTitle = vgui.Create("DLabel", BPanel)
  BPanelTitle:SetPos(10, 5)
  BPanelTitle:SetText("Opciones avanzadas")
  BPanelTitle:SetDark(true)
  --BPanelTitle:SetFont("TabLarge")
  BPanelTitle:SizeToContents()
  local abkMethod = 0
  local abkMultiChoice = vgui.Create("DComboBox", BPanel)
  abkMultiChoice:SetPos(140, 33)
  abkMultiChoice:SetSize(116, 20)
  abkMultiChoice:AddChoice("Metodo 1")
  abkMultiChoice:AddChoice("Metodo 2")

  abkMultiChoice.OnSelect = function(panel, id, text)
    abkMethod = id
  end

  if abmet ~= 0 then
    abkMultiChoice:ChooseOptionID(abmet)
  end

  local AbModeBox = vgui.Create("DCheckBoxLabel", BPanel)
  AbModeBox:SetPos(10, 35)
  AbModeBox:SetText("Proteccion de bolas fuera")
  AbModeBox:SetTextColor(billiardColors.text)

  if abmet == 0 then
    AbModeBox:SetValue(0)
  else
    AbModeBox:SetValue(1)
  end

  AbModeBox:SizeToContents()

  AbModeBox.OnChange = function()
    if AbModeBox:GetChecked() then
      abkMethod = 1
      abkMultiChoice:SetVisible(true)
      abkMultiChoice:ChooseOptionID(1)
    else
      abkMethod = 0
      abkMultiChoice:SetVisible(false)
    end
  end

  -----------------------------------------------------
  -- SKIN BUTTON
  -----------------------------------------------------
  if skin > 2 then
    skin = skin - 3
  end

  local ImageSkin = vgui.Create("DImageButton", MainFrame)
  ImageSkin:SetPos(10, 30)
  ImageSkin:SetSize(128, 64)
  ImageSkin:SetMaterial("VGUI/panel/skin" .. skin)

  ImageSkin.DoClick = function()
    if skin >= 2 then
      skin = 0
    else
      skin = skin + 1
    end

    ImageSkin:SetMaterial(string.format("VGUI/panel/skin%d", skin))
  end

  ImageSkin.DoRightClick = function()
    if skin <= 0 then
      skin = 2
    else
      skin = skin - 1
    end

    ImageSkin:SetMaterial(string.format("VGUI/panel/skin%d", skin))
  end

  -----------------------------------------------------
  -- GAME TYPE SELECTION BOX
  -----------------------------------------------------
  local gTPanel = vgui.Create("DPanel", MainFrame)
  gTPanel:SetPos(10, 100)
  gTPanel:SetSize(267, 24)
  StyleBilliardPanel(gTPanel)
  local gTLabel = vgui.Create("DLabel", gTPanel)
  gTLabel:SetPos(5, 4)
  gTLabel:SetText("Tipo de partida")
  gTLabel:SetTextColor(billiardColors.text)
  --gTLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
  --gTLabel:SetFont("DefaultBold")
  gTLabel:SizeToContents()
  local gtype = 0
  local gTMultiChoice = vgui.Create("DComboBox", gTPanel)
  gTMultiChoice:SetPos(140, 2)
  gTMultiChoice:SetSize(120, 20)
  gTMultiChoice:AddChoice("8 bolas")
  gTMultiChoice:AddChoice("9 bolas")
  gTMultiChoice:AddChoice("Snooker")
  gTMultiChoice:AddChoice("Rotacion")
  gTMultiChoice:AddChoice("Carambola")

  gTMultiChoice.OnSelect = function(panel, id, text)
    gtype = id - 1
  end

  gTMultiChoice:ChooseOptionID(gmtype + 1)
  -----------------------------------------------------
  -- ROUND TIME SELECTION BOX
  -----------------------------------------------------
  local bTPanel = vgui.Create("DPanel", MainFrame)
  bTPanel:SetPos(10, 129)
  bTPanel:SetSize(267, 24)
  StyleBilliardPanel(bTPanel)
  local bTLabel = vgui.Create("DLabel", bTPanel)
  bTLabel:SetPos(5, 4)
  bTLabel:SetText("Tiempo de ronda")
  bTLabel:SetTextColor(billiardColors.text)
  --bTLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
  --bTLabel:SetFont("DefaultBold")
  bTLabel:SizeToContents()
  local rTime = 0
  local bTMultiChoice = vgui.Create("DComboBox", bTPanel)
  bTMultiChoice:SetPos(140, 2)
  bTMultiChoice:SetSize(120, 20)
  bTMultiChoice:AddChoice("15 segundos")
  bTMultiChoice:AddChoice("30 segundos")
  bTMultiChoice:AddChoice("45 segundos")
  bTMultiChoice:AddChoice("60 segundos")

  bTMultiChoice.OnSelect = function(panel, id, text)
    rTime = id
  end

  bTMultiChoice:ChooseOptionID(rdtime / 15)
  -----------------------------------------------------
  -- CUE FIRST PERSON CHECKBOX
  -----------------------------------------------------
  local FpPanel = vgui.Create("DPanel", MainFrame)
  FpPanel:SetPos(10, 158)
  FpPanel:SetSize(131, 20)
  StyleBilliardPanel(FpPanel)
  local FpBoxCh = "false"

  if fpcue then
    FpBoxCh = "true"
  end

  local FpModeBox = vgui.Create("DCheckBoxLabel", FpPanel)
  FpModeBox:SetPos(5, 3)
  FpModeBox:SetText("Taco en primera persona")
  FpModeBox:SetTextColor(billiardColors.text)
  FpModeBox:SetValue(fpcue)
  FpModeBox:SizeToContents()

  FpModeBox.OnChange = function()
    if FpModeBox:GetChecked() then
      FpBoxCh = "true"
    else
      FpBoxCh = "false"
    end
  end

  -----------------------------------------------------
  -- SMART CUE CHECKBOX
  -----------------------------------------------------
  local ScPanel = vgui.Create("DPanel", MainFrame)
  ScPanel:SetPos(146, 158)
  ScPanel:SetSize(131, 20)
  StyleBilliardPanel(ScPanel)
  local scBoxCh = "true"

  if not sc then
    scBoxCh = "false"
  end

  ScModeBox = vgui.Create("DCheckBoxLabel", ScPanel)
  ScModeBox:SetPos(5, 3)
  ScModeBox:SetText("Taco inteligente")
  ScModeBox:SetTextColor(billiardColors.text)
  ScModeBox:SetValue(sc)
  ScModeBox:SizeToContents()

  ScModeBox.OnChange = function()
    if ScModeBox:GetChecked() then
      scBoxCh = "true"
    else
      scBoxCh = "false"
    end
  end

  -----------------------------------------------------
  -- TRAINING MODE CHECKBOX
  -----------------------------------------------------
  local TrPanel = vgui.Create("DPanel", MainFrame)
  TrPanel:SetPos(10, 183)
  TrPanel:SetSize(131, 20)
  StyleBilliardPanel(TrPanel)
  local trBoxCh = "false"

  if trn then
    trBoxCh = "true"
  end

  local TrModeBox = vgui.Create("DCheckBoxLabel", TrPanel)
  TrModeBox:SetPos(5, 3)
  TrModeBox:SetText("Modo entrenamiento")
  TrModeBox:SetTextColor(billiardColors.text)
  TrModeBox:SetValue(trn)
  TrModeBox:SizeToContents()

  TrModeBox.OnChange = function()
    if TrModeBox:GetChecked() then
      trBoxCh = "true"
    else
      trBoxCh = "false"
    end
  end

  -----------------------------------------------------
  -- MINGEBAG PROTECTION CHECKBOX
  -----------------------------------------------------
  local MpPanel = vgui.Create("DPanel", MainFrame)
  MpPanel:SetPos(282, 158)
  MpPanel:SetSize(131, 20)
  StyleBilliardPanel(MpPanel)
  local MpBoxCh = "true"

  if not mgp then
    MpBoxCh = "false"
  end

  local MpModeBox = vgui.Create("DCheckBoxLabel", MpPanel)
  MpModeBox:SetPos(5, 3)
  MpModeBox:SetText("Proteccion de la mesa")
  MpModeBox:SetTextColor(billiardColors.text)
  MpModeBox:SetValue(mgp)
  MpModeBox:SizeToContents()

  MpModeBox.OnChange = function()
    if MpModeBox:GetChecked() then
      MpBoxCh = "true"
    else
      MpBoxCh = "false"
    end
  end

  local spButton = vgui.Create("DButton", MainFrame)
  spButton:SetPos(282, 100)
  spButton:SetSize(131, 24)
  spButton:SetText("Aplicar")
  StyleBilliardButton(spButton)

  spButton.DoClick = function()
    RunConsoleCommand("billiard_config", bid, skin, gtype, rTime, trBoxCh, scBoxCh, abkMethod, MpBoxCh, FpBoxCh)
    MainFrame:Remove()
  end

  local CancelBtn = vgui.Create("DButton", MainFrame)
  CancelBtn:SetPos(282, 129)
  CancelBtn:SetSize(131, 24)
  CancelBtn:SetText("Cancelar")
  StyleBilliardButton(CancelBtn, true)

  CancelBtn.DoClick = function()
    MainFrame:Remove()
  end
end)

------------------------------------------------------------
--	BILLIARD TABLE REQUESTS LIST GUI
------------------------------------------------------------
function guiRequestPlayer()
  if type(b_requests_panel) == "Panel" then b_requests_panel:Remove() end

  local width = math.min(720, ScrW() - 40)
  local height = math.min(430, ScrH() - 40)
  b_requests_panel = vgui.Create("DFrame")
  b_requests_panel:SetSize(width, height)
  b_requests_panel:Center()
  StyleBilliardFrame(b_requests_panel, "SOLICITUDES DE BILLAR", "MBILLIARDS")
  b_requests_panel:SetVisible(true)
  local offset = 18
  local controlsWidth = math.max(190, width * 0.28)
  local GridList = vgui.Create("DListView", b_requests_panel)
  GridList:SetSize(width - controlsWidth - offset * 3, height - 72)
  GridList:SetPos(offset, 52)
  local column = GridList:AddColumn("JUGADOR INVITADO")
  column.Header:SetTextColor(billiardColors.text)
  GridList:SetHeaderHeight(30)
  GridList:SetDataHeight(34)
  GridList.Paint = function(panel, panelWidth, panelHeight)
    draw.RoundedBox(5, 0, 0, panelWidth, panelHeight, billiardColors.surface)
  end

  local requestRows = {}
  for _, request in pairs(RequestedPlayers) do
    if request then
      requestRows[#requestRows + 1] = request
      GridList:AddLine(tostring(request.Name))
    end
  end

  local BWidth, BHeight = controlsWidth, 38
  local buttonX = width - BWidth - offset
  local buttonY = 58
  local AccButn = vgui.Create("DButton", b_requests_panel)
  AccButn:SetSize(BWidth, BHeight)
  AccButn:SetPos(buttonX, buttonY)
  AccButn:SetText("ACEPTAR SELECCION")
  StyleBilliardButton(AccButn)

  AccButn.Think = function()
    local id = GridList:GetSelectedLine()

    if GridList ~= nil and id ~= nil then
      AccButn:SetEnabled(true)

      AccButn.DoClick = function()
        local request = requestRows[id]
        if not request then return end
        RunConsoleCommand("billiard_acc_ref", "true", request.ID)
        RequestedPlayers = {}
        b_requests_panel:Remove()
      end
    else
      AccButn:SetEnabled(false)
      AccButn.DoClick = function() end
    end
  end

  local RefButn = vgui.Create("DButton", b_requests_panel)
  RefButn:SetSize(BWidth, BHeight)
  RefButn:SetPos(buttonX, buttonY + 48)
  RefButn:SetText("RECHAZAR SELECCION")
  StyleBilliardButton(RefButn, true)

  RefButn.Think = function()
    local id = GridList:GetSelectedLine()

    if GridList ~= nil and id ~= nil then
      RefButn:SetEnabled(true)

      RefButn.DoClick = function()
        local request = requestRows[id]
        if not request then return end
        RunConsoleCommand("billiard_acc_ref", "false", request.ID)
        for key, value in pairs(RequestedPlayers) do
          if value == request then RequestedPlayers[key] = nil end
        end
        b_requests_panel:Remove()
        if table.Count(RequestedPlayers) >= 1 then return guiRequestPlayer() end
      end
    else
      RefButn:SetEnabled(false)
      RefButn.DoClick = function() end
    end
  end

  local RandButn = vgui.Create("DButton", b_requests_panel)
  RandButn:SetSize(BWidth, BHeight)
  RandButn:SetPos(buttonX, buttonY + 96)
  RandButn:SetText("ACEPTAR AL AZAR")
  StyleBilliardButton(RandButn)

  RandButn.DoClick = function()
    local request = requestRows[math.random(#requestRows)]
    if not request then return end
    RunConsoleCommand("billiard_acc_ref", "true", request.ID)
    RequestedPlayers = {}
    b_requests_panel:Remove()
  end

  local RefAButn = vgui.Create("DButton", b_requests_panel)
  RefAButn:SetSize(BWidth, BHeight)
  RefAButn:SetPos(buttonX, buttonY + 144)
  RefAButn:SetText("RECHAZAR TODAS")
  StyleBilliardButton(RefAButn, true)

  RefAButn.DoClick = function()
    for _, request in ipairs(requestRows) do
      RunConsoleCommand("billiard_acc_ref", "false", request.ID)
    end

    RequestedPlayers = {}
    b_requests_panel:Remove()
  end

  local ClButn = vgui.Create("DButton", b_requests_panel)
  ClButn:SetSize(BWidth, BHeight)
  ClButn:SetPos(buttonX, height - BHeight - 18)
  ClButn:SetText("CERRAR")
  StyleBilliardButton(ClButn, true)

  ClButn.DoClick = function()
    b_requests_panel:Remove()
    b_requests_panel = nil
  end
end

------------------------------------------------------------
--	BILLIARD TABLE CREATION GUI
------------------------------------------------------------
usermessage.Hook("billiard_createMenu", function(um)
  local SpawnPos = um:ReadVector()
  local MainFrame = vgui.Create("DFrame")
  MainFrame:SetSize(424, 242)
  MainFrame:Center()
  MainFrame:SetVisible(true)
  StyleBilliardFrame(MainFrame, "CREAR MESA", "MBILLIARDS")
  local BPanel = vgui.Create("DPanel", MainFrame)
  BPanel:SetPos(148, 30)
  BPanel:SetSize(266, 62)
  StyleBilliardPanel(BPanel)
  local BPanelTitle = vgui.Create("DLabel", BPanel)
  BPanelTitle:SetPos(10, 5)
  BPanelTitle:SetText("Opciones avanzadas")
  BPanelTitle:SetDark(true)
  --BPanelTitle:SetFont("TabLarge")
  BPanelTitle:SizeToContents()
  local abkMethod = 0
  local abkMultiChoice = vgui.Create("DComboBox", BPanel)
  abkMultiChoice:SetPos(140, 33)
  abkMultiChoice:SetSize(116, 20)
  abkMultiChoice:AddChoice("Metodo 1")
  abkMultiChoice:AddChoice("Metodo 2")

  abkMultiChoice.OnSelect = function(panel, id, text)
    abkMethod = id
  end

  abkMultiChoice:ChooseOptionID(2)
  local AbModeBox = vgui.Create("DCheckBoxLabel", BPanel)
  AbModeBox:SetPos(10, 35)
  AbModeBox:SetDark(true)
  AbModeBox:SetText("Proteccion de bolas fuera")
  AbModeBox:SetTextColor(billiardColors.text)
  AbModeBox:SetValue(1)
  AbModeBox:SizeToContents()

  AbModeBox.OnChange = function()
    if AbModeBox:GetChecked() then
      abkMethod = 1
      abkMultiChoice:SetVisible(true)
      abkMultiChoice:ChooseOptionID(1)
    else
      abkMethod = 0
      abkMultiChoice:SetVisible(false)
    end
  end

  -----------------------------------------------------
  -- SKIN BUTTON
  -----------------------------------------------------
  local skin = 0
  local ImageSkin = vgui.Create("DImageButton", MainFrame)
  ImageSkin:SetPos(10, 30)
  ImageSkin:SetSize(128, 64)
  ImageSkin:SetMaterial("VGUI/panel/skin0")

  ImageSkin.DoClick = function()
    if skin >= 2 then
      skin = 0
    else
      skin = skin + 1
    end

    ImageSkin:SetMaterial(string.format("VGUI/panel/skin%d", skin))
  end

  ImageSkin.DoRightClick = function()
    if skin <= 0 then
      skin = 2
    else
      skin = skin - 1
    end

    ImageSkin:SetMaterial(string.format("VGUI/panel/skin%d", skin))
  end

  -----------------------------------------------------
  -- GAME TYPE SELECTION BOX
  -----------------------------------------------------
  local gTPanel = vgui.Create("DPanel", MainFrame)
  gTPanel:SetPos(10, 100)
  gTPanel:SetSize(267, 24)
  StyleBilliardPanel(gTPanel)
  local gTLabel = vgui.Create("DLabel", gTPanel)
  gTLabel:SetPos(5, 4)
  gTLabel:SetDark(true)
  gTLabel:SetText("Tipo de partida")
  gTLabel:SetTextColor(billiardColors.text)
  --gTLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
  --gTLabel:SetFont("DefaultBold")
  gTLabel:SizeToContents()
  local gtype = 0
  local gTMultiChoice = vgui.Create("DComboBox", gTPanel)
  gTMultiChoice:SetPos(140, 2)
  gTMultiChoice:SetSize(120, 20)
  gTMultiChoice:AddChoice("8 bolas")
  gTMultiChoice:AddChoice("9 bolas")
  gTMultiChoice:AddChoice("Snooker")
  gTMultiChoice:AddChoice("Rotacion")
  gTMultiChoice:AddChoice("Carambola")

  gTMultiChoice.OnSelect = function(panel, id, text)
    gtype = id - 1
  end

  gTMultiChoice:ChooseOptionID(1)
  -----------------------------------------------------
  -- ROUND TIME SELECTION BOX
  -----------------------------------------------------
  local bTPanel = vgui.Create("DPanel", MainFrame)
  bTPanel:SetPos(10, 129)
  bTPanel:SetSize(267, 24)
  StyleBilliardPanel(bTPanel)
  local bTLabel = vgui.Create("DLabel", bTPanel)
  bTLabel:SetPos(5, 4)
  bTLabel:SetDark(true)
  bTLabel:SetText("Tiempo de ronda")
  bTLabel:SetTextColor(billiardColors.text)
  --bTLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
  --bTLabel:SetFont("DefaultBold")
  bTLabel:SizeToContents()
  local rTime = 0
  local bTMultiChoice = vgui.Create("DComboBox", bTPanel)
  bTMultiChoice:SetPos(140, 2)
  bTMultiChoice:SetSize(120, 20)
  bTMultiChoice:AddChoice("15 segundos")
  bTMultiChoice:AddChoice("30 segundos")
  bTMultiChoice:AddChoice("45 segundos")
  bTMultiChoice:AddChoice("60 segundos")

  bTMultiChoice.OnSelect = function(panel, id, text)
    rTime = id
  end

  bTMultiChoice:ChooseOptionID(2)
  -----------------------------------------------------
  -- TABLE SIZE SELECTION BOX
  -----------------------------------------------------
  local szPanel = vgui.Create("DPanel", MainFrame)
  szPanel:SetPos(10, 158)
  szPanel:SetSize(267, 24)
  StyleBilliardPanel(szPanel)
  local szLabel = vgui.Create("DLabel", szPanel)
  szLabel:SetPos(5, 4)
  szLabel:SetDark(true)
  szLabel:SetText("Tamano de mesa")
  szLabel:SetTextColor(billiardColors.text)
  --szLabel:SetExpensiveShadow(1, Color(0, 0, 0, 150))
  --szLabel:SetFont("DefaultBold")
  szLabel:SizeToContents()
  local size = 9
  local szMultiChoice = vgui.Create("DComboBox", szPanel)
  szMultiChoice:SetPos(140, 2)
  szMultiChoice:SetSize(120, 20)
  szMultiChoice:AddChoice("9 pies")
  szMultiChoice:AddChoice("10 pies")
  szMultiChoice:AddChoice("12 pies")

  szMultiChoice.OnSelect = function(panel, id, text)
    local select = {}
    select[1] = 9
    select[2] = 10
    select[3] = 12
    size = select[id]
  end

  szMultiChoice:ChooseOptionID(1)
  -----------------------------------------------------
  -- TRAINING MODE CHECKBOX
  -----------------------------------------------------
  local TrPanel = vgui.Create("DPanel", MainFrame)
  TrPanel:SetPos(10, 187)
  TrPanel:SetSize(131, 20)
  StyleBilliardPanel(TrPanel)
  local trBoxCh = "false"
  local TrModeBox = vgui.Create("DCheckBoxLabel", TrPanel)
  TrModeBox:SetPos(5, 3)
  TrModeBox:SetDark(true)
  TrModeBox:SetText("Modo entrenamiento")
  TrModeBox:SetTextColor(billiardColors.text)
  TrModeBox:SetValue(0)
  TrModeBox:SizeToContents()

  TrModeBox.OnChange = function()
    if TrModeBox:GetChecked() then
      trBoxCh = "true"
    else
      trBoxCh = "false"
    end
  end

  -----------------------------------------------------
  -- SMART CUE CHECKBOX
  -----------------------------------------------------
  local ScPanel = vgui.Create("DPanel", MainFrame)
  ScPanel:SetPos(146, 187)
  ScPanel:SetSize(131, 20)
  StyleBilliardPanel(ScPanel)
  local scBoxCh = "true"
  ScModeBox = vgui.Create("DCheckBoxLabel", ScPanel)
  ScModeBox:SetPos(5, 3)
  ScModeBox:SetDark(true)
  ScModeBox:SetText("Taco inteligente")
  ScModeBox:SetTextColor(billiardColors.text)
  ScModeBox:SetValue(1)
  ScModeBox:SizeToContents()

  ScModeBox.OnChange = function()
    if ScModeBox:GetChecked() then
      scBoxCh = "true"
    else
      scBoxCh = "false"
    end
  end

  -----------------------------------------------------
  -- MINGEBAG PROTECTION CHECKBOX
  -----------------------------------------------------
  local MpPanel = vgui.Create("DPanel", MainFrame)
  MpPanel:SetPos(282, 187)
  MpPanel:SetSize(131, 20)
  StyleBilliardPanel(MpPanel)
  local MpBoxCh = "true"
  local MpModeBox = vgui.Create("DCheckBoxLabel", MpPanel)
  MpModeBox:SetPos(5, 3)
  MpModeBox:SetDark(true)
  MpModeBox:SetText("Proteccion de la mesa")
  MpModeBox:SetTextColor(billiardColors.text)
  MpModeBox:SetValue(1)
  MpModeBox:SizeToContents()

  MpModeBox.OnChange = function()
    if MpModeBox:GetChecked() then
      MpBoxCh = "true"
    else
      MpBoxCh = "false"
    end
  end

  -----------------------------------------------------
  -- CUE FIRST PERSON CHECKBOX
  -----------------------------------------------------
  local FpPanel = vgui.Create("DPanel", MainFrame)
  FpPanel:SetPos(10, 212)
  FpPanel:SetSize(131, 20)
  StyleBilliardPanel(FpPanel)
  local FpBoxCh = "true"
  local FpModeBox = vgui.Create("DCheckBoxLabel", FpPanel)
  FpModeBox:SetPos(5, 3)
  FpModeBox:SetDark(true)
  FpModeBox:SetText("Taco en primera persona")
  FpModeBox:SetTextColor(billiardColors.text)
  FpModeBox:SetValue(1)
  FpModeBox:SizeToContents()

  FpModeBox.OnChange = function()
    if FpModeBox:GetChecked() then
      FpBoxCh = "true"
    else
      FpBoxCh = "false"
    end
  end

  local dfButton = vgui.Create("DButton", MainFrame)
  dfButton:SetPos(282, 100)
  dfButton:SetSize(131, 24)
  dfButton:SetText("Predeterminado")
  StyleBilliardButton(dfButton)

  dfButton.DoClick = function()
    AbModeBox:SetValue(1)
    abkMultiChoice:ChooseOptionID(2)
    ScModeBox:SetValue(1)
    TrModeBox:SetValue(0)
    MpModeBox:SetValue(1)
    FpModeBox:SetValue(1)
  end

  local spButton = vgui.Create("DButton", MainFrame)
  spButton:SetPos(282, 129)
  spButton:SetSize(131, 24)
  spButton:SetText("Crear mesa")
  StyleBilliardButton(spButton)

  spButton.DoClick = function()
    RunConsoleCommand("billiard_create", SpawnPos[1], SpawnPos[2], SpawnPos[3], size, skin, gtype, rTime, trBoxCh, scBoxCh, abkMethod, MpBoxCh, FpBoxCh)
    MainFrame:Remove()
  end

  local CancelBtn = vgui.Create("DButton", MainFrame)
  CancelBtn:SetPos(282, 158)
  CancelBtn:SetSize(131, 24)
  CancelBtn:SetText("Cancelar")
  StyleBilliardButton(CancelBtn, true)

  CancelBtn.DoClick = function()
    MainFrame:Remove()
  end
end)

------------------------------------------------------------
--	BILLIARD TABLE EXIT QUESTION GUI
------------------------------------------------------------
usermessage.Hook("billiard_promptExit", function(um)
  local width, height = ScrW() / 3, ScrH() / 4 -- 260, 150
  local MainFrame = vgui.Create("DFrame")
  MainFrame:SetSize(width, height)
  MainFrame:Center()
  MainFrame:SetVisible(true)
  StyleBilliardFrame(MainFrame, "SALIR DE LA MESA", "CONFIRMAR")
  MainFrame:DoModal()
  local Woffset, Hoffset = width * 0.1, height * 0.1
  local Label = vgui.Create("DLabel", MainFrame)
  Label:SetSize(width - Woffset, height / 2)
  Label:SetPos(Woffset / 2, 54)
  Label:SetWrap(true)
  Label:SetText("Estas seguro de que quieres salir? Perderas la partida.")
  Label:SetTextColor(billiardColors.text)
  Label:SetFont("BilliardMenuBody")
  Label:SetContentAlignment(5)
  local BWidth, BHeight = width / 2, height / 4
  BWidth = BWidth - Woffset * 1.5
  BHeight = BHeight - Hoffset
  local ExitButn = vgui.Create("DButton", MainFrame)
  ExitButn:SetSize(BWidth, BHeight)
  ExitButn:SetPos(Woffset, height - BHeight - Hoffset)
  ExitButn:SetText("Salir")
  StyleBilliardButton(ExitButn, true)

  ExitButn.DoClick = function()
    RunConsoleCommand("billiard_quit")
    MainFrame:Remove()
  end

  local CButn = vgui.Create("DButton", MainFrame)
  CButn:SetSize(BWidth, BHeight)
  CButn:SetPos(width - BWidth - Woffset, height - BHeight - Hoffset)
  CButn:SetText("Cancelar")
  StyleBilliardButton(CButn)

  CButn.DoClick = function()
    MainFrame:Remove()
  end
end)

hook.Add("Think", "CBilliardForceFirstPerson", function()
  BilliardForceFirstPerson()
end)

hook.Add("PrePlayerDraw", "CBilliardLockThirdPersonBody", function(player)
  if player ~= LocalPlayer() or not b_ThirdPersonLocked or not b_ThirdPersonBodyAngles then return end
  player:SetRenderAngles(b_ThirdPersonBodyAngles)
end)

usermessage.Hook("billiard_shotView", function(um)
  local c_b = um:ReadBool()

  if c_b then
    hook.Remove("CalcView", "CBilliardShotFirstPerson")
    hook.Add("CalcView", "CBilliardShotFirstPerson", BilliardShotFirstPersonView)
    hook.Add("ShouldDrawLocalPlayer", "CBilliardShotFirstPerson", function()
      return false
    end)

    return
  end

  BilliardRestoreShotView()
end)