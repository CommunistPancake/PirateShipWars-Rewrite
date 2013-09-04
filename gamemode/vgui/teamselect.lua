TeamSelect = {}

function TeamSelect.ShowMenu()
	if TeamSelect.MenuVisible then 
		TeamSelect.Menu:SetVisible(false)
		TeamSelect.MenuBackground:SetVisible(false)
		TeamSelect.Menu = nil
		TeamSelect.MenuVisible = false
		gui.EnableScreenClicker(false)
		return
	end
	surface.SetDrawColor(255,255,255, 50)
	TeamSelect.MenuVisible = true
	TeamSelect.Menu = vgui.Create("Panel")
	TeamSelect.Menu:SetSize(1024, 1024)
	TeamSelect.Menu:Center()
	local backgroundImage = vgui.Create("DImage")
	backgroundImage:SetImage("gui/teamselect")
	backgroundImage:SizeToContents()
	backgroundImage:Center()
	TeamSelect.MenuBackground = backgroundImage
	local redModelPanel = vgui.Create("DModelPanel")
	redModelPanel:SetModel("models/player/pirate/pirate_redd.mdl")
	redModelPanel:SetParent(TeamSelect.Menu)
	redModelPanel:SetSize(315, 460)
	redModelPanel:SetPos(184, 323)
	redModelPanel:SetAnimated(true)
	function redModelPanel.DoClick()
		RunConsoleCommand("changeteam", "1")
		TeamSelect.ShowMenu() --close
	end
	function redModelPanel:LayoutEntity(ent)
		self:RunAnimation()
		ent:SetAngles(Angle(0, 90, 0))
	end
	local blueModelPanel = vgui.Create("DModelPanel")
	blueModelPanel:SetModel("models/player/pirate/pirate_blue.mdl")
	blueModelPanel:SetParent(TeamSelect.Menu)
	blueModelPanel:SetSize(315, 460)
	blueModelPanel:SetPos(526, 323)
	blueModelPanel:SetAnimated(true)
	function blueModelPanel:LayoutEntity(ent)
		if self:GetAnimated() then self:RunAnimation() end
		ent:SetAngles(Angle(0, 0, 0))
	end
	function blueModelPanel.DoClick()
		RunConsoleCommand("changeteam", "2")
		TeamSelect.ShowMenu()
	end
	TeamSelect.Menu:SetVisible(true)
	TeamSelect.Menu:Show()
	gui.EnableScreenClicker(true)
end
concommand.Add("show_team_menu", TeamSelect.ShowMenu)