-- ============================================================
-- TMO (The Masked One) - entities/init.lua
-- ============================================================
---@diagnostic disable: undefined-global
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

include("tmo_utils.lua")
include("tmo_minigames.lua")

-- ============================================================
-- TABLAS DE SONIDOS
-- ============================================================
ENT.SoundsTbl_Voices = {
    "themaskedone/voices1.wav", "themaskedone/voices2.wav",
    "themaskedone/voices3.wav", "themaskedone/voices4.wav",
    "themaskedone/voices5.wav", "themaskedone/voices6.wav"
}

ENT.SoundsTbl_Appear = {
    "themaskedone/breathing.wav",  "themaskedone/breathing1.wav",
    "themaskedone/breathing2.wav", "themaskedone/laugh1.wav",
    "themaskedone/laugh2.wav",     "themaskedone/laugh3.wav",
    "themaskedone/laugh4.wav",     "themaskedone/laugh5.wav",
    "themaskedone/laugh11.wav",    "themaskedone/laugh111.wav",
    "themaskedone/laugh222.wav",   "themaskedone/laugh666.wav",
    "themaskedone/laugh66.wav",    "themaskedone/laugh777.wav",
    "themaskedone/laugh77.wav"
}

ENT.SoundsTbl_Jumpscare = {
    "themaskedone/jumpscare1.wav",
    "themaskedone/jumpscare2.wav"
}

-- ============================================================
-- CONSTANTES INTERNAS
-- ============================================================
local PHASE_NAMES = {
    [0] = "Fase 0 - Calma total",
    [1] = "Fase 1 - Sonidos ambientales",
    [2] = "Fase 2 - Poltergeist",
    [3] = "Fase 3 - Apariciones",
    [4] = "Fase 4 - Pesadilla (30s)",
    [5] = "Fase 5 - Terror absoluto"
}

local LOOK_DOT_THRESHOLD = 0.85
local FALLBACK_RADIUS    = 150

-- ============================================================
-- INICIALIZACIÓN
-- ============================================================
function ENT:CustomOnInitialize()
    self:SetModel("models/scp/scp_087_b_1.mdl")
    self:SetNoDraw(true)

    self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 70))
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

    self.InJumpscare = false
    self.StartTime   = CurTime()
    self.LastPhase   = -1

    self.MinigameActive = false
    self.CooldownActive = false
    self.NextMinigame   = nil

    self.ChaseActive  = false
    self.ChaseTarget  = nil
    self.ChaseTimerID = nil

    self.LookAtActive        = false
    self.LookAtTarget        = nil
    self.LookAtTimerID       = nil
    self.LookAtFailTimer     = nil
    self.LookAtSuccessTime   = 0
    self.LookAtRepositioning = false

    -- Fase 4
    self.Phase4JumpscaredDone = false

    self.CachedConvars = {}
    self:RefreshConvarCache()

    self.NextSound  = nil
    self.NextThrow  = nil
    self.NextAction = nil
    self.NextJump   = nil
    self.LookTimer  = nil

    self.NightmareActive = false

    util.PrecacheSound("themaskedone/ambienthell.wav")

    timer.Simple(1, function()
        if IsValid(self) then
            self:CheckNavMesh()
        end
    end)

    timer.Create("TMO_ConvarRefresh_" .. self:EntIndex(), 5, 0, function()
        if not IsValid(self) then
            timer.Remove("TMO_ConvarRefresh_" .. self:EntIndex())
            return
        end
        self:RefreshConvarCache()
    end)
end

-- ============================================================
-- CACHÉ DE CONVARS
-- ============================================================
local function safeFloat(name, default)
    local cv = GetConVar(name)
    return cv and cv:GetFloat() or default
end

local function safeInt(name, default)
    local cv = GetConVar(name)
    return cv and cv:GetInt() or default
end

local function safeBool(name, default)
    local cv = GetConVar(name)
    return cv and cv:GetBool() or default
end

function ENT:RefreshConvarCache()
    local c = self.CachedConvars

    c.phase0_dur         = math.Round(safeFloat("tmo_phase0_duration", 120) / 10) * 10
    c.phase1_dur         = math.Round(safeFloat("tmo_phase1_duration", 180) / 10) * 10
    c.phase2_dur         = math.Round(safeFloat("tmo_phase2_duration", 180) / 10) * 10
    c.phase3_dur         = math.Round(safeFloat("tmo_phase3_duration", 240) / 10) * 10
    c.phase4_dur         = 30
    c.poltergeist_radius = safeFloat("tmo_poltergeist_radius", 400)
    c.poltergeist_height = safeFloat("tmo_poltergeist_height", 200)
    c.aggressiveness     = math.max(safeInt("tmo_aggressiveness", 1), 1)
    c.look_delay         = safeFloat("tmo_look_delay", 1.0)
    c.allow_kill         = safeBool("tmo_allow_kill", false)
    c.mode               = safeInt("tmo_mode", 0)
end

-- ============================================================
-- FASE ACTUAL
-- ============================================================
function ENT:GetCurrentPhase()
    local mode = self.CachedConvars.mode

    if mode == 1 then return 0 end
    if mode == 2 then return 1 end
    if mode == 3 then return 2 end
    if mode == 4 then return 3 end
    if mode == 5 then return 4 end
    if mode == 6 then return 5 end
    if mode == 7 then return 99 end

    local c       = self.CachedConvars
    local elapsed = CurTime() - self.StartTime

    local t0 = c.phase0_dur
    local t1 = t0 + c.phase1_dur
    local t2 = t1 + c.phase2_dur
    local t3 = t2 + c.phase3_dur
    local t4 = t3 + c.phase4_dur

    if elapsed < t0 then     return 0
    elseif elapsed < t1 then return 1
    elseif elapsed < t2 then return 2
    elseif elapsed < t3 then return 3
    elseif elapsed < t4 then return 4
    else                     return 5
    end
end

-- ============================================================
-- THINK PRINCIPAL
-- ============================================================
function ENT:OnThinkActive()
    if self.InJumpscare then return end

    local phase = self:GetCurrentPhase()

    if phase == 99 then
        self:Think_TestMode()
        return
    end

    if phase == 5 and not self.HasNavMesh then
        phase = 4
    end

    local ply = self:FindClosestPlayer()

    if self.LastPhase ~= phase then
        self:OnPhaseChanged(self.LastPhase, phase, ply)
        self.LastPhase = phase
    end

    if phase == 0 then return end

    if IsValid(ply) and not self:GetNoDraw() then
        local ang = (ply:EyePos() - self:GetPos()):Angle()
        self:SetAngles(Angle(0, ang.y, 0))
    end

    if phase >= 1 then self:Think_Phase1_Sounds(ply) end
    if phase >= 2 then self:Think_Phase2_Poltergeist(ply, phase) end
    if phase >= 3 then self:Think_Phase3_Apparitions(ply, phase) end
    if phase >= 4 then self:Think_Phase4_Jumpscare(ply) end
    if phase >= 5 then self:Think_Phase5_Minigames(ply) end

    if phase >= 4 and not self:GetNoDraw() and not self.InJumpscare then
        local seqID = self:LookupSequence("idleonfire")
        if seqID and seqID > 0 then
            if self:GetSequence() ~= seqID or self:GetCycle() >= 0.99 then
                self:ResetSequence(seqID)
                self:SetPlaybackRate(1.0)
            end
        end
    end

    local minigameRunning = self.MinigameActive or self.LookAtActive or self.ChaseActive
    if not self:GetNoDraw() and IsValid(ply) and not minigameRunning then
        if self:IsPlayerLooking(ply) then
            self.LookTimer = self.LookTimer or (CurTime() + self.CachedConvars.look_delay)
            if CurTime() > self.LookTimer then
                self:Vanish()
            end
        else
            self.LookTimer = nil
        end
    end
end

-- ============================================================
-- CAMBIO DE FASE
-- ============================================================
function ENT:OnPhaseChanged(oldPhase, newPhase, ply)
    print("[TMO] " .. (PHASE_NAMES[newPhase] or ("Fase desconocida: " .. newPhase)))

    self.NextSound  = nil
    self.NextThrow  = nil
    self.NextJump   = nil

    if newPhase < 3 then
        self.NextAction = nil
    end

    -- ── FASE 4 ────────────────────────────────────────────
    if newPhase == 4 then
        self.Phase4JumpscaredDone = false
        self.NextJump             = nil
        self:StartNightmare(ply)
    end

    -- ── FASE 5 ────────────────────────────────────────────
    if newPhase == 5 then
        self:StartPhase5(ply)
    end

    if oldPhase == 4 and newPhase < 4 then
        self:StopNightmare(ply)
    end

    if oldPhase == 5 and newPhase < 5 then
        if self.ChaseActive  then self:EndChase(false) end
        if self.LookAtActive then self:EndLookAt(false, true) end
    end
end

-- ============================================================
-- THINK FASE 4: JUMPSCARES
-- ============================================================
function ENT:Think_Phase4_Jumpscare(ply)
    if self.MinigameActive then return end
    if self.LookAtActive   then return end
    if self.ChaseActive    then return end

    -- ── JUMPSCARE DE ENTRADA (una sola vez) ───────────────
    if not self.Phase4JumpscaredDone then
        if IsValid(ply) then
            self.Phase4JumpscaredDone = true
            self:DoJumpscare(ply, true)  -- noKill siempre en fase 4
        end
        return
    end

    -- ── JUMPSCARES PERIÓDICOS (solo sin NavMesh) ──────────
    -- Con NavMesh TMO pasa a fase 5 y los minijuegos compensan.
    -- Sin NavMesh la fase 4 es permanente, así que añadimos
    -- jumpscares periódicos para mantener la tensión.
    if self.HasNavMesh then return end

    self.NextJump = self.NextJump or (CurTime() + math.random(20, 35))
    if CurTime() < self.NextJump then return end

    if IsValid(ply) then
        self:DoJumpscare(ply, true)  -- noKill en fase 4
    end

    self.NextJump = CurTime() + math.random(25, 45)
end

-- ============================================================
-- THINK FASE 5: MINIJUEGOS
-- ============================================================
function ENT:Think_Phase5_Minigames(ply)
    if self.MinigameActive then return end

    if self.NextMinigame == nil then
        self.NextMinigame = CurTime() + math.random(8, 15)
        -- print("[TMO] Fase 5: primer minijuego en " ..
        --       math.floor(self.NextMinigame - CurTime()) .. "s")
    end

    if CurTime() >= self.NextMinigame then
        if IsValid(ply) then
            self:StartRandomMinigame()
        end
    end
end

-- ============================================================
-- INICIO DE FASE 5
-- ============================================================
function ENT:StartPhase5(ply)
    -- print("[TMO] Fase 5 activada")
    self.NextMinigame = nil

    if IsValid(ply) then
        sound.Play("themaskedone/ambienthell.wav", ply:GetPos(), 90, 100)
        self:ApplyNightmareEffects(ply)
    end
end

-- ============================================================
-- NIGHTMARE (Fase 4)
-- ============================================================
function ENT:StartNightmare(ply)
    if self.NightmareActive then return end
    self.NightmareActive = true

    local idx = self:EntIndex()

    -- Solo efectos visuales y sonido — el jumpscare
    -- lo maneja Think_Phase4_Jumpscare para tener control total
    timer.Simple(3, function()
        if not IsValid(ply) then return end
        self:ApplyNightmareEffects(ply)
        sound.Play("themaskedone/ambienthell.wav", ply:GetPos(), 90, 100)
    end)

    timer.Create("TMO_NightmareEffects_" .. idx, 6, 0, function()
        if not IsValid(self) then
            timer.Remove("TMO_NightmareEffects_" .. idx)
            return
        end
        local p = self:GetCurrentPhase()
        if p < 4 then
            timer.Remove("TMO_NightmareEffects_" .. idx)
            return
        end
        local pl = self:FindClosestPlayer()
        if IsValid(pl) then self:ApplyNightmareEffects(pl) end
    end)

    timer.Create("TMO_NightmareMusic_" .. idx, 40, 0, function()
        if not IsValid(self) then
            timer.Remove("TMO_NightmareMusic_" .. idx)
            return
        end
        local p = self:GetCurrentPhase()
        if p < 4 then
            timer.Remove("TMO_NightmareMusic_" .. idx)
            return
        end
        local pl = self:FindClosestPlayer()
        if IsValid(pl) then
            sound.Play("themaskedone/ambienthell.wav", pl:GetPos(), 90, 100)
        end
    end)
end

function ENT:StopNightmare(ply)
    if not self.NightmareActive then return end
    self.NightmareActive = false

    local idx = self:EntIndex()
    timer.Remove("TMO_NightmareEffects_" .. idx)
    timer.Remove("TMO_NightmareMusic_"   .. idx)

    if IsValid(ply) then
        ply:SetNWFloat("TMO_Brightness", 1.0)
        ply:SetNWBool("TMO_Nightmare", false)
        ply:SetNWBool("TMO_Fog", false)
    end
end

function ENT:ApplyNightmareEffects(ply)
    ply:SetNWFloat("TMO_Brightness", 0.3)
    ply:SetNWBool("TMO_Nightmare", true)
end

-- ============================================================
-- FASE 1: SONIDOS AMBIENTALES
-- ============================================================
function ENT:Think_Phase1_Sounds(ply)
    self.NextSound = self.NextSound or (CurTime() + math.random(10, 20))
    if CurTime() < self.NextSound then return end

    if IsValid(ply) then
        local offset   = Vector(math.random(-300, 300), math.random(-300, 300), math.random(-50, 50))
        local soundPos = ply:GetPos() + offset

        local tr = util.TraceLine({
            start  = ply:GetPos() + Vector(0, 0, 30),
            endpos = soundPos,
            filter = ply,
            mask   = MASK_SOLID_BRUSHONLY
        })
        if tr.Hit then
            soundPos = tr.HitPos - (tr.HitPos - ply:GetPos()):GetNormalized() * 20
        end

        local snd = self.SoundsTbl_Voices[math.random(#self.SoundsTbl_Voices)]
        sound.Play(snd, soundPos, 55, 100)
    end

    self.NextSound = CurTime() + math.random(10, 20)
end

-- ============================================================
-- FASE 2: POLTERGEIST
-- ============================================================
function ENT:Think_Phase2_Poltergeist(ply, phase)
    local throwMin = phase >= 4 and 1 or 8
    local throwMax = phase >= 4 and 2 or 14

    self.NextThrow = self.NextThrow or (CurTime() + math.random(throwMin, throwMax))
    if CurTime() < self.NextThrow then return end

    if not IsValid(ply) then
        self.NextThrow = CurTime() + math.random(5, 8)
        return
    end

    local c          = self.CachedConvars
    local validProps = {}

    for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), c.poltergeist_radius)) do
        if IsValid(ent) and ent:GetClass() == "prop_physics" and IsValid(ent:GetPhysicsObject()) then
            table.insert(validProps, ent)
        end
    end

    if #validProps == 0 then
        self.NextThrow = CurTime() + math.random(5, 8)
        return
    end

    table.Shuffle(validProps)

    local maxProps  = phase >= 4 and #validProps or math.random(1, 3)
    local fallDelay = phase >= 4 and 0.3 or 1.2

    for i = 1, math.min(maxProps, #validProps) do
        local obj  = validProps[i]
        local phys = IsValid(obj) and obj:GetPhysicsObject() or nil

        if IsValid(obj) and IsValid(phys) then
            sound.Play("ambient/materials/metal_stress1.wav", obj:GetPos(), 60, 100)
            phys:EnableGravity(false)
            phys:SetVelocity(Vector(0, 0, c.poltergeist_height))
            phys:AddAngleVelocity(VectorRand() * 100)
            obj:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

            local capturedObj = obj
            timer.Simple(fallDelay, function()
                if not IsValid(capturedObj) then return end
                local phys2 = capturedObj:GetPhysicsObject()
                if not IsValid(phys2) then return end

                phys2:EnableGravity(true)
                sound.Play("physics/metal/metal_box_impact_bullet1.wav", capturedObj:GetPos(), 70, 100)

                local force = VectorRand() * 400
                force.z     = math.random(50, 120)
                phys2:SetVelocity(force)

                timer.Simple(2, function()
                    if IsValid(capturedObj) then
                        capturedObj:SetCollisionGroup(COLLISION_GROUP_NONE)
                    end
                end)
            end)
        end
    end

    self.NextThrow = CurTime() + math.random(throwMin, throwMax)
end

-- ============================================================
-- FASE 3 Y 4: APARICIONES
-- ============================================================
function ENT:Think_Phase3_Apparitions(ply, phase)
    if self.LookAtActive then return end
    if self.ChaseActive  then return end  -- no interferir con cacería
    if phase >= 5 and self.MinigameActive then return end

    if self.NextAction == nil then
        self.NextAction = CurTime() + 5
    end

    if CurTime() < self.NextAction then return end
    if not self:GetNoDraw() then return end

    local aggro = self.CachedConvars.aggressiveness

    if phase >= 4 then
        self:AppearNearPlayer()

        local extras = math.random(1, 2)
        for i = 1, extras do
            timer.Simple(i * 0.4, function()
                if not IsValid(self) or self.InJumpscare then return end
                self:Vanish()
                timer.Simple(0.1, function()
                    if not IsValid(self) or self.InJumpscare then return end
                    self:AppearNearPlayer()
                end)
            end)
        end

        local mn = math.max(1.5 / aggro, 0.6)
        local mx = math.max(3.5 / aggro, 1.2)
        self.NextAction = CurTime() + math.Rand(mn, mx)
    else
        self:AppearNearPlayer()
        local mn = math.max(8 / aggro, 4)
        local mx = math.max(20 / aggro, 8)
        self.NextAction = CurTime() + math.Rand(mn, mx)
    end
end

-- ============================================================
-- MODO TEST
-- ============================================================
function ENT:Think_TestMode()
    local ply = self:FindClosestPlayer()
    if not IsValid(ply) then return end

    self:SetNoDraw(false)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

    self.TestAppear = self.TestAppear or 0
    if CurTime() > self.TestAppear then
        self.TestAppear = CurTime() + 3
        self:AppearNearPlayer()
    end
end

-- ============================================================
-- JUMPSCARE
-- ============================================================
function ENT:DoJumpscare(ply, noKill)
    if self.InJumpscare then return end
    if not IsValid(ply) or not ply:Alive() then return end

    self.InJumpscare = true
    ply:SetMoveType(MOVETYPE_NONE)

    local zmins, zmaxs = self:GetCollisionBounds()
    local selfHeight   = (zmaxs - zmins).z

    local timerID     = "TMO_Jumpscare_" .. self:EntIndex()
    local fadeTimerID = "TMO_FogFade_"   .. self:EntIndex()
    local fogHoldID   = "TMO_FogHold_"   .. self:EntIndex()
    local fogMidID    = "TMO_FogMid_"    .. self:EntIndex()

    timer.Remove(fadeTimerID)
    timer.Remove(fogHoldID)
    timer.Remove(fogMidID)

    local sndJump    = self.SoundsTbl_Jumpscare[math.random(#self.SoundsTbl_Jumpscare)]
    local defaultFov = ply:GetFOV()
    local headOffset = selfHeight * 0.9

    local spawnPos = ply:GetPos() + ply:GetForward() * 30
    local groundTr = util.TraceLine({
        start  = spawnPos + Vector(0, 0, 50),
        endpos = spawnPos - Vector(0, 0, 200),
        filter = ply,
        mask   = MASK_SOLID_BRUSHONLY
    })
    if groundTr.Hit then
        spawnPos = groundTr.HitPos + Vector(0, 0, selfHeight / 10 + 2.8)
    end

    self:SetPos(spawnPos)
    self:SetNoDraw(true)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

    timer.Simple(0.6, function()
        if not IsValid(self) or not self.InJumpscare then return end
        if not IsValid(ply) or not ply:Alive() then
            self.InJumpscare = false
            ply:SetMoveType(MOVETYPE_WALK)
            return
        end

        ply:SetNWBool("TMO_Fog", true)
        ply:SetNWFloat("TMO_FogAlpha", 1.0)

        local seqID = self:LookupSequence("idleonfire")
        if seqID and seqID > 0 then
            self:ResetSequence(seqID)
            self:SetPlaybackRate(0)
            self:SetCycle(0)
        end

        self:SetNoDraw(false)
        sound.Play(sndJump, ply:GetPos(), 90, 100)
        self.JumpscareStart = CurTime()

        timer.Create(timerID, 0, 0, function()
            if not IsValid(self) or not IsValid(ply) or not self.InJumpscare then
                timer.Remove(timerID)
                return
            end

            local ang = (ply:EyePos() - self:GetPos()):Angle()
            self:SetAngles(Angle(0, ang.y, 0))

            local headPos = self:GetPos() + Vector(0, 0, headOffset)
            local t       = math.Clamp((CurTime() - self.JumpscareStart) / 0.3, 0, 1)

            ply:SetFOV(Lerp(t, defaultFov, 20), 0)

            local targetAngle  = (headPos - ply:EyePos()):Angle()
            local currentAngle = ply:EyeAngles()
            ply:SetEyeAngles(LerpAngle(t * 0.2, currentAngle, targetAngle))
        end)
    end)

    timer.Simple(2.4, function()
        if not IsValid(self) then return end
        self:Vanish()
    end)

    timer.Simple(2.5, function()
        timer.Remove(timerID)

        if IsValid(ply) then
            ply:SetMoveType(MOVETYPE_WALK)
            ply:SetFOV(defaultFov, 0.3)
            if self.CachedConvars.allow_kill and not noKill and ply:Alive() then
                ply:Kill()
            end
        end

        if IsValid(self) then
            self.InJumpscare = false
            self:Vanish()
            self:SetPlaybackRate(1.0)
        end
    end)

    timer.Create(fogHoldID, 20, 1, function()
        if not IsValid(ply) then return end
        ply:SetNWFloat("TMO_FogAlpha", 0.5)
    end)

    timer.Create(fogMidID, 25, 1, function()
        if not IsValid(ply) then return end

        local elapsed      = 0
        local fadeDuration = 5.0
        local fadeInterval = 0.05

        timer.Create(fadeTimerID, fadeInterval, 0, function()
            elapsed = elapsed + fadeInterval
            if not IsValid(ply) or elapsed >= fadeDuration then
                timer.Remove(fadeTimerID)
                if IsValid(ply) then
                    ply:SetNWFloat("TMO_FogAlpha", 0.0)
                    ply:SetNWBool("TMO_Fog", false)
                end
                return
            end
            local alpha = 0.5 * (1.0 - (elapsed / fadeDuration))
            ply:SetNWFloat("TMO_FogAlpha", alpha)
        end)
    end)
end

-- ============================================================
-- UTILIDADES
-- ============================================================
function ENT:Vanish()
    self:SetNoDraw(true)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self.LookTimer = nil
end

function ENT:FindClosestPlayer()
    local closest, minDist = nil, math.huge
    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() then
            local d = ply:GetPos():Distance(self:GetPos())
            if d < minDist then closest, minDist = ply, d end
        end
    end
    return closest
end

function ENT:AppearNearPlayer()
    local ply = self:FindClosestPlayer()
    if not IsValid(ply) then return end
    local pos = self:GetSafePositionNearPlayer(ply)
    if not pos then return end
    self:SetPos(pos)
    self:SetNoDraw(false)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    local snd = self.SoundsTbl_Appear[math.random(#self.SoundsTbl_Appear)]
    sound.Play(snd, self:GetPos(), 70, 100)
end

function ENT:IsPlayerLooking(ply)
    local dir = (self:GetPos() - ply:EyePos()):GetNormalized()
    return dir:Dot(ply:GetAimVector()) > LOOK_DOT_THRESHOLD
end

function ENT:GetSafePositionNearPlayer(ply)
    local zmins, zmaxs = self:GetCollisionBounds()
    local selfHeight   = (zmaxs - zmins).z
    local zOffset      = selfHeight / 10 + 2.8

    local minRadius = 150
    local maxRadius = 300

    for _ = 1, 8 do
        local angle    = math.random(1, 360)
        local distance = math.random(minRadius, maxRadius)
        local origin   = ply:GetPos() +
                         Vector(math.cos(math.rad(angle)) * distance,
                                math.sin(math.rad(angle)) * distance, 50)

        local groundTr = util.TraceLine({
            start  = origin,
            endpos = origin - Vector(0, 0, 500),
            filter = ply,
            mask   = MASK_SOLID_BRUSHONLY
        })

        if groundTr.Hit then
            local candidate = groundTr.HitPos + Vector(0, 0, zOffset)

            local visTr = util.TraceLine({
                start  = ply:GetPos() + Vector(0, 0, 30),
                endpos = candidate,
                filter = ply,
                mask   = MASK_SOLID_BRUSHONLY
            })

            local hullTr = util.TraceHull({
                start  = candidate,
                endpos = candidate + Vector(0, 0, selfHeight),
                mins   = zmins,
                maxs   = zmaxs,
                filter = game.GetWorld()
            })

            local wallBlocked = visTr.Hit and visTr.Fraction < 0.9
            if not wallBlocked and not hullTr.Hit then
                return candidate
            end
        end
    end

    local fallAngle  = math.random(1, 360)
    local fallOrigin = ply:GetPos() +
                       Vector(math.cos(math.rad(fallAngle)) * FALLBACK_RADIUS,
                              math.sin(math.rad(fallAngle)) * FALLBACK_RADIUS, 50)
    local fallGround = util.TraceLine({
        start  = fallOrigin,
        endpos = fallOrigin - Vector(0, 0, 500),
        filter = ply,
        mask   = MASK_SOLID_BRUSHONLY
    })

    if fallGround.Hit then
        return fallGround.HitPos + Vector(0, 0, zOffset)
    end

    return ply:GetPos() +
           Vector(math.cos(math.rad(fallAngle)) * FALLBACK_RADIUS,
                  math.sin(math.rad(fallAngle)) * FALLBACK_RADIUS, 0)
end