-- written by groverbuger for g3d
-- september 2021
-- MIT license
PROF_CAPTURE = false
_JPROFILER = require("jprofiler/jprof")

local g3d = require "g3d"
local earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {4,0,0})
local moon = g3d.newModel("assets/sphere.obj", "assets/moon.png", {4,5,0}, nil, 0.5)
local background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", nil, nil, 500)
local timer = 0

function love.update(dt)
    _JPROFILER.push("frame")
    _JPROFILER.push("MainUpdate")
    love.filesystem.setIdentity("G3D")
    timer = timer + dt
    moon:setTranslation(math.cos(timer)*5 + 4, math.sin(timer)*5, 0)
    moon:setRotation(0, 0, timer - math.pi/2)
    g3d.camera.firstPersonMovement(dt)
    if love.keyboard.isDown "escape" then
        love.event.push "quit"
    end
    _JPROFILER.pop("MainUpdate")
    _JPROFILER.pop("frame")
end

function love.draw()
    _JPROFILER.push("frame")
    _JPROFILER.push("MainDraw")
    drawF3MainGame()
    earth:draw()
    moon:draw()
    background:draw()
    _JPROFILER.pop("MainDraw")
    _JPROFILER.pop("frame")
end

function love.mousemoved(x,y, dx,dy)
    _JPROFILER.push("frame")
    _JPROFILER.push("Mainmousemoved")
    g3d.camera.firstPersonLook(dx,dy)
    _JPROFILER.pop("Mainmousemoved")
    _JPROFILER.pop("frame")
end

function love.quit()
	_JPROFILER.write("_JPROFILER.mpack")
end


function drawF3MainGame()
	local w = lg3d.getDimensions()

	local camX, camY, camZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
	local fpsText = "FPS: " .. tostring(love.timer.getFPS())

	local coordTextX = w - 150
	local coordTextY = 10

	local fpsTextX = w - 150
	local fpsTextY = 10

	lg3d.setColor(1, 1, 1)

	lg3d.print(fpsText, fpsTextX, fpsTextY)

	lg3d.print("Coordinates :", coordTextX, coordTextY + 20)
	lg3d.print("X: " .. math.floor(camX), coordTextX, coordTextY + 40)
	lg3d.print("Y: " .. math.floor(camY), coordTextX, coordTextY + 60)
	lg3d.print("Z: " .. math.floor(camZ), coordTextX, coordTextY + 80)

	lg3d.print("Cardinal Points :", coordTextX, coordTextY + 100)

	local cardinalPoints = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
	local cameraAngle = math.atan2(g3d.camera.target[2] - camY, g3d.camera.target[1] - camX)
	local index = math.floor((cameraAngle + math.pi / 8) / (math.pi / 4)) % 8 + 1
	local currentCardinalPoint = cardinalPoints[index]

	lg3d.print("Direction : " .. currentCardinalPoint, coordTextX, coordTextY + 120)
end
