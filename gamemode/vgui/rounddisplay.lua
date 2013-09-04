RoundDisplay = {}
RoundDisplay.Teams = {}
RoundDisplay.Teams[TEAM_RED] = {wins = 2}
RoundDisplay.Teams[TEAM_BLUE] = {wins = 1}
RoundDisplay.RoundStart = 0

function RoundDisplay.DrawDisplay()
	local w = ScrW()
	draw.RoundedBox(4, (w / 2) - 50, -4, 100, 50, Color(150, 150, 150, 255))
	local timeSince = CurTime() - RoundDisplay.RoundStart
	local minutes = math.floor(timeSince / 60)
	local seconds = math.floor(timeSince - minutes * 60)
	if seconds < 10 then seconds = "0" .. seconds end
	if minutes < 10 then minutes = "0" .. minutes end
	draw.SimpleText(minutes .. ":" .. seconds, "pswLarge", w / 2, 14, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	local redText = RoundDisplay.Teams[TEAM_RED].wins .. " win"
	local blueText = RoundDisplay.Teams[TEAM_BLUE].wins .. " win"
	local redSingleModifier = 13
	local blueSingleModifier = 13
	if RoundDisplay.Teams[TEAM_RED].wins ~= 1 then 
		redText = redText .. "s" 
		redSingleModifier = 0
	end
	if RoundDisplay.Teams[TEAM_BLUE].wins ~= 1 then 
		blueText = blueText .. "s" 
		blueSingleModifier = 0
	end
	surface.SetFont("pswMedium")
	local redWidth = surface.GetTextSize(redText)
	local blueWidth = surface.GetTextSize(blueText)
	draw.SimpleText(redText, "pswMedium", w / 2 - redWidth - redSingleModifier, 30, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText(blueText, "pswMedium", w / 2 + blueWidth + blueSingleModifier, 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

usermessage.Hook("PSWRoundUpdate", function(data)
	RoundDisplay.Teams[TEAM_RED].wins = data:ReadLong()
	RoundDisplay.Teams[TEAM_BLUE].wins = data:ReadLong()
	RoundDisplay.RoundStart = data:ReadLong()
end)