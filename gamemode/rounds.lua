Rounds = {}
Rounds.CurrentRound = 1
Rounds.Wins = {}
Rounds.Wins[TEAM_RED] = 0
Rounds.Wins[TEAM_BLUE] = 0
Rounds.StartTime = CurTime()

function Rounds.AnnounceWinner()
	local winner = ""
	if PSW.ShipData[TEAM_RED].sinking then 
		winner = "Red" 
		Rounds.Wins[TEAM_RED] = Rounds.Wins[TEAM_RED] + 1
	else 
		winner = "Blue" 
		Rounds.Wins[TEAM_BLUE] = Rounds.Wins[TEAM_BLUE] + 1
	end
	Rounds.StartTime = CurTime()
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTCENTER, "The "..winner.." Pirates Win!")
		Rounds.UpdatePlayer(v)
	end
end

function Rounds.Cleanup(owner)
	timer.Create("SinkTimer", 1, PSW.ShipData[owner].countdown, function() Rounds.CleanupCountdown(owner) end)
	Rounds.CleanupCountdown(owner)
end

function Rounds.CleanupCountdown(owner)
	if PSW.ShipData[owner].countdown == 30 then
		canSpawn = false
	elseif PSW.ShipData[owner].countdown == 7 and PSW.ShipData[owner].sinking then
		for k,v in pairs(player.GetAll()) do
			v:StripWeapons()
			v:Spectate(OBS_MODE_ROAMING)
			v:SetTeam(TEAM_SPECTATE)
			v:CrosshairDisable()
		end
	elseif PSW.ShipData[owner].countdown == 5 and PSW.ShipData[owner].sinking then
		Ships.SpawnShips()
	elseif PSW.ShipData[owner].countdown == 1 then
		Rounds.CurrentRound = Rounds.CurrentRound + 1
		if Rounds.CurrentRound == GetConVarNumber("psw_rounds") then
			player.BroadcastMessage("Last round before map change!")
		end
		if Rounds.CurrentRound == GetConVarNumber("psw_rounds") + 1 then
			player.BroadcastMessage("Changing map!")
			Msg("Changing map")
			local changeMap = PSW.ChangeMap()
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

	PSW.ShipData[owner].countdown = PSW.ShipData[owner].countdown - 1

	--very confusing if statement
	if PSW.ShipData[owner].sinking then
		if PSW.ShipData[owner][3]:GetMass() > 400 then
			PSW.ShipData[owner][3]:SetMass( PSW.ShipData[owner][3]:GetMass() - 200 )
			PSW.ShipData[owner][4]:SetMass( PSW.ShipData[owner][4]:GetMass() - 200 )
		end	

		PSW.ShipData[owner][8]:SetMass(1000)

		if PSW.ShipData[owner][11]:GetMass() <= 40000 then		
			PSW.ShipData[owner][5]:SetMass(500);
			PSW.ShipData[owner][6]:SetMass(500);
			PSW.ShipData[owner][11]:SetMass( PSW.ShipData[owner][11]:GetMass() + 1000 ); 
		end

		if PSW.ShipData[owner][11]:GetMass() > 40000 then
			PSW.ShipData[owner][5]:SetMass(1000)
			PSW.ShipData[owner][6]:SetMass(1000)
			if PSW.ShipData[owner][9]:GetMass() > 2000 then
				PSW.ShipData[owner][9]:SetMass(PSW.ShipData[owner][9]:GetMass()-1000)
			end
		elseif PSW.ShipData[owner][11]:GetMass() > 49000 then
			PSW.ShipData[owner][10]:SetMass(35000)
			PSW.ShipData[owner][9]:SetMass(2000)
			PSW.ShipData[owner][3]:SetMass(1000)
			PSW.ShipData[owner][4]:SetMass(1000)	
		end
	end
end

function Rounds.UpdatePlayer(ply)
	umsg.Start("PSWRoundUpdate", ply)
		umsg.Long(Rounds.Wins[TEAM_RED])
		umsg.Long(Rounds.Wins[TEAM_BLUE])
		umsg.Long(Rounds.StartTime)
	umsg.End()
end