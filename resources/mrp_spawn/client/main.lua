-- Clean client main for Spawn Selector

local activeCamera = nil

function AddCamera(name, x, y, z, fov, height, interior, dimension, insertAtStart)
  if not name or type(name) ~= "string" then return false end
  if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then return false end
  if type(fov) ~= "number" or type(height) ~= "number" then return false end

  local camera = CameraManager:add_new(name, x, y, z, fov, height, interior, dimension, insertAtStart)
  if not camera then return false end
  return camera
end

function SetCamera(cameraIndex)
  if type(cameraIndex) ~= "number" then return false end
  local camera = CameraManager:get_camera_by_index(cameraIndex)
  if not camera then return false end

  if activeCamera then
    activeCamera:deinit()
  end

  activeCamera = camera
  activeCamera:init()
  return activeCamera.name
end

function StopCurrentCamera()
  if not activeCamera then return false end
  activeCamera:deinit()
  activeCamera = nil
  return true
end

addEventHandler("onClientResourceStart", resourceRoot, function()
  if not settings or not settings.spawns then return end
  for _, spawn in ipairs(settings.spawns) do
    CameraManager:add_new(spawn.name, spawn.position[1], spawn.position[2], spawn.position[3], spawn.fov, spawn.height)
  end
end)


