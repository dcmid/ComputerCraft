os.loadAPI("genDig")

-- API for tracking turtle position.

xCoord = 0
yCoord = 0
zCoord = 0
-- Orientation relative to starting position. 0 = forward, 1 = right, 2 = backward, 3 = left
orientation = 0

function adjustOrientation(change)
  orientation = orientation + change
  if orientation > 3 then
    orientation = orientation - 4
  elseif orientation < 0 then
    orientation = orientation + 4
  end
  return true
end

function orientTo(dir)
  if dir < 0 or dir > 3 then
    print("dir out of bounds")
    error()
  end
  if dir == orientation - 1 or (orientation == 0 and dir == 3) then
    turtle.turnLeft()
    adjustOrientation(-1)
  else
    while orientation ~= dir do
      turtle.turnRight()
      adjustOrientation(1)
    end
  end
  return
end

function down()
  genDig.down()
  yCoord = yCoord - 1
  return
end

function up()
  genDig.up()
  yCoord = yCoord + 1
  return
end

function mine()
  genDig.mine()
  if orientation == 0 then
    zCoord = zCoord + 1
  elseif orientation == 1 then
    xCoord = xCoord + 1
  elseif orientation == 2 then
    zCoord = zCoord - 1
  else
    xCoord = xCoord - 1
  end
  return
end

function mineFor(numBlocks)
  for i = 1, numBlocks do
    genDig.mine()
  end
  if orientation == 0 then
    zCoord = zCoord + numBlocks
  elseif orientation == 1 then
    xCoord = xCoord + numBlocks
  elseif orientation == 2 then
    zCoord = zCoord - numBlocks
  else
    xCoord = xCoord - numBlocks
  end
  return
end

function turnAround()
  genDig.turnAround()
  adjustOrientation(2)
  return
end

function turnRight()
  turtle.turnRight()
  adjustOrientation(1)
  return
end

function turnLeft()
  turtle.turnLeft()
  adjustOrientation(-1)
  return
end

function gotoX(pos)
  if xCoord > pos then
    orientTo(3)
    while xCoord > pos do
      mine()
    end
  elseif xCoord < pos then
    orientTo(1)
    while xCoord < pos do
      mine()
    end
  end
  return
end

function gotoY(pos)
  if yCoord > pos then
    while yCoord > pos do
      down()
    end
  elseif yCoord < pos then
    while yCoord < pos do
      up()
    end
  end
  return
end

function gotoZ(pos)
  if zCoord > pos then
    orientTo(2)
    while zCoord > pos do
      mine()
    end
  elseif zCoord < pos then
    orientTo(0)
    while zCoord < pos do
      mine()
    end
  end
  return
end
