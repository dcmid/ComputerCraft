-- Dcmid's Room Builder

-- Depends on trackMove

-- Make entries relative to turtle's position.
--   The X direction runs from the turtle's left to its right
--   The Y direction runs from bedrock to the sky
--   The Z direction runs from behind the turtle through the front of it

os.loadAPI("trackMove")


-- Prompt user for room preferences
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
shouldTurnRight = lrDir == "r"

-- True if all inventory slots are occupied or if fuel is low
function shouldReturn()
  return turtle.getItemCount(16) > 0 or turtle.getFuelLevel() <= math.abs(trackMove.xCoord) + math.abs(trackMove.yCoord) + math.abs(trackMove.zCoord)
end

-- Return turtle to program start location
function returnToOrigin()
  trackMove.gotoY(0)
  trackMove.gotoX(0)
  trackMove.gotoZ(0)
  return true
end

-- Empty inventory into chest in front of turtle. False if chest is full
function chestDump()
  iSucc, block = turtle.inspect()
  if iSucc and (block.name == "mincraft.chest" or block.name == "IronChest:BlockIronChest") then
    for i = 1, 16 do
      turtle.select(i)
      if turtle.getItemCount() ~= 0 then
        if not turtle.drop() then
          print("Chest full")
          return false
        end
      end
    end
  end
  turtle.select(1)
  return true
end

turtle.select(1)
for i = 1, height do
  for j = 1, width do
    for k = 1, depth - 1 do
      if shouldReturn() then
        tempX = trackMove.xCoord
        tempY = trackMove.yCoord
        tempZ = trackMove.zCoord
        tempO = trackMove.orientation
        print(tempX .. ", " .. tempY .. ", " .. tempZ .. ", " .. tempO)
        returnToOrigin()
        print(trackMove.xCoord .. ", " .. trackMove.yCoord .. ", " .. trackMove.zCoord .. ", " .. trackMove.orientation)
        if not chestDump() then
          return
        end
        print(trackMove.xCoord .. ", " .. trackMove.yCoord .. ", " .. trackMove.zCoord .. ", " .. trackMove.orientation)
        trackMove.gotoX(tempX)
        trackMove.gotoY(tempY)
        trackMove.gotoZ(tempZ)
        trackMove.orientTo(tempO)
      end
      trackMove.mine()
      if trackMove.orientation ~= 0 and trackMove.orientation ~= 2 then
        print("turtle facing wrong way 1")
        return
      end
    end
    if j ~= width then
      if shouldTurnRight then
        trackMove.turnRight()
        trackMove.mine()
        trackMove.turnRight()
      else
        trackMove.turnLeft()
        trackMove.mine()
        trackMove.turnLeft()
      end
      shouldTurnRight = not shouldTurnRight
    end
  end
  trackMove.turnAround()
  if i < height then
    if udDir == "u" then
      trackMove.up()
    else
      trackMove.down()
    end
  end
end
print("Finished!")
returnToOrigin()
chestDump()
return