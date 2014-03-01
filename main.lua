local w = love.graphics.getWidth()
local h = love.graphics.getHeight()

local radius, ldraw, level, phase = h/4, 1, 6, math.pi*2
local scale = 3
local z =  2
local pscale = scale

colors = {
    circle = {128, 16, 32, 255},
    line = {255, 255, 255, 255},
    func = {217, 91, 67, 255},
    sine = {84, 36, 55, 255}
}

fourier = {}
siny = {h/2}
sinx = {w}
sinusoid = {}

function genfourier(phase)
    local px, py = w/2, h/2
    local i, a= 1, 1
    local n, l, f = 1, 1, 1

    while i<=level+1 do
        if i == 1 then
            fourier[i]   = px 
            fourier[i+1] = py 
        else
            fourier[i]   = px + (radius/(2*a-1))*math.cos(phase*(2*a-1))
            fourier[i+1] = py + (radius/(2*a-1))*math.sin(phase*(2*a-1))
            px = px + (radius/(2*a-1))*math.cos(phase*(2*a-1))
            py = py + (radius/(2*a-1))*math.sin(phase*(2*a-1))
            a = a + 1
        end

        i = i + 2
    end

    if scale ~= 0 then
        for n=2,z do
            if sinx[n] ~= nil then
                sinx[n] = sinx[n] + 1
            else
                sinx[n] = 1
            end
        end
    
        siny[z] = py
        z = z + 1
     
        --actually generate the wave
        while siny[f] ~= nil do
            sinusoid[l] = sinx[f]
            sinusoid[l+1] = siny[f]
            l=l+2
            f = f+1
        end
    end

    -- clean out fourier array if the level is decremented
    while fourier[i] ~= nil do
        fourier[i] = nil
        i = i + 1
    end
end

function love.update(dt)
    phase = phase + dt * scale
    genfourier(phase)
end

function love.draw()
    love.graphics.setColor(colors.line)
    love.graphics.print("Press up/down to increment/decrement the number of sinewaves", 0, 0)
    love.graphics.print("Press right/left to dilate time, space to pause", 0, 15)
    love.graphics.print("Press L to hide/show the sumline", 0, 30)

    love.graphics.line(fourier)
    love.graphics.setColor(colors.sine)
    love.graphics.line(sinusoid)

    local a, b = 1, 1

    love.graphics.setColor(colors.circle)
    while fourier[a+2] ~= nil do
        love.graphics.circle("line", fourier[a], fourier[a+1], radius/(2*b-1))
        a = a + 2
        b = b + 1
    end

    if ldraw == 1 then
        love.graphics.setColor(colors.func)
        love.graphics.line(fourier[a], fourier[a+1], 0, fourier[a+1])
    end
end


function love.keypressed(key)
    if key == "up" then
        if level <= 25 then
            level = level + 2;
        end
    end
    
    if key == "down" then
        if level > 3 then
            level = level - 2;
        end
    end
    if key == "right" then 
        if scale < 5 then
            scale = scale + .25
        end
    end
    if key == "left" then
        if scale > 0 then
           scale = scale - .25
        end
    end
    if key == " " then
        if scale > 0 then
            pscale = scale
            scale = 0
        else
            scale = pscale
        end
    end
    if key == "l" then ldraw = (ldraw+1)%2 end
    if key == "rctrl" then debug.debug() end
end
