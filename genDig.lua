-- Simple mining functions API

function mine()
  turtle.dig()
  while not turtle.forward() do
    turtle.dig()
  end
  return true
end

function down()
  while not turtle.down() do
    turtle.digDown()
  end
  return true
end

function up()
  while not turtle.up() do
    turtle.digUp()
  end
  return true
end

function mineFor(numBlocks)
  for i = 1, numBlocks do
    mine()
  end
  return true
end

function turnAround()
  turtle.turnRight()
  return turtle.turnRight()
end
