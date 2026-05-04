local timer = 0

function events.tick()
    -- 1. Stop everything if we are in first person
    if renderer:isFirstPerson() then return end

    local vel = player:getVelocity()
    local isMoving = (vel.x^2 + vel.z^2) > 0.001

    -- 2. Only run the logic if we are standing still
    if not isMoving then
        timer = timer + 0.1
        local pos = player:getPos()
        local radius = 0.7
        
        -- Triangle 1
        for i = 1, 3 do
            local angle = (i * (math.pi * 2) / 3) + timer
            local x = math.sin(angle) * radius
            local z = math.cos(angle) * radius
            
            -- High-brightness pink + glow effect
            particles:newParticle("minecraft:dust 1 0.1 0.6 1.2", pos:add(x, 0.1, z))
            particles:newParticle("minecraft:end_rod", pos:add(x, 0.1, z))
        end
        
        -- Triangle 2 (Offset to form the star)
        for i = 1, 3 do
            local angle = (i * (math.pi * 2) / 3) + timer + math.pi
            local x = math.sin(angle) * radius
            local z = math.cos(angle) * radius
            
            particles:newParticle("minecraft:dust 1 0.1 0.6 1.2", pos:add(x, 0.1, z))
        end
    end
end