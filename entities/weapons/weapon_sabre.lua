bloody = false

if (CLIENT) then
	SWEP.PrintName		= "Sabre"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	
	killicon.Add("weapon_sabre", "deathnotify/sabre_kill", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("gmod/SWEP/sabre_select")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false

end

SWEP.Spawnable = true
SWEP.HoldType = "melee"

SWEP.AutoSwitchTo = true

SWEP.ViewModel = "models/sabre/v_sabre_a.mdl"
SWEP.WorldModel = "models/sabre/w_sabre.mdl"

SWEP.Primary.Delay = 5
SWEP.Primary.Recoil = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

--Primary function, swing your sword like a pirate!
function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + 0.50)--75
	--Do nothing if you're dead
	if !self.Owner:Alive() then return end
	--Start trace function to find if there is anything within 75 units infront of you
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start +(self.Owner:GetAimVector()*125)
	tr.filter = self.Owner
	local trace = util.TraceLine(tr)
	--Make sure we hit something
	if trace.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			if trace.Entity:IsPlayer() || trace.Entity:IsNPC() then --Hit a person/npc >:D

				if self.Owner:Team() == TEAM_BLUE then
					if bloody then
						self.Owner:GetViewModel():SetModel("models/sabre/v_sab2e.mdl")
					else
						self.Owner:GetViewModel():SetModel("models/sabre/v_sabre.mdl")
					end
				else
					if bloody then
						self.Owner:GetViewModel():SetModel("models/sabre/v_sab22.mdl")
					else
						self.Owner:GetViewModel():SetModel("models/sabre/v_sabr2.mdl")
					end
				end
		end
		self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(3,5)..".wav")	

		bullet = {} --Credit here goes to Feihc for his primary fire script of his lightsaber swep
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 0
		bullet.Damage = 25
		self.Owner:FireBullets(bullet)

	else --We missed :(
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)--misscenter
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:OnDrop()
	self.Weapon:Remove()
end
