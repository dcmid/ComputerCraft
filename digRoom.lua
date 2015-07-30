-- Dcmid's Room Builder

-- Depends on genDig

-- Make entries relative to turtle's position.
--   The X direction runs from the turtle's left to its right
--   The Y direction runs from bedrock to the sky
--   The Z direction runs from behind the turtle through the front of it\n

os.loadAPI("genDig")

xCoord = 0
yCoord = 0
zCoord = 0
--orientation relative to starting position. 0 = forward, 1 = right, 2 = backward, 3 = left
orientation = 0

write("Left or Right (l/r): ")
lrDir = read()
if lrDir ~= "l" and lrDir ~= "r" then
  print("invalid entry")
  error()
end
write("Up or Down (u/d): ")
udDir = read()
if udDir ~= "u" and udDir ~= "d" then
  print("invalid entry")
  error()
end
write("Width (X): ")
width = tonumber(read())
write("Height (Y): ")
height = tonumber(read())
write("Depth (Z): ")
depth = tonumber(read())
turnRight = lrDir == "r"

function shouldReturn()
  return turtle.getItemCount(16) > 0 or turtle.getFuelLevel() <= math.abs(xCoord) + math.abs(yCoord) + math.abs(zCoord)
end

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
  return true
end

function returnToOrigin()
  if yCoord > 0 then
    while yCoord > 0 do
      genDig.down()
      yCoord = yCoord - 1
    end
  elseif yCoord < 0 then
    while yCoord < 0 do
      genDig.up()
      yCoord = yCoord + 1
    end
  end
  if xCoord > 0 then
    orientTo(3)
    while xCoord > 0 do
      genDig.mine()
      xCoord = xCoord - 1
    end
  elseif xCoord < 0 then
    orientTo(1)
    while xCoord < 0 do
      genDig.mine()
      xCoord = xCoord + 1
    end
  end
  orientTo(2)
  while zCoord > 0 do
    genDig.mine()
    zCoord = zCoord - 1
  end
  return true
end

for i = 1, height do
  for j = 1, width do
    for k = 1, depth - 1 do
      if shouldReturn() then
        returnToOrigin()
        return
      end
      genDig.mine()
      if orientation == 0 then
        zCoord = zCoord + 1
      elseif orientation == 2 then
        zCoord = zCoord - 1
      else
        print("turtle facing wrong way 1")
        return
      end
    end
    if j ~= width then
      if turnRight then
        turtle.turnRight()
        adjustOrientation(1)
        genDig.mine()
        if orientation == 1 then
          xCoord = xCoord + 1
        else
          xCoord = xCoord - 1
        end
        turtle.turnRight()
        adjustOrientation(1)
      else
        turtle.turnLeft()
        adjustOrientation(-1)
        genDig.mine()
        if orientation == 1 then
          xCoord = xCoord + 1
        else
          xCoord = xCoord - 1
        end
        turtle.turnLeft()
        adjustOrientation(-1)
      end
      turnRight = not turnRight
    end
  end
  genDig.turnAround()
  adjustOrientation(2)
  if i < height then
    if udDir == "u" then
      genDig.up()
      yCoord = yCoord + 1
    else
      genDig.down()
      yCoord = yCoord - 1
    end
  end
end
print(xCoord)
print(yCoord)
print(zCoord)
returnToOrigin()
