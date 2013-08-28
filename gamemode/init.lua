AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")
include("ship.lua")

canSpawn = false
currentRound = 1
local lastThink = CurTime()
local shipsSpawned = false
local starting = false

CreateConVar("psw_musket", 1, FCVAR_NOTIFY)
CreateConVar("psw_pistol", 1, FCVAR_NOTIFY)
CreateConVar("psw_sabre", 1, FCVAR_NOTIFY)
CreateConVar("psw_grenade" 1, FCVAR_NOTIFY)
CreateConVar("psw_nodoors", 0, FCVAR_NOTIFY)
CreateConVar("psw_piratesay", 1, FCVAR_NOTIFY)
CreateConVar("psw_rounds", 5, FCVAR_NOTIFY) --rounds per game

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
		if GetConVar("psw_musket"):GetBool() then ply:Give("weapon_musket") end
		if GetConVar("psw_pistol"):GetBool() then ply:Give("weapon_ppistol") end
		if GetConVar("psw_sabre"):GetBool() then ply:Give("weapon_sword") end
		if GetConVar("psw_grenade"):GetBool() then ply:Give("weapon_grenade") end
		ply:CrosshairEnable()
	end
end

function GM:Think()
	for k,v in pairs(player.GetAll()) do
		if v:Alive() and v:Team() ~= TEAM_SPECTATOR then
			if v:WaterLevel() then
				local damage = 2 * v:WaterLevel() * (CurTime() - lastThink)
				v.Temp = v.Temp = damage
				if v.Temp < 70 then
					v:SetHealth(v:Health() - damage)
				end
				else
					v.Temp = v.Temp + 4 * (CurTime() - lastThink)
				end
			end
		end
	end
	lastThink = CurTime()

	if not shipsSpawned then
		spawnShips()
		shipsSpawned = true
	end
end

-- NOTE: override this function if you want to use a custom map cycle (GLMVS, ULX, etc)
-- This function should return true if a map has been chosen, else the vanilla map cycle will be used
function changeMap()
	return false
end

function changeTeam(ply, cmd, args, str)
	if not canSpawn then
		ply:PrintMessage(HUD_PRINTTALK, "You can't change your team right now!")
	elseif not args[0] or not team.Valid(args[0]) then
		ply:PrintMessage(HUD_PRINTTALK, "Invalid team!")
	else
		ply:SetTeam(args[0])
		ply:KillSilent()
	end
end
concommand.Add("changeteam", changeTeam)

function playerTalk(msg)
	if not msg then return end
	local msgstring = tostring(msg)
	for o, k in pairs(player.GetAll()) do
		k:PrintMessage(HUD_PRINTTALK, msgstring)
	end
end

function ents.GetByName(name, returnent)
	if returnent then return ents.FindByName(name)[1] end
	return ents.FindByName(name)[1]:GetPhysicsObject()
end

function team.GetOpposing(t)
	if t == TEAM_BLUE then return TEAM_RED else return TEAM_BLUE end
end