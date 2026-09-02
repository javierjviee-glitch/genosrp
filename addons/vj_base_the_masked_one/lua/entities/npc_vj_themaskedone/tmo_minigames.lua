-- TMO - tmo_minigames.lua
---@diagnostic disable: undefined-global

-- CONSTANTES - CACERÍA
local CHASE_THINK_RATE = 0.05
local CHASE_STEP = 1

local CHASE_DURATION_MIN = 15
local CHASE_DURATION_MAX = 30

local CHASE_SPEED_START = 160
local CHASE_SPEED_MAX = 310

local JUMPSCARE_DISTANCE = 45

local CHASE_STUCK_TIME = 3.5
local CHASE_STUCK_MIN_PROGRESS = 40

local CHASE_FLANK_DIST = 300 
local CHASE_FLANK_MIN_SAFE = 250 
local CHASE_FLANK_GRACE = 2.0 

local CHASE_SPAWN_DIST_MIN = 450
local CHASE_SPAWN_DIST_MAX = 500

local CHASE_STEP_SOUND_FAR = 2.0
local CHASE_STEP_SOUND_NEAR = 0.6
local CHASE_STEP_SOUND_DIST = 350

local CHASE_PREDICT_INTERVAL = 4.0 -- cada cuántos segundos predice e intercepta
local CHASE_PREDICT_AHEAD = 500 -- unidades por delante del jugador
local CHASE_PREDICT_MIN_DIST = 250 -- distancia mínima para usar la predicción (si está muy cerca, no sirve)
local CHASE_PATH_REFRESH = 0.8 -- segundos entre recálculos del camino
local SND_CHASE_STEPS = {"npc/zombie/foot1.wav", "npc/zombie/foot2.wav", "npc/zombie/foot3.wav"}

-- CONSTANTES - MIRADA
local LOOKAT_THINK_RATE = 0.05
local LOOKAT_LOOK_DOT = 0.65
local LOOKAT_SPAWN_DIST = 200
local LOOKAT_JUMPSCARE_DIST = 55
local LOOKAT_ADVANCE_RATE = 50
local LOOKAT_MAX_DIST = 320
local LOOKAT_REPOSITION_DELAY = 1.5
local LOOKAT_REPOSITION_INTERVAL = 4.0
local LOOKAT_SPAWN_MIN_ANGLE = 65
local LOOKAT_SPAWN_MAX_ANGLE = 150
local LOOKAT_WIN_TIME = 25
local LOOKAT_FAIL_TIME = 1.5
local LOOKAT_FAKE_VISIBLE = 0.6
local LOOKAT_FAKE_CHANCE = 0.35
local LOOKAT_FREEZE_MIN = 1.0
local LOOKAT_FREEZE_MAX = 2.5
local LOOKAT_FAKE_MIN_ANGLE = 80

-- SONIDOS
local SND_CHASE = "themaskedone/persecucionrmo.wav"
local SND_LOOKAT = "themaskedone/linterngame.wav"
local SND_HEY = "themaskedone/hey.wav"
local SND_CRYING = {"themaskedone/crying1.wav", "themaskedone/crying2.wav", "themaskedone/crying3.wav",
                    "themaskedone/crying4.wav", "themaskedone/crying5.wav", "themaskedone/crying6.wav"}
local SND_CHASE_LAUGHS = {"themaskedone/laugh6.wav", "themaskedone/laugh7.wav"}


-- SELECCION ALEATORIA DE MINIJUEGO
local MINIGAMES = {"lookat","chase"}

function ENT:StartRandomMinigame()
    if self.MinigameActive then
        return
    end
    local choice = MINIGAMES[math.random(#MINIGAMES)]
    if choice == "chase" then
        self:StartChase()
    elseif choice == "lookat" then
        self:StartLookAt()
    end
end



-- LA CACERÍA
function ENT:StartChase()
    if self.MinigameActive then
        return
    end

    local ply = self:FindClosestPlayer()
    if not IsValid(ply) then
        return
    end

    if not self:CanNavigateTo(ply) then
        -- print("[TMO] Cacería cancelada: sin NavMesh.")
        self.ChaseFlankGraceUntil = nil
        self:StartCooldown()
        return
    end

    -- print("[TMO] ¡Cacería iniciada!")

    -- Inicializar estado PRIMERO, antes de crear cualquier timer
    self.MinigameActive = true
    self.ChaseActive = true
    self.ChaseStart = CurTime()
    self.ChaseTarget = ply
    self.ChaseTimerID = "TMO_Chase_" .. self:EntIndex()
    self.ChaseDuration = math.random(CHASE_DURATION_MIN, CHASE_DURATION_MAX)
    self.ChaseNextPredict = CurTime() + CHASE_PREDICT_INTERVAL
    self.ChasePath = nil
    self.ChasePathTime = nil
    self.ChasePathTarget = nil
    self.ChasePathIndex = 1
    self.ChaseLastDist = math.huge
    self.ChaseStuckSince = nil
    self.ChaseStuckBaseDist = nil
    self.ChaseNextStep = CurTime() + 0.5
    self.ChaseNextLaugh = nil

    self:ChaseSpawnAtDistance(ply, CHASE_SPAWN_DIST_MIN, CHASE_SPAWN_DIST_MAX)
    sound.Play(SND_CHASE, self:GetPos(), 85, 100)

    -- Timer de risas (después de inicializar ChaseActive)
    local laughTimerID = "TMO_ChaseLaugh_" .. self:EntIndex()
    timer.Create(laughTimerID, math.random(3, 6), 0, function()
        if not IsValid(self) or not self.ChaseActive then
            timer.Remove(laughTimerID)
            return
        end
        sound.Play(SND_CHASE_LAUGHS[math.random(#SND_CHASE_LAUGHS)], self:GetPos(), 80, 100)
        timer.Adjust(laughTimerID, math.random(3, 6), 0)
    end)

    -- Timer principal de movimiento
    timer.Create(self.ChaseTimerID, CHASE_THINK_RATE, 0, function()
        if not IsValid(self) then
            timer.Remove(self.ChaseTimerID)
            return
        end
        self:ChaseThink()
    end)
end

function ENT:ChaseSpawnAtDistance(ply, minDist, maxDist)
    for attempt = 1, 12 do
        local angle = math.random(1, 360)
        local dist = math.random(minDist, maxDist)
        local origin = ply:GetPos() + Vector(math.cos(math.rad(angle)) * dist, math.sin(math.rad(angle)) * dist, 50)

        local groundTr = util.TraceLine({
            start = origin,
            endpos = origin - Vector(0, 0, 400),
            filter = ply,
            mask = MASK_SOLID_BRUSHONLY
        })

        if groundTr.Hit then
            local candidate = groundTr.HitPos + Vector(0, 0, 5)
            local area = navmesh.GetNearestNavArea(candidate, false, 80)
            if area then
                self:SetPos(candidate)
                self:SetNoDraw(false)
                self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                -- print(string.format("[TMO] Cacería: aparece a %.0fu (intento %d)", dist, attempt))
                return
            end
        end
    end

    self:AppearNearPlayer()
    -- print("[TMO] Cacería: spawn fallback cercano.")
end

function ENT:ChaseThink()
    if not self.ChaseActive then
        timer.Remove(self.ChaseTimerID or "")
        return
    end

    local ply = self.ChaseTarget
    local now = CurTime()

    if not IsValid(ply) or not ply:Alive() then
        -- print("[TMO] Cacería cancelada: jugador inválido.")
        self:EndChase(false)
        return
    end

    if now - self.ChaseStart >= self.ChaseDuration then
        -- print("[TMO] Cacería: tiempo agotado. Jugador sobrevivió.")
        self:EndChase(false)
        return
    end

    if not self:CanNavigateTo(ply) then
        -- print("[TMO] Cacería cancelada: sin NavMesh.")
        self:EndChase(false)
        return
    end

    -- Puerta bloqueando: pausar movimiento este tick
    if self:IsDoorBetween(ply) then
        return
    end

    local myPos = self:GetPos()
    local dist = myPos:Distance(ply:GetPos())

    -- ── JUMPSCARE ─────────────────────────────────────────
    local graceActive = self.ChaseFlankGraceUntil and CurTime() < self.ChaseFlankGraceUntil

    if dist <= JUMPSCARE_DISTANCE and self.ChaseLastDist < math.huge and not graceActive then
        -- print("[TMO] Cacería: alcanzó al jugador. ¡Jumpscare!")
        self:EndChase(true)
        return
    end

    -- ── SONIDO DE PASOS ───────────────────────────────────
    if now >= self.ChaseNextStep then
        local interval = dist < CHASE_STEP_SOUND_DIST and CHASE_STEP_SOUND_NEAR or CHASE_STEP_SOUND_FAR
        sound.Play(SND_CHASE_STEPS[math.random(#SND_CHASE_STEPS)], myPos, 75, math.random(95, 105))
        self.ChaseNextStep = now + interval
    end

    -- ── DETECCIÓN DE ATASCO ───────────────────────────────
    -- En lugar de comparar tick a tick, medimos progreso total
    -- desde que empezamos a trackear. Solo flanqueamos si en
    -- CHASE_STUCK_TIME segundos no avanzó CHASE_STUCK_MIN_PROGRESS u.
    if self.ChaseStuckSince == nil then
        -- Iniciar tracking: guardar distancia de referencia
        self.ChaseStuckSince = now
        self.ChaseStuckBaseDist = dist
    else
        local stuckElapsed = now - self.ChaseStuckSince
        local totalProgress = self.ChaseStuckBaseDist - dist -- positivo = se acercó

        if stuckElapsed >= CHASE_STUCK_TIME then
            if totalProgress < CHASE_STUCK_MIN_PROGRESS then
                -- Realmente atascado: no avanzó suficiente
                -- print(string.format("[TMO] Cacería: atascado (progreso %.0fu en %.1fs), flanqueando.", totalProgress,
                --     stuckElapsed))
                self:ChaseFlank(ply)
                self.ChaseStuckSince = nil
                self.ChaseStuckBaseDist = nil
                self.ChaseLastDist = math.huge
                return
            else
                -- Progresó suficiente: resetear ventana de medición
                self.ChaseStuckSince = now
                self.ChaseStuckBaseDist = dist
            end
        end
    end
    if CurTime() >= self.ChaseNextPredict then
        self:ChaseIntercept(ply)
        self.ChaseNextPredict = CurTime() + CHASE_PREDICT_INTERVAL
        self.ChaseStuckSince = nil
        self.ChaseStuckBaseDist = nil
        self.ChaseLastDist = math.huge
        return
    end
    self.ChaseLastDist = dist
    self:ChaseMove(ply)
end
function ENT:ChaseIntercept(ply)
    local plyPos = ply:GetPos()
    local plyVel = ply:GetVelocity()

    -- Si el jugador está quieto o casi quieto, usar su dirección de vista
    local moveDir
    if plyVel:Length2D() > 30 then
        moveDir = plyVel:GetNormalized()
    else
        moveDir = ply:GetAimVector()
    end
    moveDir.z = 0
    moveDir:Normalize()

    -- Intentar aparecer por delante del jugador en distintas distancias
    local distances = {CHASE_PREDICT_AHEAD, CHASE_PREDICT_AHEAD * 0.7, CHASE_PREDICT_AHEAD * 1.3}

    for _, aheadDist in ipairs(distances) do
        -- Ligeramente lateral para no aparecer exactamente enfrente
        -- (más natural y da tiempo de reacción al jugador)
        for _, lateralOffset in ipairs({0, 60, -60}) do
            local right = moveDir:Angle():Right()
            local targetPos = plyPos + moveDir * aheadDist + right * lateralOffset

            local groundTr = util.TraceLine({
                start = targetPos + Vector(0, 0, 80),
                endpos = targetPos - Vector(0, 0, 300),
                filter = ply,
                mask = MASK_SOLID_BRUSHONLY
            })

            if groundTr.Hit then
                local candidate = groundTr.HitPos + Vector(0, 0, 5)
                local distToPlayer = candidate:Distance(plyPos)
                local area = navmesh.GetNearestNavArea(candidate, false, 80)

                if area and distToPlayer >= CHASE_PREDICT_MIN_DIST then
                    self:SetPos(candidate)
                    self:SetNoDraw(false)
                    self.ChaseFlankGraceUntil = CurTime() + CHASE_FLANK_GRACE

                    -- print(string.format("[TMO] Intercepción: %.0fu por delante (vel=%.0f)", distToPlayer,
                    --     plyVel:Length2D()))
                    return
                end
            end
        end
    end


    -- print("[TMO] Intercepción fallida, flanqueando.")
    self:ChaseFlank(ply)
end
function ENT:ChaseMove(ply)
    local selfPos = self:GetPos()
    local plyPos = ply:GetPos()

    -- Velocidad progresiva
    -- AHORA:
    local elapsed = CurTime() - self.ChaseStart
    local t = math.Clamp(elapsed / self.ChaseDuration, 0, 1)
    local baseSpeed = Lerp(t, CHASE_SPEED_START, CHASE_SPEED_MAX)

    -- Velocidad del jugador en 2D (ignoramos Z para no contar saltos)
    local plySpeed = ply:GetVelocity():Length2D()

    -- TMO va siempre un poco más rápido que el jugador,
    -- pero nunca por debajo de baseSpeed ni por encima de CHASE_SPEED_MAX
    local speed = math.Clamp(plySpeed + 40, baseSpeed, CHASE_SPEED_MAX)

    -- Siguiente waypoint del camino A*
    local nextPos = self:ChaseGetNextWaypoint(ply)

    local dir = (nextPos - selfPos)
    dir.z = 0
    if dir:LengthSqr() == 0 then
        return
    end
    dir:Normalize()

    local newPos = selfPos + dir * speed * CHASE_THINK_RATE * CHASE_STEP

    local groundTr = util.TraceLine({
        start = newPos + Vector(0, 0, 20),
        endpos = newPos - Vector(0, 0, 100),
        filter = ply,
        mask = MASK_SOLID_BRUSHONLY
    })
    if groundTr.Hit then
        newPos = groundTr.HitPos + Vector(0, 0, 5)
    end

    self:SetPos(newPos)
    self:SetAngles(Angle(0, (plyPos - newPos):Angle().y, 0))
end

function ENT:ChaseGetPath(startPos, endPos)
    local startArea = navmesh.GetNearestNavArea(startPos, false, 200)
    local endArea = navmesh.GetNearestNavArea(endPos, false, 200)

    if not startArea or not endArea then
        return nil
    end
    if startArea == endArea then
        return {endPos}
    end

    -- ── A* ────────────────────────────────────────────────
    local open = {} -- {area, gCost, hCost, parent}
    local closed = {} -- area → true
    local cameFrom = {} -- area → area
    local gCost = {} -- area → número
    local fCost = {} -- area → número

    local function heuristic(area)
        return area:GetCenter():Distance(endPos)
    end

    gCost[startArea] = 0
    fCost[startArea] = heuristic(startArea)
    table.insert(open, startArea)

    local iterations = 0
    local MAX_ITER = 256 -- límite para no colgar el servidor

    while #open > 0 and iterations < MAX_ITER do
        iterations = iterations + 1

        -- Encontrar nodo con menor fCost en open
        local bestIdx, bestArea = 1, open[1]
        for i = 2, #open do
            if (fCost[open[i]] or math.huge) < (fCost[bestArea] or math.huge) then
                bestIdx = i
                bestArea = open[i]
            end
        end

        -- Si llegamos al destino → reconstruir camino
        if bestArea == endArea then
            local path = {}
            local current = endArea
            while cameFrom[current] do
                table.insert(path, 1, current:GetCenter())
                current = cameFrom[current]
            end
            table.insert(path, endPos)
            return path
        end

        -- Mover de open a closed
        table.remove(open, bestIdx)
        closed[bestArea] = true

        -- Expandir vecinos
        for _, neighbor in ipairs(bestArea:GetAdjacentAreas()) do
            if not closed[neighbor] then
                local tentativeG = (gCost[bestArea] or 0) + bestArea:GetCenter():Distance(neighbor:GetCenter())

                if not gCost[neighbor] or tentativeG < gCost[neighbor] then
                    cameFrom[neighbor] = bestArea
                    gCost[neighbor] = tentativeG
                    fCost[neighbor] = tentativeG + heuristic(neighbor)

                    -- Añadir a open si no está
                    local inOpen = false
                    for _, a in ipairs(open) do
                        if a == neighbor then
                            inOpen = true
                            break
                        end
                    end
                    if not inOpen then
                        table.insert(open, neighbor)
                    end
                end
            end
        end
    end

    return nil -- sin camino
end
function ENT:ChaseGetNextWaypoint(ply)
    local now = CurTime()
    local myPos = self:GetPos()
    local plyPos = ply:GetPos()

    -- Recalcular si: no hay camino, expiró, o el jugador se movió mucho
    local needsRefresh = not self.ChasePath or not self.ChasePathTime or (now - self.ChasePathTime) >=
                             CHASE_PATH_REFRESH or
                             (self.ChasePathTarget and self.ChasePathTarget:Distance(plyPos) > 150)

    if needsRefresh then
        self.ChasePath = self:ChaseGetPath(myPos, plyPos)
        self.ChasePathTime = now
        self.ChasePathTarget = plyPos
        self.ChasePathIndex = 1
    end

    if not self.ChasePath or #self.ChasePath == 0 then
        return plyPos -- fallback directo
    end

    -- Avanzar en el camino si ya llegamos al waypoint actual
    local waypoint = self.ChasePath[self.ChasePathIndex]
    if waypoint and myPos:Distance(waypoint) < 40 then
        self.ChasePathIndex = self.ChasePathIndex + 1
        waypoint = self.ChasePath[self.ChasePathIndex]
    end

    return waypoint or plyPos
end

function ENT:ChaseFlank(ply)
    local plyPos = ply:GetPos()
    local aimYaw = ply:GetAimVector():Angle().y

    -- Intentar posiciones en arco lateral/trasero (90°-270° desde donde mira)
    -- dividido en sectores para cubrir bien el espacio
    local sectors = {90, 135, 180, 225, 270, 110, 160, 200, 250}

    for attempt, baseAngle in ipairs(sectors) do
        local side = (math.random() > 0.5) and 1 or -1
        local degOff = baseAngle + math.random(-20, 20)
        local spawnYaw = aimYaw + (degOff * side)

        local dist = math.random(CHASE_FLANK_DIST, CHASE_FLANK_DIST + 80)
        local dir = Vector(math.cos(math.rad(spawnYaw)), math.sin(math.rad(spawnYaw)), 0):GetNormalized()

        local origin = plyPos + dir * dist + Vector(0, 0, 50)

        local groundTr = util.TraceLine({
            start = origin,
            endpos = origin - Vector(0, 0, 300),
            filter = ply,
            mask = MASK_SOLID_BRUSHONLY
        })

        if groundTr.Hit then
            local candidate = groundTr.HitPos + Vector(0, 0, 5)
            local distToPlayer = candidate:Distance(plyPos)
            local area = navmesh.GetNearestNavArea(candidate, false, 80)

            if area and distToPlayer >= CHASE_FLANK_MIN_SAFE then
                self:SetPos(candidate)
                self:SetNoDraw(false)
                self.ChaseFlankGraceUntil = CurTime() + CHASE_FLANK_GRACE
                -- print(string.format("[TMO] Flanqueo OK: %.0fu, %.0f° (intento %d)", distToPlayer, degOff, attempt))
                return
            end
        end
    end

    -- Fallback seguro: reusar ChaseSpawnAtDistance con distancia garantizada
    -- Si también falla sus 12 intentos, TMO queda donde está (no se mueve)
    -- hasta que el siguiente tick de atasco vuelva a intentarlo
    local spawned = false
    for attempt = 1, 16 do
        local angle = math.random(1, 360)
        local dist = math.random(CHASE_FLANK_MIN_SAFE, CHASE_FLANK_MIN_SAFE + 150)
        local origin = plyPos + Vector(math.cos(math.rad(angle)) * dist, math.sin(math.rad(angle)) * dist, 50)

        local groundTr = util.TraceLine({
            start = origin,
            endpos = origin - Vector(0, 0, 400),
            filter = ply,
            mask = MASK_SOLID_BRUSHONLY
        })

        if groundTr.Hit then
            local candidate = groundTr.HitPos + Vector(0, 0, 5)
            local distToPlayer = candidate:Distance(plyPos)
            local area = navmesh.GetNearestNavArea(candidate, false, 80)

            if area and distToPlayer >= CHASE_FLANK_MIN_SAFE then
                self:SetPos(candidate)
                self:SetNoDraw(false)
                self.ChaseFlankGraceUntil = CurTime() + CHASE_FLANK_GRACE
                -- print(string.format("[TMO] Flanqueo fallback OK: %.0fu (intento %d)", distToPlayer, attempt))
                spawned = true
                return
            end
        end
    end

    if not spawned then
        -- print("[TMO] Flanqueo: sin posición válida, TMO continúa donde está.")
        self.ChaseFlankGraceUntil = CurTime() + CHASE_FLANK_GRACE
        self.ChaseStuckSince = nil
        self.ChaseStuckBaseDist = nil
    end
end
function ENT:EndChase(caught)
    local ply = self.ChaseTarget
    -- Añadir en EndChase (limpieza):
    self.ChaseNextPredict = nil
    self.ChaseActive = false
    self.ChaseTarget = nil
    self.ChaseLastDist = nil
    self.ChaseStuckSince = nil
    self.ChaseStuckBaseDist = nil
    self.ChaseFlankGraceUntil = nil
    self.ChasePath = nil
    self.ChasePathTime = nil
    self.ChasePathTarget = nil
    self.ChasePathIndex = nil

    if self.ChaseTimerID then
        timer.Remove(self.ChaseTimerID)
        self.ChaseTimerID = nil
    end

    if caught then
        if IsValid(ply) then
            self:DoJumpscare(ply)
        end
        timer.Simple(3, function()
            if not IsValid(self) then
                return
            end
            self.MinigameActive = false
            self:Vanish()
            self:StartCooldown()
        end)
    else
        self:Vanish()
        self.MinigameActive = false
        self:StartCooldown()
    end
    timer.Remove("TMO_ChaseLaugh_" .. self:EntIndex())

end

-- LA MIRADA

function ENT:StartLookAt()
    if self.MinigameActive then
        return
    end

    local ply = self:FindClosestPlayer()
    if not IsValid(ply) then
        return
    end

    -- print("[TMO] ¡Minijuego de mirada iniciado!")

    self.MinigameActive = true
    self.LookAtActive = true
    self.LookAtTarget = ply
    self.LookAtSuccessTime = 0
    self.LookAtFailTimer = nil
    self.LookAtRepositioning = false
    self.LookAtNextReposition = CurTime() + LOOKAT_REPOSITION_INTERVAL
    self.LookAtIsFake = false
    self.LookAtFreezeTimer = nil
    self.LookAtFreezeLimit = nil

    self.LookAt_OldWalkSpeed = ply:GetWalkSpeed()
    self.LookAt_OldRunSpeed = ply:GetRunSpeed()
    ply:SetWalkSpeed(40)
    ply:SetRunSpeed(40)

    ply:SetNWBool("TMO_Fog", true)
    ply:SetNWFloat("TMO_FogAlpha", 0.50)

    sound.Play(SND_LOOKAT, ply:GetPos(), 85, 100)

    -- Primera aparición siempre real
    self:LookAtSpawnNearPlayer(ply, false)

    self.LookAtTimerID = "TMO_LookAt_" .. self:EntIndex()
    timer.Create(self.LookAtTimerID, LOOKAT_THINK_RATE, 0, function()
        if not IsValid(self) then
            timer.Remove(self.LookAtTimerID)
            return
        end
        self:LookAtThink()
    end)
end

function ENT:LookAtThink()
    if not self.LookAtActive then
        timer.Remove(self.LookAtTimerID or "")
        return
    end

    if self.LookAtRepositioning then return end

    local ply = self.LookAtTarget
    if not IsValid(ply) or not ply:Alive() then
        -- print("[TMO] Mirada cancelada: jugador inválido.")
        self:EndLookAt(false, true)
        return
    end

    local now = CurTime()

    if now >= self.LookAtNextReposition then
        local isFake = math.random() < LOOKAT_FAKE_CHANCE
        -- print("[TMO] Mirada: reposición " .. (isFake and "FALSA" or "REAL"))
        self:LookAtStartReposition(ply, isFake)
        return
    end

    if self:GetNoDraw() then return end

    local myPos  = self:GetPos()
    local plyPos = ply:GetPos()
    local dist   = myPos:Distance(plyPos)

    local ang = (ply:EyePos() - myPos):Angle()
    self:SetAngles(Angle(0, ang.y, 0))


    if self.LookAtIsFake then return end

    local isLooking = self:IsPlayerLookingLookat(ply)

    if isLooking then
        self.LookAtFailTimer = nil

        if self.LookAtFreezeTimer == nil then
            self.LookAtFreezeLimit = math.random(
                LOOKAT_FREEZE_MIN * 10,
                LOOKAT_FREEZE_MAX * 10
            ) / 10
            self.LookAtFreezeTimer = now
            -- print(string.format("[TMO] Mirada: congelado por %.1fs", self.LookAtFreezeLimit))
        end

        self.LookAtSuccessTime = self.LookAtSuccessTime + LOOKAT_THINK_RATE
        if self.LookAtSuccessTime >= LOOKAT_WIN_TIME then
            -- print("[TMO] Mirada: jugador ganó.")
            self:EndLookAt(true, false)
            return
        end

        if now - self.LookAtFreezeTimer >= self.LookAtFreezeLimit then
            -- print("[TMO] Mirada: congelada expiró, reposicionando.")
            self.LookAtFreezeTimer    = nil
            self.LookAtFreezeLimit    = nil
            self.LookAtNextReposition = now
        end

    else
        self.LookAtFreezeTimer = nil
        self.LookAtFreezeLimit = nil

        if self.LookAtFailTimer == nil then
            self.LookAtFailTimer = now
        end

        if now - self.LookAtFailTimer >= LOOKAT_FAIL_TIME then
            -- print("[TMO] Mirada: tiempo sin mirar agotado. Jumpscare.")
            self:EndLookAt(false, false)
            return
        end

        if dist > LOOKAT_JUMPSCARE_DIST then
            local advDir = (plyPos - myPos)
            advDir.z = 0
            if advDir:LengthSqr() > 0 then
                advDir:Normalize()
                local newPos = myPos + advDir * LOOKAT_ADVANCE_RATE * LOOKAT_THINK_RATE
                local groundTr = util.TraceLine({
                    start  = newPos + Vector(0, 0, 20),
                    endpos = newPos - Vector(0, 0, 100),
                    filter = ply,
                    mask   = MASK_SOLID_BRUSHONLY
                })
                if groundTr.Hit then
                    self:SetPos(groundTr.HitPos + Vector(0, 0, 5))
                else
                    self:SetPos(newPos)
                end
            end
        else
            -- print("[TMO] Mirada: TMO demasiado cerca. Jumpscare.")
            self:EndLookAt(false, false)
            return
        end
    end
end

function ENT:LookAtStartReposition(ply, isFake)
    if self.LookAtRepositioning then
        return
    end
    self.LookAtRepositioning = true
    self:SetNoDraw(true)

    timer.Remove("TMO_Fake_" .. self:EntIndex())

    local repositionTimerID = "TMO_Reposition_" .. self:EntIndex()
    timer.Create(repositionTimerID, LOOKAT_REPOSITION_DELAY, 1, function()
        if not IsValid(self) or not self.LookAtActive then
            return
        end
        if not IsValid(ply) or not ply:Alive() then
            return
        end

        self:LookAtSpawnNearPlayer(ply, isFake or false)
        self.LookAtRepositioning = false
        self.LookAtFailTimer = nil
        self.LookAtFreezeTimer = nil
        self.LookAtFreezeLimit = nil
        self.LookAtNextReposition = CurTime() + LOOKAT_REPOSITION_INTERVAL
    end)
end

function ENT:LookAtSpawnNearPlayer(ply, isFake)
    local aimVec = ply:GetAimVector()
    local aimYaw = aimVec:Angle().y

    local minAngle = isFake and LOOKAT_FAKE_MIN_ANGLE or LOOKAT_SPAWN_MIN_ANGLE

    for attempt = 1, 16 do 
        local side     = (math.random() > 0.5) and 1 or -1
        local degOff   = math.random(minAngle, LOOKAT_SPAWN_MAX_ANGLE)
        local spawnYaw = aimYaw + (degOff * side)

        local dir = Vector(
            math.cos(math.rad(spawnYaw)),
            math.sin(math.rad(spawnYaw)),
            0
        ):GetNormalized()

        local dist   = math.random(LOOKAT_SPAWN_DIST - 30, LOOKAT_SPAWN_DIST + 30)
        local origin = ply:GetPos() + dir * dist + Vector(0, 0, 50)

        local groundTr = util.TraceLine({
            start  = origin,
            endpos = origin - Vector(0, 0, 300),
            filter = ply,
            mask   = MASK_SOLID_BRUSHONLY
        })

        if groundTr.Hit then
            local spawnPos = groundTr.HitPos + Vector(0, 0, 5)

            local area = navmesh.GetNearestNavArea(spawnPos, false, 50)
            if area then
                local visTr = util.TraceLine({
                    start  = ply:GetPos() + Vector(0, 0, 64),  
                    endpos = spawnPos + Vector(0, 0, 40),       
                    filter = ply,
                    mask   = MASK_SOLID_BRUSHONLY
                })

                if not visTr.Hit then
                    local zmins, zmaxs = self:GetCollisionBounds()
                    local hullTr = util.TraceHull({
                        start  = spawnPos,
                        endpos = spawnPos + Vector(0, 0, 10),
                        mins   = zmins,
                        maxs   = zmaxs,
                        filter = game.GetWorld(),
                        mask   = MASK_SOLID_BRUSHONLY
                    })

                    if not hullTr.Hit then
                        local tooCloseToWall = false
                        local wallCheckDirs  = {
                            Vector(1,0,0), Vector(-1,0,0),
                            Vector(0,1,0), Vector(0,-1,0)
                        }
                        for _, wallDir in ipairs(wallCheckDirs) do
                            local wallTr = util.TraceLine({
                                start  = spawnPos + Vector(0, 0, 35),
                                endpos  = spawnPos + Vector(0, 0, 35) + wallDir * 40,
                                mask   = MASK_SOLID_BRUSHONLY
                            })
                            if wallTr.Hit then
                                tooCloseToWall = true
                                break
                            end
                        end

                        if not tooCloseToWall then
                            self:SetPos(spawnPos)
                            self:SetNoDraw(false)
                            self:SetCollisionGroup(COLLISION_GROUP_NONE)

                            local ang = (ply:EyePos() - spawnPos):Angle()
                            self:SetAngles(Angle(0, ang.y, 0))
                            sound.Play(SND_HEY, spawnPos, 80, 100)

                            self.LookAtIsFake = isFake

                            if isFake then
                                local fakeTimerID = "TMO_Fake_" .. self:EntIndex()
                                timer.Remove(fakeTimerID)
                                timer.Create(fakeTimerID, LOOKAT_FAKE_VISIBLE, 1, function()
                                    if not IsValid(self) or not self.LookAtActive then return end
                                    self:SetNoDraw(true)
                                    self.LookAtIsFake         = false
                                    self.LookAtFreezeTimer    = nil
                                    self.LookAtFreezeLimit    = nil
                                    self.LookAtNextReposition = CurTime()
                                end)
                            end

                            return
                        end
                    end
                end
            end
        end
    end

    -- ── FALLBACK ──────────────────────────────────────────
    -- Si después de 16 intentos no encontró posición válida,
    -- buscar la mejor posición con NavMesh ignorando la pared
    -- print("[TMO] Mirada: buscando fallback con NavMesh...")

    for attempt = 1, 8 do
        local angle  = math.random(1, 360)
        local dist   = math.random(LOOKAT_SPAWN_DIST - 50, LOOKAT_SPAWN_DIST + 50)
        local dir    = Vector(
            math.cos(math.rad(angle)),
            math.sin(math.rad(angle)),
            0
        )
        local origin = ply:GetPos() + dir * dist + Vector(0, 0, 50)

        local groundTr = util.TraceLine({
            start  = origin,
            endpos = origin - Vector(0, 0, 300),
            filter = ply,
            mask   = MASK_SOLID_BRUSHONLY
        })

        if groundTr.Hit then
            local candidate = groundTr.HitPos + Vector(0, 0, 5)
            local area      = navmesh.GetNearestNavArea(candidate, false, 50)
            if area then
                self:SetPos(candidate)
                self:SetNoDraw(false)
                self:SetCollisionGroup(COLLISION_GROUP_NONE)
                local ang = (ply:EyePos() - candidate):Angle()
                self:SetAngles(Angle(0, ang.y, 0))
                sound.Play(SND_HEY, candidate, 80, 100)
                self.LookAtIsFake = false
                -- print("[TMO] Mirada: fallback NavMesh OK (intento " .. attempt .. ")")
                return
            end
        end
    end

    -- Último recurso: detrás del jugador
    local backDir = -ply:GetAimVector()
    backDir.z = 0
    backDir:Normalize()
    local fallPos = ply:GetPos() + backDir * LOOKAT_SPAWN_DIST
    local fallGr  = util.TraceLine({
        start  = fallPos + Vector(0, 0, 50),
        endpos = fallPos - Vector(0, 0, 200),
        filter = ply,
        mask   = MASK_SOLID_BRUSHONLY
    })
    local finalPos = fallGr.Hit and (fallGr.HitPos + Vector(0, 0, 5)) or fallPos
    self:SetPos(finalPos)
    self:SetNoDraw(false)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    local ang = (ply:EyePos() - finalPos):Angle()
    self:SetAngles(Angle(0, ang.y, 0))
    sound.Play(SND_HEY, finalPos, 80, 100)
    self.LookAtIsFake = false
    -- print("[TMO] Mirada: fallback último recurso.")
end

function ENT:IsPlayerLookingLookat(ply)
    local dir = (self:GetPos() - ply:EyePos()):GetNormalized()
    return dir:Dot(ply:GetAimVector()) > LOOKAT_LOOK_DOT
end

function ENT:EndLookAt(won, cancelled)
    self.LookAtActive = false

    if self.LookAtTimerID then
        timer.Remove(self.LookAtTimerID)
        self.LookAtTimerID = nil
    end

    timer.Remove("TMO_Reposition_" .. self:EntIndex())
    timer.Remove("TMO_Fake_" .. self:EntIndex())

    local ply = self.LookAtTarget

    if IsValid(ply) then
        ply:SetWalkSpeed(self.LookAt_OldWalkSpeed or 200)
        ply:SetRunSpeed(self.LookAt_OldRunSpeed or 400)
        ply:SetNWFloat("TMO_FogAlpha", 0.0)
        ply:SetNWBool("TMO_Fog", false)
    end

    self.LookAtTarget = nil
    self.LookAtRepositioning = false
    self.LookAtIsFake = false
    self.LookAtFreezeTimer = nil
    self.LookAtFreezeLimit = nil
    self:SetNoDraw(false)

    if cancelled then
        self:Vanish()
        self.MinigameActive = false
        self:StartCooldown()
        return
    end

    if won then
        -- print("[TMO] Mirada: TMO huye.")
        timer.Simple(0.5, function()
            if IsValid(self) then
                self:Vanish()
            end
        end)
        self.MinigameActive = false
        self:StartCooldown()
    else
        if IsValid(ply) then
            self:DoJumpscare(ply)
        end
        timer.Simple(3, function()
            if not IsValid(self) then
                return
            end
            self.MinigameActive = false
            self:Vanish()
            self:StartCooldown()
        end)
    end
end

-- COOLDOWN

function ENT:StartCooldown()
    local cooldown = math.random(15, 45)
    local idx = self:EntIndex()
    local cryTimerID = "TMO_Crying_" .. idx

    self.CooldownActive = true
    self.NextMinigame = CurTime() + cooldown

    -- print("[TMO] Cooldown iniciado. Próximo minijuego en " .. cooldown .. "s")

    timer.Remove(cryTimerID)
    timer.Create(cryTimerID, math.random(4, 8), 0, function()
        if not IsValid(self) then
            timer.Remove(cryTimerID)
            return
        end
        if CurTime() >= self.NextMinigame then
            timer.Remove(cryTimerID)
            self.CooldownActive = false
            -- print("[TMO] Cooldown terminado.")
            return
        end
        local plyLocal = self:FindClosestPlayer()
        if not IsValid(plyLocal) then
            return
        end
        local offset = Vector(math.random(-300, 300), math.random(-300, 300), math.random(-50, 50))
        local soundPos = plyLocal:GetPos() + offset
        local tr = util.TraceLine({
            start = plyLocal:GetPos() + Vector(0, 0, 30),
            endpos = soundPos,
            filter = plyLocal,
            mask = MASK_SOLID_BRUSHONLY
        })
        if tr.Hit then
            soundPos = tr.HitPos - (tr.HitPos - plyLocal:GetPos()):GetNormalized() * 20
        end
        sound.Play(SND_CRYING[math.random(#SND_CRYING)], soundPos, 60, 100)
        timer.Adjust(cryTimerID, math.random(4, 8), 0)
    end)
end
