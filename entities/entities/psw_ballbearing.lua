
AddCSLuaFile()

local BounceSound = Sound( "garrysmod/balloon_pop_cute.wav" )


DEFINE_BASECLASS( "base_anim" )


ENT.PrintName		= "Ball Bearing"
ENT.Author			= "Thomas Hansen"

ENT.Editable			= true
ENT.Spawnable			= true
ENT.AdminOnly			= false
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

-- This is the spawn function. It's called when a client calls the entity to be spawned.
-- If you want to make your SENT spawnable you need one of these functions to properly create the entity
--
-- ply is the name of the player that is spawning it
-- tr is the trace from the player's eyes 
--
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * size
	
	local ent = ents.Create( ClassName )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end




--[[---------------------------------------------------------
   Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	if ( SERVER ) then

		local size = 5;
	
		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( size, "metal_bouncy" )
		self:SetGravity(0.3)
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )

	else 
	
		self.LightColor = Vector( 0, 0, 0 )
	
	end
	
end

if ( CLIENT ) then

local matBall = Material( "sprites/sent_ball" )

function ENT:Draw()
	
	local pos = self:GetPos()
	local vel = self:GetVelocity()

	render.SetMaterial( matBall )
	
	local lcolor = render.ComputeLighting( self:GetPos(), Vector( 0, 0, 1 ) )
		
	render.DrawSprite( pos, 5, 5, Color( 58, 58, 58, 255 ) )
	
end

end


--[[---------------------------------------------------------
   Name: PhysicsCollide
-----------------------------------------------------------]]
function ENT:PhysicsCollide( data, physobj )
	
	-- Play sound on bounce
	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then

		sound.Play( BounceSound, self:GetPos(), 75, math.random( 90, 120 ), math.Clamp( data.Speed / 150, 0, 1 ) )

	end
	
	-- Bounce like a crazy bitch
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * 0.9
	
	physobj:SetVelocity( TargetVelocity )
	
end


--[[---------------------------------------------------------
   Name: Use
-----------------------------------------------------------]]
function ENT:Use( activator, caller )

	self:Remove()
	
	if ( activator:IsPlayer() ) then
	
		-- Give the collecting player some free health
		local health = activator:Health()
		activator:SetHealth( health + 5 )
		activator:SendLua( "achievements.EatBall()" );
		
	end

end
