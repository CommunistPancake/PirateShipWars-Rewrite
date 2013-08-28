ShipData = {}
ShipData[TEAM_RED] = {}
ShipData[TEAM_RED].name = "Red"
ShipData[TEAM_RED].countdown = 35
ShipData[TEAM_BLUE] = {}
ShipData[TEAM_BLUE].name = "Blue"
ShipData[TEAM_BLUE].countdown = 35

MastsBroken = {}

function spawnShips()
	for k, v in pairs(ents.FindByName("spawnbutton")) do
		v:Fire("Press", "", 0)
	end
	ShipData[TEAM_RED].sinking = false
	ShipData[TEAM_RED].disabled = false
	ShipData[TEAM_BLUE].sinking = false
	ShipData[TEAM_BLUE].disabled = false
	starting = true

	timer.Simple(4, getShipParts)
	timer.Simple(30, function() starting = true end)
end

function getShipParts()
	for v = 1, 2 do
		ShipData[v][3] = ents.GetByName("ship" .. v .. "bottom2left");
		ShipData[v][4] = ents.GetByName("ship" .. v .. "bottom2right");
		ShipData[v][5] = ents.GetByName("ship" .. v .. "bottom3left");
		ShipData[v][6] = ents.GetByName("ship" .. v .. "bottom3right");
		ShipData[v][8] = ents.GetByName("ship" .. v .. "bottom4right");
		ShipData[v][9] = ents.GetByName("ship" .. v .. "keel2");
		ShipData[v][11] = ents.GetByName("ship" .. v .. "sinker2");

		ShipData[v][13] = ents.GetByName("ship" .. v .. "polefront");
		ShipData[v][14] = ents.GetByName("ship" .. v .. "mastfront");
		ShipData[v][15] = ents.GetByName("ship" .. v .. "mastback");
		ShipData[v][16] = ents.GetByName("ship" .. v .. "door");
		ShipData[v][17] = ents.GetByName("ship" .. v .. "explosive");
		ShipData[v][18] = ents.GetByName("ship" .. v .. "keel");

		ShipData[v][3]:EnableDrag(false);
		ShipData[v][4]:EnableDrag(false);
		ShipData[v][5]:EnableDrag(false);
		ShipData[v][6]:EnableDrag(false);
		ShipData[v][8]:EnableDrag(false);
		ShipData[v][9]:EnableDrag(false);
		ShipData[v][11]:EnableDrag(false);

		ShipData[v][13]:EnableDrag(false);
		ShipData[v][14]:EnableDrag(false);
		ShipData[v][15]:EnableDrag(false);
		ShipData[v][16]:EnableDrag(false);
		ShipData[v][17]:EnableDrag(false);
		ShipData[v][18]:EnableDrag(false);

		ShipData[v][3]:SetMass(40000);
		ShipData[v][4]:SetMass(40000);
		ShipData[v][5]:SetMass(40000);
		ShipData[v][6]:SetMass(40000);
		ShipData[v][8]:SetMass(35000);

		MastsBroken["ship" .. v .. "mastfront"] = false
		MastsBroken["ship" .. v .. "polefront"] = false
		MastsBroken["ship" .. v .. "mastback"] = false

		local barrel = ents.GetByName("ship" .. v .. "explosive", true)
		if barrel:GetModel() == "models/props_c17/oildrum001_explosive.mdl" then
			barrel:SetModel("models/props_c17/woodbarrel001.mdl")
		end

		if GetConVar("psw_nodoors"):GetBool() then
			ents.GetByName("ship" .. v .. "door", true):Remove()
			ents.GetByName("ship" .. v .. "barrelexplode", true):Remove()
			ents.GetByName("ship" .. v .. "explosive", true):Remove()
			ents.GetByName("s" .. v .. "smoke", true):Remove()
		end
	end
end

function detectShipBreakage(ent, info)
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
		if starting then return false end
	end

	local phys = ent:GetPhysicsObject()
	local owner = findPartOwner(ent)

	checkMasts = {"polefront", "mastfront", "mastback"}
	removeEnt = {"weldpolefront", "weldmastfront", "weldpoleback"}
	mastNames = {"polebreak", "mainbreak", "rearbreak"}
	if owner then
		for v = 1, 3 do
			if ent:GetName() == "ship" .. owner .. checkMasts[v] then
				if string.find(caller:GetClass(), "func_physbox") and ents.GetByName("ship" .. owner .. removeEnt[v]) then
					ents.GetByname("ship" .. owner .. removeEnt[v]):Fire("Break", "", 1)
					mastid = "s" .. owner .. mastNames[v]
					mastCheck(mastid, owner)
				end
			end
		end
		if string.find(ent:GetName(), "ship" .. owner .. "explosive") then
			disableShip(owner)
		else string.find(ent:GetName(), "ship") then
			if ent and ent:GetMass() > amount + 5 then
				ent:Setmass(ent:GetMass() - amount)
			else
				ent:SetMass(5)
			end
			checkShipSink(owner)
		end
	end
end
hook.Add("EntityTakeDamage", "detectShipBreakage", detectShipBreakage)

function disableShip(t)
	if not ShipData[t].disabled then
		playerTalk(string.upper(ShipData[t].name) .. " PIRATE SHIP DISABLED")
		ShipData[t].disabled = true
		local thrusters = {"backwardthruster", "forwardthruster", "rightthruster", "leftthruster", "forwardthruster1"}
		for k, v in pairs(thrusters) do
			for i, l in pairs(ents.FindByName("ship" .. t .. v)) do
				l:Remove()
			end
		end
	end
end

function mastCheck(mastid, owner)
	removeMasts = {"polefront", "mastfront", "mastback"}
	mastNames = {"polebreak", "mainbreak", "rearbreak"}
	for v = 1, 3 do
		if mastid == "s" .. owner .. mastNames[v] and not starting then
			ents.GetByName("ship" .. owner .. removeMasts[v]):Fire("Kill", "", 0)
			teamropes = ents.FindByName("ship" .. owner .. "rope")
			for k, v in pairs(teamropes) do
				v:Remove()
			end
		end
	end
end

function checkShipSink(owner)
	if not ShipData[owner].sinking then
		if ShipData[owner][8] ~= nil && ShipData[owner][8]:GetMass() > 9000 then
			ShipData[owner][8]:SetMass(ShipData[owner][8]:GetMass() - 1000)
			if ShipData[owner][11]:GetMass() < 40000 then
				ShipData[owner][11]:SetMass(ShipData[owner][11]:GetMass() + 2000)
			end
		end
		if ShipData[owner][3] ~= nil && ShipData[owner][3]:GetMass() > 2000 then
			ShipData[owner][3]:SetMass(ShipData[owner][3]:GetMass() - 1000)
			ShipData[owner][4]:SetMass(ShipData[owner][4]:GetMass() - 1000)
			ShipData[owner][5]:SetMass(ShipData[owner][5]:GetMass() - 1000)
			ShipData[owner][6]:SetMass(ShipData[owner][6]:GetMass() - 1000)
		else
			shipbarrel(owner)
			if ShipData[owner][3] ~= nil && ShipData[owner][3]:GetMass() > 14000 then
				ShipData[owner][8]:SetMass(1000)
				ShipData[owner][9]:SetMass(25000)
				ShipData[owner][3]:SetMass(ShipData[owner][3]:GetMass() - 1000)
				ShipData[owner][4]:SetMass(ShipData[owner][4]:GetMass() - 1000)
				ShipData[owner][5]:SetMass(1000)
				ShipData[owner][6]:SetMass(1000)
				ShipData[owner][11]:SetMass(15000)
			else
				if not ShipData[opposingTeam(owner)].sinking then
					ShipData[owner].countdown = 35
					ShipData[owner].sinking = true
					sinktimer = timer.Create("SinkTimer", 1, ShipData[owner].countdown, function() sinkingCountdown(owner) end)--timer.Simple(n1, CountDown)
					winner()
				end
			end
		end	
	end
end

function sinkingCountdown(owner)
	if ShipData[owner].countdown == 30 then
		canSpawn = false
	elseif ShipData[owner].countdown == 7 and ShipData[v].sinking then
		for k,v in pairs(player.GetAll()) do
			v:StripWeapons()
			v:Spectate(OBS_MODE_ROAMING)
			v:SetTeam(TEAM_SPECTATE)
			v:CrosshairDisable()
		end
	elseif ShipData[owner].countdown == 5 and ShipData[owner].sinking then
		spawnShips()
	elseif ShipData[owner].countdown == 1 then
		currentRound = currentRound + 1
		if currentRound == GetConVarNumber("psw_rounds") then
			playerTalk("Last round before map change!")
		end
		if currentRound == GetConVarNumber("psw_rounds") + 1 then
			playerTalk("Changing map!")
			Msg("Changing map")
			local changeMap = hook.Call("PSWChangeMap") -- should return true if it exists
			if not changeMap then timer.Simple(1, game.LoadNextMap) end
		end
		team.AddScore(team.GetOpposing(owner), 30)
		timer.Remove("SinkTimer")
		canSpawn = true

		for k,v in pairs(player.GetAll()) do
			v:UnSpectate()
			v:KillSilent()
			v:Respawn()
			v:ConCommand("r_cleardecals")
			v:PrintMessage(HUD_PRINTCENTER, "Sink the enemy pirate ship!")
		end
	end

	ShipData[owner].countdown = ShipData[owner].countdown - 1
	
end

function findPartOwner(ent, isString)
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