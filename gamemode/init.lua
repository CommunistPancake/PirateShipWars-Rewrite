AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local canSpawn = false
local lastThink = CurTime()
local shipsSpawned = false

ShipData = {}
ShipData[TEAM_RED] = {}
ShipData[TEAM_BLUE] = {}

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

local function changeTeam(ply, cmd, args, str)
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

local function spawnShips()

end

