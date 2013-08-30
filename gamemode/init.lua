AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("explosion.lua")

AddCSLuaFile("vgui/hud.lua")
AddCSLuaFile("vgui/teamselect.lua")

TEAM_RED = 1
TEAM_BLUE = 2

PSW = {}
PSW.CanSpawn = false
PSW.ShipsSpawned = false
PSW.Starting = false

CreateConVar("psw_musket", 1, FCVAR_NOTIFY)
CreateConVar("psw_pistol", 1, FCVAR_NOTIFY)
CreateConVar("psw_sabre", 1, FCVAR_NOTIFY)
CreateConVar("psw_grenade", 1, FCVAR_NOTIFY)
CreateConVar("psw_nodoors", 0, FCVAR_NOTIFY)
CreateConVar("psw_rounds", 5, FCVAR_NOTIFY) --rounds per game

include("ship.lua")
include("rounds.lua")
include("shared.lua")

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	ply:PrintMessage(HUD_PRINTTALK, "Seeing errors? Need help? Press F1. Change team? Press F2")
end

function GM:PlayerLoadout(ply)
	ply.Temp = 98.6
	if ply:Team() == TEAM_SPECTATOR then
		GAMEMODE:PlayerSpawnAsSpectator(ply)
		ply:CrosshairDisable()
	else
		if GetConVar("psw_musket"):GetBool() then ply:Give("weapon_musket") end
		if GetConVar("psw_pistol"):GetBool() then ply:Give("weapon_ppistol") end
		if GetConVar("psw_sabre"):GetBool() then ply:Give("weapon_sabre") end
		if GetConVar("psw_grenade"):GetBool() then ply:Give("weapon_grenade") end
		ply:CrosshairEnable()
	end
end

function GM:PlayerSelectSpawn(ply)
	if ply.spectating then return end --player is spectating by choice, don't kill
	ply:UnSpectate()
	local numBlue = team.NumPlayers(TEAM_BLUE)
	local numRed = team.NumPlayers(TEAM_RED)
	if ply:Team() == TEAM_SPECTATE then
		if numBlue == numRed then
			ply:SetTeam(TEAM_RED)
		elseif numBlue > numRed then
			ply:SetTeam(TEAM_RED)
		else
			ply:SetTeam(TEAM_BLUE)
		end
		ply:Spectate(0) --reset spectate camera
		ply:UnSpectate()
	end

	if numBlue > numRed + 1 then
		ply:SetTeam(TEAM_RED)
	else
		ply:SetTeam(TEAM_BLUE)
	end

	local spawnEnts
	if ply:Team() == TEAM_BLUE then
		spawnEnts = ents.FindByClass("info_player_deathmatch")
	else
		spawnEnts = ents.FindByClass("info_player_start")
	end

	local count = #spawnEnts
	local nearest
	if not count then return ply end

	local chosen = false

	return spawnEnts[math.random(#spawnEnts)] -- get a random spawn point
end

local lastThink
function GM:Think()
	lastThink = lastThink or CurTime()
	for k,v in pairs(player.GetAll()) do
		if v:Alive() and v:Team() ~= TEAM_SPECTATOR then
			if v:WaterLevel() then
				local damage = 2 * v:WaterLevel() * (CurTime() - lastThink)
				v.Temp = v.Temp - damage
				if v.Temp < 70 then
					v:SetHealth(v:Health() - damage)
				else
					v.Temp = v.Temp + 4 * (CurTime() - lastThink)
				end
			end
		end
	end
	lastThink = CurTime()

	if not PSW.ShipsSpawned then
		Ships.SpawnShips()
		PSW.ShipsSpawned = true
	end
end

-- NOTE: override this function if you want to use a custom map cycle (GLMVS, ULX, etc)
-- This function should return true if a map has been chosen, else the vanilla map cycle will be used
function PSW.ChangeMap()
	return false
end
hook.Add("PSWChangeMap", "pswChangeMap", PSW.ChangeMap)

function PSW.ChangeTeam(ply, t)
	if not PSW.CanSpawn then
		ply:PrintMessage(HUD_PRINTTALK, "You can't change your team right now!")
	elseif not t or not team.Valid(t) then
		ply:PrintMessage(HUD_PRINTTALK, "Invalid team!")
	elseif t == TEAM_RED or t == TEAM_BLUE then
		local numRed = team.NumPlayers(TEAM_RED)
		local numBlue = team.NumPlayers(TEAM_BLUE)
		if numRed > numBlue and t == TEAM_RED then
			ply:PrintMessage(HUD_PRINTTALK, "There are too many players on that team!")
		elseif numBlue < numRed and t == TEAM_BLUE then
			ply:PrintMessage(HUD_PRINTTALK, "There are too many players on that team!")
		else
			ply.spectating = false
			ply:SetTeam(t)
			ply:KillSilent()
			ply:AddDeaths(-1)
			ply:PrintMessage(HUD_PRINTTALK, "Switching to "..PSW.ShipData[t].name.." team")
		end
	else
		ply.spectating = true --spectating by choice
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SetTeam(t)
		ply:KillSilent()
		ply:AddDeaths(-1)
		ply:PrintMessage(HUD_PRINTTALK, "Switching to spectator")
	end
end

local function changeTeam(ply, cmd, args, str)
	PSW.ChangeTeam(ply, args[0])
end
concommand.Add("changeteam", changeTeam)

local function handleChatCommands(ply, msg, public)
	local text = string.Explode(" ", msg)
	if text[1] == "!switch" and text[2] ~= nil then
		ply:ConCommand("changeteam "..text[2])
		return ""
	end
end
hook.Add("PlayerSay", "chatCommands", handleChatCommands)

local function enableSpawn()
	canSpawn = true
	for k,v in pairs(player.GetAll()) do
		v:KillSilent()
		v:AddDeaths(-1)
	end
end
timer.Simple(4, enableSpawn)

function player.BroadcastMessage(msg)
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

function ents.GetOwner(ent, isString)
	if isString then
		entstring = ent
	else
		entstring = ent:GetName()
	end
	if string.find(entstring, "ship1") or string.find(entstring, "s1") then
		return TEAM_RED
	elseif string.find(entstring, "ship2") or string.find(entstring, "s2") then
		return TEAM_BLUE
	end
end

function team.GetOpposing(t)
	if t == TEAM_BLUE then return TEAM_RED else return TEAM_BLUE end
end