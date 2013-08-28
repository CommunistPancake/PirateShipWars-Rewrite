HUD = {}
HUD.Items = {}

function HUD.Hide(name)
	for k,v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
		if name == v then return false end
	end
end

function HUD.Draw()
	if LocalPlayer():Team() == TEAM_SPECTATOR then
		return
	end
	for k, v in pairs(HUD.Items) do
		v()
	end
end

function HUD.Initialize()
	surface.CreateFont("pswXLarge", {
		font = "Treasure Map Deadhand",
		size = 72
	})
	surface.CreateFont("pswLarge", {
		font = "Treasure Map Deadhand",
		size = 48
	})
	surface.CreateFont("pswMedium", {
		font = "Treasure Map Deadhand",
		size = 36
		})
	surface.CreateFont("pswSmall", {
		font = "Treasure Map Deadhand",
		size = 20
		})
end

local function drawAmmoHUD()
	local activeWeapon = LocalPlayer():GetActiveWeapon()
	if not activeWeapon or not activeWeapon:IsValid() then return false end
	surface.SetFont("pswXLarge")
	local largeAmmoWidth = surface.GetTextSize("99")
	local largeAmmoHeight = draw.GetFontHeight("pswXLarge")
	local mediumAmmoHeight = draw.GetFontHeight("pswMedium")
	local ammoCount = 0
	if activeWeapon:GetPrimaryAmmoType() ~= nil then
		ammoCount = LocalPlayer():GetAmmoCount(activeWeapon:GetPrimaryAmmoType())
	end
	draw.SimpleText(activeWeapon:Clip1(),
		"pswXLarge",
		surface.ScreenWidth() - largeAmmoWidth - 5,
		surface.ScreenHeight() - largeAmmoHeight,
		Color(0, 0, 0, 255),
		TEXT_LEFT_ALIGN,
		TEXT_LEFT_ALIGN)
	draw.SimpleText(ammoCount,
		"pswMedium",
		surface.ScreenWidth() - largeAmmoWidth * 2 + 14,
		surface.ScreenHeight() - mediumAmmoHeight - 11,
		Color(96, 38, 0, 255),
		TEXT_LEFT_ALIGN,
		TEXT_LEFT_ALIGN)
	draw.SimpleText(ammoCount,
		"pswMedium",
		surface.ScreenWidth() - largeAmmoWidth * 2 + 15,
		surface.ScreenHeight() - mediumAmmoHeight - 10,
		Color(125, 80, 50, 255),
		TEXT_LEFT_ALIGN,
		TEXT_LEFT_ALIGN)
end

local function drawHealthHUD()
	local health = LocalPlayer():Health()
	surface.SetFont("pswLarge")
	local healthWidth = surface.GetTextSize("Health")
	local largeHeight = draw.GetFontHeight("pswLarge")
	local mediumHeight = draw.GetFontHeight("pswMedium")
	draw.SimpleText("Health",
		"pswLarge",
		15,
		surface.ScreenHeight() - largeHeight - 5,
		Color(0, 0, 0, 255),
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_LEFT)
	draw.SimpleText(health,
		"pswMedium",
		15 + healthWidth + 14,
		surface.ScreenHeight() - mediumHeight - 11,
		Color(96, 38, 0, 255),
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_LEFT)
	draw.SimpleText(health,
		"pswMedium",
		15 + healthWidth + 15,
		surface.ScreenHeight() - mediumHeight - 10,
		Color(125, 80, 50, 255),
		TEXT_ALIGN_LEFT,
		tEXT_ALIGN_LEFT)
end

table.insert(HUD.Items, drawAmmoHUD)
table.insert(HUD.Items, drawHealthHUD)

hook.Add("HUDShouldDraw", "hideHud", HUD.Hide)
hook.Add("HUDPaint", "drawHud", HUD.Draw)
hook.Add("Initialize", "initializeHud", HUD.Initialize)