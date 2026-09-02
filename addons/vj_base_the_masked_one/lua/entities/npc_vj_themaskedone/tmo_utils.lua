-- ============================================================
-- TMO - tmo_utils.lua
-- Utilidades: navmesh, velocidad del jugador, detección de puertas
-- ============================================================
---@diagnostic disable: undefined-global

-- ============================================================
-- NAVMESH
-- Verifica si el mapa tiene navmesh generado.
-- Se llama UNA sola vez al spawnear TMO desde CustomOnInitialize.
-- Resultado guardado en self.HasNavMesh (bool).
-- ============================================================
function ENT:CheckNavMesh()
    -- navmesh.GetNavAreaCount() devuelve 0 si no hay mesh
    local count = navmesh.GetNavAreaCount()
    if count and count > 0 then
        self.HasNavMesh = true
        print("[TMO] NavMesh detectado (" .. count .. " areas). Fase 5 habilitada.")
    else
        self.HasNavMesh = false
        print("[TMO] Sin NavMesh. La entidad se quedara en Fase 4.")
    end
end

-- ============================================================
-- VELOCIDAD DEL JUGADOR
-- Obtiene la velocidad actual del jugador (puede estar modificada
-- por addons) y devuelve esa velocidad + un margen extra para
-- que TMO sea siempre un poco más rápido.
-- ============================================================
local SPEED_MARGIN = 40 -- unidades extra sobre la velocidad del jugador

function ENT:GetChaseSpeed(ply)
    if not IsValid(ply) then return 200 end

    -- GetMaxSpeed() devuelve la velocidad máxima actual del jugador,
    -- respetando cualquier addon de velocidad que esté activo.
    local plySpeed = ply:GetMaxSpeed()

    -- Fallback por si el addon de velocidad devuelve 0 o un valor raro
    if not plySpeed or plySpeed <= 0 then
        plySpeed = ply:GetRunSpeed()
    end
    if not plySpeed or plySpeed <= 0 then
        plySpeed = 190 -- velocidad vanilla de GMod por defecto
    end

    return plySpeed + SPEED_MARGIN
end

-- ============================================================
-- DETECCIÓN DE PUERTA CERRADA
-- Verifica si hay una puerta cerrada entre TMO y el jugador.
-- Usa un TraceLine y busca entidades func_door o func_door_rotating
-- en el resultado.
-- Devuelve true si hay una puerta cerrada bloqueando.
-- ============================================================
local DOOR_CLASSES = {
    ["func_door"]          = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
}

function ENT:IsDoorBetween(ply)
    if not IsValid(ply) then return false end

    local startPos = self:GetPos() + Vector(0, 0, 40)
    local endPos   = ply:GetPos() + Vector(0, 0, 40)

    local tr = util.TraceLine({
        start  = startPos,
        endpos = endPos,
        filter = function(ent)
            -- Dejar pasar al propio TMO y al jugador
            if ent == self or ent == ply then return false end
            return true
        end,
        mask = MASK_SOLID
    })

    if tr.Hit and IsValid(tr.Entity) then
        local class = tr.Entity:GetClass()
        if DOOR_CLASSES[class] then
            -- Verificar que la puerta está cerrada (ángulo/posición en reposo)
            -- Para func_door: m_toggle_state 0 = cerrada
            -- Para prop_door_rotating se puede pedir el ángulo
            local ent = tr.Entity
            if class == "prop_door_rotating" then
                -- prop_door_rotating tiene IsOpen() en algunos frameworks,
                -- pero no en vanilla. Usamos el NWBool si existe, o asumimos cerrada
                -- si está bloqueando el trace.
                return true
            else
                -- func_door y func_door_rotating: si está en el trace, está bloqueando
                return true
            end
        end
    end

    return false
end

-- ============================================================
-- NODO NAVMESH MÁS CERCANO AL JUGADOR
-- Devuelve el CNavArea más cercano a una posición dada.
-- Devuelve nil si no encuentra ninguno en un radio razonable.
-- ============================================================
local NAV_SEARCH_RADIUS = 200

function ENT:GetNearestNavArea(pos)
    local area = navmesh.GetNearestNavArea(pos, false, NAV_SEARCH_RADIUS)
    return area -- puede ser nil si el jugador está fuera del mesh
end

-- ============================================================
-- VERIFICAR SI TMO PUEDE NAVEGAR HACIA EL JUGADOR
-- Comprueba que tanto TMO como el jugador tienen un CNavArea
-- válido en su posición. Si alguno no tiene, la cacería se cancela.
-- ============================================================
function ENT:CanNavigateTo(ply)
    if not IsValid(ply) then return false end

    local selfArea = self:GetNearestNavArea(self:GetPos())
    local plyArea  = self:GetNearestNavArea(ply:GetPos())

    return selfArea ~= nil and plyArea ~= nil
end
