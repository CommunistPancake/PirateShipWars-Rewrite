if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName 		= "Musket"
SWEP.Author 		= "Thomas Hansen" -- Your name 
 
SWEP.ViewModelFOV 	= 64 -- How much of the weapon do you see? 
SWEP.ViewModel				= "models/brownbess/v_brownbess.mdl"
SWEP.WorldModel				= "models/brownbess/w_brownbess.mdl"

SWEP.Slot 			= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos = 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6) 
 
SWEP.HoldType = "Pistol" -- How is the SWEP held? (Pistol SMG Grenade Melee) 
SWEP.FiresUnderwater = false -- Does your SWEP fire under water?
SWEP.Weight = 5 -- Set the weight of your SWEP. 
SWEP.DrawCrosshair = false 
SWEP.DrawAmmo = true -- Does the ammo show up when you are using it? True / False 
 
--SWEP.ReloadSound = "sound/owningyou.wav"
SWEP.base = "weapon_base" --What your weapon is based on.
--General settings\\
 
--PrimaryFire Settings\\ 
SWEP.Primary.Sound = "sound/weapon/musket.mp3" -- The sound that plays when you shoot your SWEP :-] 
SWEP.Primary.Damage = 1000 -- How much damage the SWEP will do.
SWEP.Primary.TakeAmmo = 1 -- How much ammo does the SWEP use each time you shoot?
SWEP.Primary.ClipSize = 100 -- The clip size.
SWEP.Primary.Ammo = "Pistol" -- The ammo used by the SWEP. (pistol/smg1) 
SWEP.Primary.DefaultClip = 100 -- How much ammo do you get when you first pick up the SWEP? 
SWEP.Primary.Spread = 0.1 -- Do the bullets spread all over when firing? If you want it to shoot exactly where you are aiming, leave it at 0.1 
SWEP.Primary.NumberofShots = 1 -- How many bullets the SWEP fires each time you shoot. 
SWEP.Primary.Automatic = false -- Is the SWEP automatic?
SWEP.Primary.Recoil = 10 -- How much recoil does the weapon have?
SWEP.Primary.Delay = 3 -- How long must you wait before you can fire again?
SWEP.Primary.Force = 1000 -- The force of the shot.
--PrimaryFire settings\\
 
--Secondary Fire Variables\\ 
SWEP.Secondary.NumberofShots = 1 -- How many explosions for each shot.
SWEP.Secondary.Force = 1000 -- The force of the explosion.
SWEP.Secondary.Spread = 0.1 -- How much of an area does the explosion affect? 
SWEP.Secondary.Sound = "sound/ultrakill.wav" -- The sound that is made when you shoot.
SWEP.Secondary.DefaultClip = 100 -- How much secondary ammo does the SWEP come with?
SWEP.Secondary.Automatic = false -- Is it automactic? 
SWEP.Secondary.Ammo = "Pistol" -- Leave as Pistol! 
SWEP.Secondary.Recoil = 10 -- How much recoil does the secondary fire have?
SWEP.Secondary.Delay = 3 -- How long you have to wait before firing another shot?
SWEP.Secondary.TakeAmmo = 1 -- How much ammo does each shot take?
SWEP.Secondary.ClipSize = 100 -- The size of the clip for the secondary ammo.
SWEP.Secondary.Damage = 1000 -- The damage the explosion does. 
SWEP.Secondary.Magnitude = "175" -- How big is the explosion ? 
--Secondary Fire Variables\\
 
--SWEP:Initialize\\ 
function SWEP:Initialize() --Tells the script what to do when the player "Initializes" the SWEP.
	util.PrecacheSound(self.Primary.Sound) 
	util.PrecacheSound(self.Secondary.Sound) 
        self:SetWeaponHoldType( self.HoldType )
end 
--SWEP:Initialize\\
 
--SWEP:PrimaryFire\\ 
function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
 
	local ball = ents.Create("psw_ballbearing")
	ball:SetPos( self.Owner:GetShootPos() )
	ball:SetAngles(self.Owner:GetAimVector())
	ball:SetOwner( self.Owner )
	ball:Spawn()
	ball:Activate()
	ball:GetPhysicsObject():SetVelocity(self.Entity:GetForward() * 9000)
end 
--SWEP:PrimaryFire\\
 
--SWEP:SecondaryFire\\ 
function SWEP:SecondaryAttack() 
	return --Ironsights?
end 
--SWEP:SecondaryFire\\