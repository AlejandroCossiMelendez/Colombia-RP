-- Clean Camera Manager

CameraManager = {}
CameraManager.cameras = {}

function CameraManager:add_new(name, x, y, z, fov, height, interior, dimension, insertAtStart)
  if type(name) ~= "string" then return false end
  if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then return false end
  if type(fov) ~= "number" or type(height) ~= "number" then return false end

  local cam = Camera.new(name, x, y, z, fov, height, interior, dimension)
  if insertAtStart then
    table.insert(CameraManager.cameras, 1, cam)
  else
    table.insert(CameraManager.cameras, cam)
  end
  return cam
end

function CameraManager:get_camera_by_index(index)
  return CameraManager.cameras[index]
end

function CameraManager:get_cameras_count()
  return #CameraManager.cameras
end

function CameraManager:destroy_all()
  for _, cam in ipairs(CameraManager.cameras) do
    cam:destroy()
  end
  CameraManager.cameras = {}
end


