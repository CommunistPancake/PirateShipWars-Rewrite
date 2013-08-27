AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local canSpawn = false

CreateConVar("psw_musket", 1, FCVAR_NOTIFY)
CreateConVar("psw_pistol", 1, FCVAR_NOTIFY)
CreateConVar("psw_sabre", 1, FCVAR_NOTIFY)
CreateConVar("psw_grenade" 1, FCVAR_NOTIFY)

function GM:PlayerSetModel(ply)
	if ply:Team() == TEAM_SPECTATOR then return end
	if ply:Team() == TEAM_RED then
		ply:SetModel("models/player/pirate/pirate_redd.mdl")
	else
		ply:SetModel("models/player/pirate/pirate_blue.mdl")
	end
end

function GM:PlayerInitialSpawn(ply)
	ply.temp = 98.6
	ply:SetTeam(TEAM_SPECTATOR)
end

function GM:PlayerLoadout(ply)
	if ply:Team() == TEAM_SPECTATOR then
		GAMEMODE:PlayerSpawnAsSpectator(ply)
		ply:CrosshairDisable()
	else
		if GetConVar("psw_musket") then ply:Give("weapon_pmusket") end
		if GetConVar("psw_pistol") then ply:Give("weapon_ppistol") end
		if GetConVar("psw_sabre") then ply:Give("weapon_sabre") end
		if GetConVar("psw_grenade") then ply:Give("weapon_grenade") end
	end
end