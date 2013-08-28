AddCSLuaFile()

local BounceSound = Sound( "garrysmod/balloon_pop_cute.wav" )

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"


ENT.PrintName		= "Ball Bearing"
ENT.Author			= "Thomas Hansen"

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/

if ( SERVER ) then
	function ENT:Initialize()

		-- Use the helibomb model just for the shadow (because it's about the same size)
		self:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
		
		-- Don't use the model's physics - create a sphere instead
		self:PhysicsInitSphere( 4 )
		
		-- Wake the physics object up. It's time to have fun!
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		-- Set collision bounds exactly
		self:SetCollisionBounds( Vector( -4, -4, -4 ), Vector( 4, 4, 4 ) )
		phys:EnableGravity( false ) --We're going to make our own gravity below cause we're cool

	end


	function ENT:PhysicsUpdate( phys )
		vel = Vector( 0, 0, ( ( -9.81 * phys:GetMass() ) * 0.65 ) )
		phys:ApplyForceCenter( vel )
	end


	function ENT:PhysicsCollide( data, physobj )
		if data.HitEntity:IsPlayer() then
			Msg("bravo")
			data.HitEntity:Kill()
		end
		-- Play sound on bounce
		if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then

			--sound.Play( BounceSound, self:GetPos(), 75, math.random( 90, 120 ), math.Clamp( data.Speed / 150, 0, 1 ) )

		end
		
		-- Bounce like a crazy bitch
		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = physobj:GetVelocity()
		NewVelocity:Normalize()
		NewVelocity = NewVelocity / 2
		
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
		
		local TargetVelocity = NewVelocity * LastSpeed * 0.9
		
		physobj:SetVelocity( TargetVelocity )
		
	end

end

if ( CLIENT ) then

	local matBall = Material( "sprites/sent_ball" )

	/*---------------------------------------------------------
	   Name: Initialize
	---------------------------------------------------------*/
	function ENT:Initialize()

		self.Color = Color( 255, 150, 0, 255 )
		
		self.LightColor = Vector( 0, 0, 0 )

		self:DrawShadow( false )
		
	end

	function ENT:Draw()
		
		self.Color = Color( 255, 150, 0, 255 )
		
		local pos = self:GetPos()
		local vel = self:GetVelocity()
			
		render.SetMaterial( matBall )
		
		render.DrawSprite( pos, 4, 4, Color( 58, 58, 58, 255 ) )
		
	end

end