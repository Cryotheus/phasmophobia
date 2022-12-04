--locals
--local default_texture = "effects/flashlight001"
local default_texture = "effects/flashlight/hard"
local entity_meta = FindMetaTable("Entity")

--local tables
local key_value_methods = {
	EnableShadows = "enableshadows",
	FarZ = "farz",
	FOV = "lightfov", --self.flashlight:Input( "FOV", NULL, NULL, tostring( math.Clamp( self:GetLightFOV(), 10, 170 ) ) )
	NearZ = "nearz",
}

local LAMP = {Brightness = 1}

--globals
GM.EntityLampMethods = LAMP

--lamp methods
function LAMP:GetBrightness() return self.Brightness end
function LAMP:GetColor() return self.Color end
function LAMP:GetTexture() return self.Texture end

function LAMP:InputTexture(texture)
	self.Texture = texture
	
	self:Input("SpotlightTexture", NULL, NULL, texture)
end

function LAMP:SetBrightness(brightness)
	self.Brightness = brightness
	
	self:SetColor(self.Color)
end

function LAMP:SetColor(color)
	local brightness = self.Brightness
	self.Color = color
	
	self:SetKeyValue("lightcolor", string.format("%i %i %i 255", color.r * brightness, color.g * brightness, color.b * brightness))
end

function LAMP:SetTexture(texture) self.Texture = texture end

function LAMP:Spawn()
	self.Spawned = true
	self.SetTexture = self.InputTexture
	
	entity_meta.Spawn(self)
	self:InputTexture(self.Texture or default_texture)
end

--gamemode functions
function GM:EntityLampCreate()
	local lamp = ents.Create("env_projectedtexture")
	
	for key, value in pairs(LAMP) do lamp[key] = value end
	
	lamp:SetColor(color_white)
	lamp:SetEnableShadows(1)
	lamp:SetFarZ(512)
	lamp:SetFOV(60)
	lamp:SetNearZ(12)
	
	return lamp
end

--post
for name, key in pairs(key_value_methods) do
	LAMP["Get" .. name] = function(self) return self[name] end
	LAMP["Set" .. name] = function(self, value) self:SetKeyValue(key, value) end
end