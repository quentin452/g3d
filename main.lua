-- written by groverbuger for g3d
-- september 2021
-- MIT license
PROF_CAPTURE = true
prof = require("jprofiler/jprof")

local g3d = require "g3d"
local earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {4,0,0})
local moon = g3d.newModel("assets/sphere.obj", "assets/moon.png", {4,5,0}, nil, 0.5)
local background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", nil, nil, 500)
local timer = 0

function love.update(dt)
    prof.push("frame")
    prof.push("MainUpdate")
    love.filesystem.setIdentity("G3D")
    timer = timer + dt
    moon:setTranslation(math.cos(timer)*5 + 4, math.sin(timer)*5, 0)
    moon:setRotation(0, 0, timer - math.pi/2)
    g3d.camera.firstPersonMovement(dt)
    if love.keyboard.isDown "escape" then
        love.event.push "quit"
    end
    prof.pop("MainUpdate")
    prof.pop("frame")
end

function love.draw()
    prof.push("frame")
    prof.push("MainDraw")
    earth:draw()
    moon:draw()
    background:draw()
    prof.pop("MainDraw")
    prof.pop("frame")
end

function love.mousemoved(x,y, dx,dy)
    prof.push("frame")
    prof.push("Mainmousemoved")
    g3d.camera.firstPersonLook(dx,dy)
    prof.pop("Mainmousemoved")
    prof.pop("frame")
end

function love.quit()
	prof.write("prof.mpack")
end
