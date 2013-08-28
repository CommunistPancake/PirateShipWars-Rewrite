AddCSLuaFile()

ENT.Type = "anim"

function ENT:PhysicsCollide(data,phys)
	if (CLIENT) then
		if data.Speed > 50 then
			self:EmitSound(Sound("HEGrenade.Bounce"))
		end
	end
	if (SERVER) then
		local impulse = -data.Speed * data.HitNormal * .2 + (data.OurOldVelocity * -.4) --.4 .6
		phys:ApplyForceCenter(impulse)
	end
end


function ENT:Initialize()

	if (SERVER) then
		self:SetModel("models/powdergrenade/powdergrenade.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
			
		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	
	self.timer = CurTime() + 3
end

function ENT:Think()
	if self.timer < CurTime() then
		if (SERVER) then
			local range = 512
			local damage = 0
			local pos = self:GetPos()
			local eowner = self.eOwner
			
			self:EmitSound(Sound("weapons/hegrenade/explode"..math.random(3,5)..".wav"))
			self:Remove()
			
			orgin_ents = ents.FindInSphere( pos, 150 )
			for a=1, #orgin_ents do
				if orgin_ents[a]:GetClass() == "player" then
					if ( orgin_ents[a]:Team() != self.eOwner:Team() ) or ( orgin_ents[a] == self.eOwner ) then
						expdmg = 150 - pos:Distance( orgin_ents[a]:GetPos() )
						orgin_ents[a]:TakeDamage( expdmg, eowner )
					end
				end
			end
		end
		if (CLIENT) then
			local pos = self:GetPos()
			Explosion( pos, self:EyeAngles():Forward(), Color( 190, 40, 0, 255 ) );
		end
	end
end
