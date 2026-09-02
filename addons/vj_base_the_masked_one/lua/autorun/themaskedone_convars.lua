-- autorun/themaskedone_convars.lua
---@diagnostic disable: undefined-global

CreateConVar("tmo_look_delay",     0.05, FCVAR_ARCHIVE)
CreateConVar("tmo_aggressiveness", 5,    FCVAR_ARCHIVE)
CreateConVar("tmo_allow_kill",     0,    FCVAR_ARCHIVE)

-- 0 = progresivo automático
-- 1 = calma total (fase 0)
-- 2 = solo sonidos (fase 1)
-- 3 = sonidos + poltergeist (fase 2)
-- 4 = apariciones (fase 3)
-- 5 = pesadilla (fase 4, 30 segundos)
-- 6 = terror absoluto (fase 5, minijuegos - requiere navmesh)
-- 7 = modo TEST
CreateConVar("tmo_mode", 0, FCVAR_ARCHIVE)

-- Duración de cada fase en segundos (independientes entre sí)
CreateConVar("tmo_phase0_duration", 120, FCVAR_ARCHIVE) -- calma:       2 min
CreateConVar("tmo_phase1_duration", 180, FCVAR_ARCHIVE) -- sonidos:     3 min
CreateConVar("tmo_phase2_duration", 180, FCVAR_ARCHIVE) -- poltergeist: 3 min
CreateConVar("tmo_phase3_duration", 240, FCVAR_ARCHIVE) -- apariciones: 4 min
-- fase 4 dura 30 segundos fijos (no configurable, es transición a fase 5)
-- fase 5 no tiene duración, es permanente (requiere navmesh en el mapa)

CreateConVar("tmo_poltergeist_radius", 300, FCVAR_ARCHIVE)
CreateConVar("tmo_poltergeist_height", 40,  FCVAR_ARCHIVE)

-- Idioma del menú
CreateConVar("tmo_language", 0, FCVAR_ARCHIVE) -- 0 = Español, 1 = English
