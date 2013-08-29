TeamSelect = {}

function TeamSelect.ShowMenu()
	Msg("Team select")
	if TeamSelect.MenuVisible then 
		TeamSelect.Menu:SetVisible(false)
		TeamSelect.Menu = nil
		TeamSelect.MenuVisible = false
		return
	end
	if not PSW.CanSpawn then
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can't change your team right now!")
		return
	end
	TeamSelect.MenuVisible = true
	TeamSelect.Menu = vgui.Create("Panel")
	TeamSelect.Menu:SetSize(1024, 1024)
	TeamSelect.Menu:Center()
	function TeamSelect.Menu:Paint(w, h)
		local texture = surface.GetTextureID('gui/teamselect')
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetTexture(texture)
		local x, y = TeamSelect.Menu:GetPos()
		surface.DrawTexturedRect(x, y, w, h)
	end
	local redModelPanel = vgui.Create("DModelPanel")
	redModelPanel:SetModel("models/player/pirate/pirate_redd.mdl")
	redModelPanel:SetParent(TeamSelect.Menu)
	redModelPanel:SetSize(315, 460)
	redModelPanel:SetPos(184, 323)
	local blueModelPanel = vgui.Create("DModelPanel")
	blueModelPanel:SetModel("models/player/pirate/pirate_blue.mdl")
	blueModelPanel:SetParent(TeamSelect.Menu)
	blueModelPanel:SetSize(315, 460)
	blueModelPanel:SetPos(526, 323)
	TeamSelect.Menu:SetVisible(true)
	TeamSelect.Menu:Show()
end