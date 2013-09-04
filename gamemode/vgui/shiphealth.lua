ShipHealth = {}
ShipHealth.Ships = {}
ShipHealth.Ships[TEAM_RED] = 57
ShipHealth.Ships[TEAM_BLUE] = 32

function ShipHealth.DrawDisplay()
	local w = ScrW()
	local redPercent = ShipHealth.Ships[TEAM_RED] / 100
	local bluePercent = ShipHealth.Ships[TEAM_BLUE] / 100
	--border, for both bars
	draw.RoundedBox(4, 100, 5, w - 200, 15, Color(150, 150, 150, 255))
	--red bar
	local redWidth = (w / 2 - 100) * redPercent
	draw.RoundedBox(4, w / 2 - redWidth - 48, 7, redWidth, 11, Color(191, 0, 0, 255))
	--blue bar
	local blueWidth = (w / 2 - 100) * bluePercent
	draw.RoundedBox(4, w / 2 + 48, 7, blueWidth, 11, Color(0, 0, 255, 255))
end