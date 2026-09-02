---@diagnostic disable: undefined-global
ENT.Base = "npc_vj_creature_base"
ENT.Type = "ai"
---@diagnostic disable: undefined-global

ENT.PrintName    = "The Masked One"
ENT.Author       = "quietla locura"
ENT.Contact      = ""
ENT.Purpose      = "NPC de terror paranormal"
ENT.Instructions = ""
ENT.Category     = "Paranormal"
ENT.IconOverride = "materials/vgui/entities/The_Masked_One.jpg"
ENT.Spawnable             = false
ENT.AdminSpawnable        = false
ENT.DoNotRegisterInVJMenu = false

ENT.Model             = {"models/scp/scp_087_b_1.mdl"}
ENT.StartHealth       = 99999
ENT.VJ_NPC_Class      = {"CLASS_GHOST"}
ENT.MovementType      = VJ_MOVETYPE_STATIONARY
ENT.SightDistance     = 2000
ENT.MeleeAttackDamage = 0

-- ConVars
CreateConVar("tmo_language", "0", FCVAR_ARCHIVE)
CreateConVar("tmo_mode",               0,    FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_phase0_duration",    120,  FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_phase1_duration",    180,  FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_phase2_duration",    180,  FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_phase3_duration",    240,  FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_aggressiveness",     1,    FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_allow_kill",         0,    FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_look_delay",         0.05, FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_poltergeist_radius", 300,  FCVAR_REPLICATED + FCVAR_ARCHIVE)
CreateConVar("tmo_poltergeist_height", 40,   FCVAR_REPLICATED + FCVAR_ARCHIVE)