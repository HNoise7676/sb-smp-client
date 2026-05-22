--aylElytra 1.1
--This script may be a huge pile of crap involving many questionable creative decisions, but it's a pile of crap that works

-- Configs
local wingContrailParticle = "minecraft:lava"
local tailContrailParticle = "minecraft:smoke"
local wingSpan = 3
local elytra = {
    thrust = {anim = animations.model.thrust, type = "key"},
    brake = {anim = animations.model.brake, type = "key"},
    base = {anim = animations.model.base, type = "core", value = true},
    mid = {anim = animations.model.soar, type = "core"},
    up = {anim = animations.model.flap, type = "core"},
    down = {anim = animations.model.dive, type = "core"},
    pitch = {anim = animations.model.pitch, type = "dir", factor = 0.01},
    roll = {anim = animations.model.roll, type = "dir", factor = 0.01},
    yaw = {anim = animations.model.yaw, type = "dir"},
    right = {anim = animations.model.right, type = "wall"},
    left = {anim = animations.model.left, type = "wall"},
}
--Points used for mid-up-down's triangular blending: ie to bias the interpolation in favour of a certain value.
local upPoint = 0.55
local downPoint = 0.35
local midPoint = 0.45

--provide default lerp values so it doesn't error
for i,v in pairs(elytra) do
    elytra[i].old = 0
    elytra[i].now = 0
end
-- Exclu overriders
function events.entity_init()
    EZModel:addExcluOverrider(elytra.thrust.anim)
    EZModel:addExcluOverrider(elytra.brake.anim)
    EZModel:addExcluOverrider(elytra.base.anim)
end

-- Keybinds
local function newKey(id, title, key, exclusive)
    pings[id] = function(value)
        elytra[id].value = value
        if exclusive then
            elytra.base.value = not value
        end
        if value then
            elytra[id].now = 1
        else
            elytra[id].now = 0
        end
    end
    elytra[id].key = keybinds:newKeybind(title, key, false)
    elytra[id].key.press = function() if player:isGliding() then pings[id](true) end end
    elytra[id].key.release = function() if player:isGliding() then pings[id](false) end end
end
newKey("thrust", "Thrust", "key.keyboard.w", false)
newKey("brake", "Brake", "key.keyboard.left.shift", true)

--Yaw
elytra.yaw.right = keybinds:newKeybind("Yaw Right", "key.keyboard.d", false)
elytra.yaw.left = keybinds:newKeybind("Yaw Left", "key.keyboard.a", false)

--Takeoff/landing function
local function startStopGliding(start)
    for i,v in pairs(elytra) do
        elytra[i].anim:setPlaying(start)
    end
    pings.thrust(false)
    pings.brake(false)
    -- tail
    if start then
        mainTail.idleXMovement = 3
        mainTail.idleYMovement = 4
        mainTail.idleXSpeed = 1
        mainTail.idleYSpeed = 2.5
        mainTail.velocityPush = 0
        mainTail.bendStrength = 0.75
    else
        mainTail.idleXMovement = 15
        mainTail.idleYMovement = 5
        mainTail.idleXSpeed = 1.2
        mainTail.idleYSpeed = 2
        mainTail.velocityPush = 0.5
        mainTail.bendStrength = 1.5
    end
end
--Thanks to manuel for this great function!
local function distanceToWall(startPos, maxDist)
    local look = player:getLookDir()
    local left = vec(0,1,0):crossed(look):normalized()*maxDist
    local right = vec(0,-1,0):crossed(look):normalized()*maxDist
    local leftHit, leftPos = raycast:block(startPos,startPos+left)
    local leftDist = leftHit and (startPos-leftPos):length()
    local rightHit, rightPos = raycast:block(startPos,startPos+right)
    local rightDist = rightHit and (startPos-rightPos):length()
    return leftDist, rightDist
end
-- Mousey
local mouseMove = vectors.vec2()
function events.mouse_move(x, y)
    if player:isLoaded() and player:isGliding() then
        mouseMove = vectors.vec2(x, y)
    end
end
-- Contrails
local function contrails()
    if world.getTime() % configs.contrailDensity.value == 0 then -- every contrailInterval ticks
        if configs.wingContrails.value then
            particles:newParticle(wingContrailParticle, models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib1.rightFinger1:partToWorldMatrix():apply())
            particles:newParticle(wingContrailParticle, models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib1.leftFinger1:partToWorldMatrix():apply())
        end
        if configs.tailContrails.value then
            particles:newParticle(tailContrailParticle, models.model.root.Body.tail.segment2.segment3.segment4.segment5.segment6:partToWorldMatrix():apply())
        end
    end
end
--[[function events.tick()
    if player:isGliding() then
        --tail
        mainTail.idleXMovement = 3
        mainTail.idleYMovement = 4
        mainTail.idleXSpeed = 1
        mainTail.idleYSpeed = 2.5
        mainTail.velocityPush = 0
        mainTail.bendStrength = 0.75
    else
        mainTail.idleXMovement = 15
        mainTail.idleYMovement = 5
        mainTail.idleXSpeed = 1.2
        mainTail.idleYSpeed = 2
        mainTail.velocityPush = 0.5
        mainTail.bendStrength = 1.5
    end
end]]
--Update internal values
local wasGliding = false
local gliding = true
function events.tick()
    -- Takeoff/landing
    if wasGliding ~= gliding then
        startStopGliding(gliding)
    end
    wasGliding = gliding
    if player:isGliding() then
        gliding = true
        if elytra.base.value then
            local lookVirt = math.map(player:getLookDir().y, -1, 1, 0, 1)
            local forwardVelocity = player:getVelocity():dot(player:getLookDir():normalized())
            -- Core
            local upBlend = math.clamp(math.max(0, (lookVirt - upPoint) / (1 - upPoint))*forwardVelocity/1.3, 0, 1)--The reason this special individual is using a clamp is because it's being modified by the velocity
            local downBlend = math.max(0, (downPoint - lookVirt) / downPoint)
            local midBlend = 1 - math.max(upBlend, downBlend)
            elytra.up.now = upBlend
            elytra.down.now = downBlend
            elytra.mid.now = midBlend
            -- Wall detection & anims
            if elytra.up.anim:getBlend() > 0.75 or elytra.down.anim:getBlend() > 0.5 then
                elytra.right.anim:setPlaying(false)
                elytra.left.anim:setPlaying(false)
            else
                local left, right = distanceToWall(player:getPos():add(0,player:getEyeHeight(),0), wingSpan)
                elytra.right.now = math.map(right, wingSpan, 0.3, 0, 0.8)--when changing the anims adjust 1 to the desired strength of the anim
                elytra.left.now = math.map(left, wingSpan, 0.3, 0, 0.8)
                elytra.right.anim:setPlaying(true)
                elytra.left.anim:setPlaying(true)
            end
            -- Pitch/roll/yaw
            if host:isHost() then
                elytra.pitch.now = math.map(mouseMove.y, -2, 2, 0, 1)
                elytra.roll.now = math.map(mouseMove.x, -2, 2, 0, 1)
                elytra.yaw.now = 0.5
                if elytra.yaw.right:isPressed() then
                    elytra.yaw.now = elytra.yaw.now + 0.5
                end
                if elytra.yaw.left:isPressed() then
                    elytra.yaw.now = elytra.yaw.now - 0.5
                end
            end
            --Contrails
            if configs.highVelocity.value and configs.soaringOrDiving.value then
                if forwardVelocity > 1.65 and elytra.up.anim:getBlend() < 0.4 then
                    contrails()
                end
            elseif configs.highVelocity.value then
                if forwardVelocity > 1.65 then
                    contrails()
                end
            elseif configs.soaringOrDiving.value then
                if elytra.up.anim:getBlend() < 0.4 then
                    contrails()
                end
            else
                contrails()
            end
        else
            elytra.base.now = 0
            elytra.up.now = 0
            elytra.down.now = 0
            elytra.mid.now = 0
        end
    else
        gliding = false
    end
end

--Update observed values
function events.render()
    if player:isGliding() then
        for i,v in pairs(elytra) do
            local factor = elytra[i].factor or 0.05
            elytra[i].old = math.lerp(elytra[i].old, elytra[i].now, factor)
            if elytra[i].type == "core" or elytra[i].type == "key" or elytra[i].type == "wall" then
                elytra[i].anim:setBlend(elytra[i].old)
            elseif elytra[i].type == "dir" then
                elytra[i].anim:setTime(elytra[i].old)
            end
        end
    end
end