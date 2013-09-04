include("shared.lua")
include("explosion.lua")
include("vgui/teamselect.lua")
include("vgui/hud.lua")

PSW = {}
PSW.Ships = {}
PSW.Ships[TEAM_RED] = {health = 0}
PSW.Ships[TEAM_BLUE] = {health = 0}

function GM:ShowTeam()
	TeamSelect.ShowMenu()
end

function GM:EntityTakeDamage(ent, info)
	local caller = info:GetInflictor()
	local attacker = info:GetAttacker()
	local amount = info:GetDamage()
	if ent:IsPlayer() then return false end
	
	if attacker:IsPlayer() and string.find(ent:GetName(), "ship") then
		if attacker:Team() == TEAM_RED and string.find(ent:GetName(), "ship1") then return false end
		if attacker:Team() == TEAM_BLUE and string.find(ent:GetName(), "ship2") then return false end
		if ent:GetClass() ~= "prop_physics_multiplayer" and ent:GetClass() ~= "func_breakable" then
			return false
		end
	end
	if string.find(ent:GetName(), "ship") then
		if string.find(ent:GetName(), "ship1") then
			if ent:Health() <= amount then
				PSW.Ships[TEAM_RED].health = PSW.Ships[TEAM_RED].health - ent:Health()
			else
				PSW.Ships[TEAM_RED].health = PSW.Ships[TEAM_RED].health - amount
			end
		else
			if ent:Health() <= amount then
				PSW.Ships[TEAM_BLUE].health = PSW.Ships[TEAM_BLUE].health - ent:Health()
			else
				PSW.Ships[TEAM_BLUE].health = PSW.Ships[TEAM_BLUE].health - amount
			end
		end
	end
end