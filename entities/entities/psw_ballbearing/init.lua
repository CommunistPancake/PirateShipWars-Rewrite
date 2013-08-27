AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local physical = self:GetPhysicsObject()
	if (physical:IsValid()) then
		physical:Wake()
	end
end

function ENT:Use( ply, caller )
	return
end