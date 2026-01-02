-- DDC OMG generated script, PLACE IT SERVER-SIDE

function omg_move()
  omg8211 = createObject(3117, 3094.8000488281, -2039.8000488281, 19.10000038147, 0, 0, 344.5)
  omgMoveomg8211(1)
  omg8862 = createObject(3117, 3121.8000488281, -2024.4000244141, 19.10000038147, 0, 0, 74.5)
  omgMoveomg8862(1)
end

function omgMoveomg8211(point)
  if point == 1 then
    moveObject(omg8211, 7000, 3094.8000488281, -2039.8000488281, 35.099998474121, 0, 0, 0)
    setTimer(omgMoveomg8211, 7000+500, 1, 2)
  elseif point == 2 then
    moveObject(omg8211, 7000, 3094.8000488281, -2039.8000488281, 19.10000038147, 0, 0, 0)
    setTimer(omgMoveomg8211, 7000+500, 1, 1)
  end
end

function omgMoveomg8862(point)
  if point == 1 then
    moveObject(omg8862, 7000, 3121.8000488281, -2024.4000244141, 35.200000762939, 0, 0, 0)
    setTimer(omgMoveomg8862, 7000+500, 1, 2)
  elseif point == 2 then
    moveObject(omg8862, 7000, 3121.8000488281, -2024.4000244141, 19.10000038147, 0, 0, 0)
    setTimer(omgMoveomg8862, 7000+500, 1, 1)
  end
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), omg_move)