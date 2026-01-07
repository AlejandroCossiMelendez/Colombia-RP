-- Clean Camera class

Camera = {}
Camera.__index = Camera

function Camera.new(name, x, y, z, fov, height, interior, dimension)
  local self = setmetatable({}, Camera)
  self.name = name
  self.x, self.y, self.z = x, y, z
  self.height = height
  self.speed = 0.1
  self.radius = 20
  self.angle = 0
  self.fov = fov
  self.int = interior or 0
  self.dim = dimension or 0
  self.func_on_client_render = function()
    self:on_client_render()
  end
  return self
end

function Camera:init()
  if self.int then
    setElementInterior(localPlayer, self.int)
  end
  if self.dim then
    setElementDimension(localPlayer, self.dim)
  end
  removeEventHandler("onClientRender", root, self.func_on_client_render)
  addEventHandler("onClientRender", root, self.func_on_client_render, false)
end

function Camera:deinit()
  removeEventHandler("onClientRender", root, self.func_on_client_render)
end

function Camera:on_client_render()
  self.angle = self.angle + self.speed
  setCameraMatrix(
    self.x + self.radius * math.cos(math.rad(self.angle)),
    self.y + self.radius * math.sin(math.rad(self.angle)),
    self.z + self.height,
    self.x, self.y, self.z,
    0, self.fov
  )
end

function Camera:destroy()
  setCameraTarget(localPlayer)
  removeEventHandler("onClientRender", root, self.func_on_client_render)
  setmetatable(self, nil)
end


