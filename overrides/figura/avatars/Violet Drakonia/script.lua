-- Import libraries
membrane = require("scripts.membrane")
squAPI = require("scripts.SquAPI")

-- API Setups
mainTail = squAPI.tail:new({
	models.model.root.Body.tail,
    models.model.root.Body.tail.segment2,
    models.model.root.Body.tail.segment2.segment3,
    models.model.root.Body.tail.segment2.segment3.segment4,
    models.model.root.Body.tail.segment2.segment3.segment4.segment5,
    models.model.root.Body.tail.segment2.segment3.segment4.segment5.segment6
},
    nil,    --(15) idleXMovement
    nil,    --(5) idleYMovement
    nil,    --(1.2) idleXSpeed
    nil,    --(2) idleYSpeed
    1.5,    --(2) bendStrength
    0.5,    --(0) velocityPush
    nil,    --(0) initialMovementOffset
    nil,    --(1) offsetBetweenSegments
    nil,    --(.005) stiffness
    nil,    --(.9) bounce
    nil,    --(90) flyingOffset
    nil,    --(-90) downLimit
    nil     --(45) upLimit
)

 -- Setup membranes
membrane:define(models.model.membranes.rightMembrane.rightMembrane1, {
    models.model.root.Body.rightMBodyDown,
    models.model.root.Body.rightWing.rightMBodyUp,
    models.model.root.Body.rightWing.rightMWing,
    models.model.root.Body.rightWing.rightMWing,
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane2, {
    models.model.root.Body.rightWing.rightMWing,
    models.model.root.Body.rightWing.rightMBodyUp,
    models.model.root.Body.rightWing.rightBackArm.rightMBack,
    models.model.root.Body.rightWing.rightMWing,
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane3, {
    models.model.root.Body.rightWing.rightMBodyUp,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMFront,
    models.model.root.Body.rightWing.rightBackArm.rightMBack,
    models.model.root.Body.rightWing.rightMBodyUp
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane4, {
    models.model.root.Body.rightWing.rightMWing,
    models.model.root.Body.rightWing.rightBackArm.rightMBack,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightMRib3,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightFinger3.rightMFinger3
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane5, {
    models.model.root.Body.rightWing.rightBackArm.rightMBack,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMFront,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightMRib3,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightMRib3
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane6, {
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightFinger3.rightMFinger3,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightMRib3,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib2.rightMRib2,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib2.rightFinger2.rightMFinger2,
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane7, {
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib3.rightMRib3,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMFront,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightMMetacarpus,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib2.rightMRib2,
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane8, {
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib2.rightFinger2.rightMFinger2,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib2.rightMRib2,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib1.rightMRib1,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib1.rightFinger1.rightMFinger1,
})
membrane:define(models.model.membranes.rightMembrane.rightMembrane9, {
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib2.rightMRib2,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightMMetacarpus,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightMMetacarpus,
    models.model.root.Body.rightWing.rightBackArm.rightFrontArm.rightMetacarpus.rightRib1.rightMRib1,
})

membrane:define(models.model.membranes.leftMembrane.leftMembrane1, {
    models.model.root.Body.leftMBodyDown,
    models.model.root.Body.leftWing.leftMBodyUp,
    models.model.root.Body.leftWing.leftMWing,
    models.model.root.Body.leftWing.leftMWing,
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane2, {
    models.model.root.Body.leftWing.leftMWing,
    models.model.root.Body.leftWing.leftMBodyUp,
    models.model.root.Body.leftWing.leftBackArm.leftMBack,
    models.model.root.Body.leftWing.leftMWing,
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane3, {
    models.model.root.Body.leftWing.leftMBodyUp,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMFront,
    models.model.root.Body.leftWing.leftBackArm.leftMBack,
    models.model.root.Body.leftWing.leftMBodyUp
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane4, {
    models.model.root.Body.leftWing.leftMWing,
    models.model.root.Body.leftWing.leftBackArm.leftMBack,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftMRib3,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftFinger3.leftMFinger3
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane5, {
    models.model.root.Body.leftWing.leftBackArm.leftMBack,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMFront,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftMRib3,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftMRib3
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane6, {
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftFinger3.leftMFinger3,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftMRib3,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib2.leftMRib2,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib2.leftFinger2.leftMFinger2,
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane7, {
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib3.leftMRib3,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMFront,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftMMetacarpus,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib2.leftMRib2,
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane8, {
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib2.leftFinger2.leftMFinger2,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib2.leftMRib2,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib1.leftMRib1,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib1.leftFinger1.leftMFinger1,
})
membrane:define(models.model.membranes.leftMembrane.leftMembrane9, {
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib2.leftMRib2,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftMMetacarpus,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftMMetacarpus,
    models.model.root.Body.leftWing.leftBackArm.leftFrontArm.leftMetacarpus.leftRib1.leftMRib1,
})

local function showWings(value)
    models.model.root.Body.rightWing:setVisible(value)
    models.model.root.Body.leftWing:setVisible(value)
    models.model.membranes:setVisible(value)
    if value then
        if configs.hover.value then
            EZModel:setState("hover")
        else
            EZModel:setState()
        end
    else
        EZModel:setState("nowings")
    end
    vanilla_model.ELYTRA:setVisible(not value)
end
local function setElytraOnly()
    if player:getItem(5).id == "minecraft:elytra" then
        showWings(true)
        --if configs.showCover.value then
            models.model.root.Body.cover:setVisible(true)
        --end
    else
        showWings(false)
        models.model.root.Body.cover:setVisible(false)
    end
end
function events.tick()
    -- Hide wings when not wearing elytra if the toggle is on
    if configs.elytraOnly.value then
        setElytraOnly()
    end
    -- Stop flap sounds if flapsfx is off
    if not configs.flapSFX.value then
        sounds:stopSound("entity.ender_dragon.flap")
	end
end

-- Action wheel
local aylConfig = require("scripts.aylConfig")
config:setName("aylDWT")

local dPages = {
    main = {},
    settings = {parent = "main", item = "minecraft:structure_void", title = "Settings", desc = "Configuration saved over multiple sessions."},
    contrails = {parent = "settings", item = "minecraft:torch", title = "Contrails", desc = "Particles that trail behind you in elytra flight."},
    parts = {parent = "settings", item = "minecraft:item_frame", title = "Parts", desc = "Different sections of the model."},
}
local dConfigs = {
    hover = {page = "main", type = "boolean", value = false, item = "minecraft:feather", title = "Hover", desc = nil, func = function(value, action, auto)
        value = aylConfig:saveBoolean("hover", value)
        if not auto then
            sounds:playSound("entity.ender_dragon.flap", player:getPos(), 1, 1.25, false)
        end
        if value then
            EZModel:setState("hover")
        else
            EZModel:setState()
        end
    end},
    spreadWings = {page = "main", type = "boolean", value = false, item = "minecraft:elytra", title = "Spread Wings", desc = nil, func = function(value, action, auto)
        value = aylConfig:saveBoolean("spreadWings", value)
        if not auto then
            sounds:playSound("entity.ender_dragon.flap", player:getPos(), 1, 1.25, false)
        end
        EZModel:setExcluOff(value)
        animations.model.spread:setPlaying(value)
    end},
    wag = {page = "main", type = "boolean", value = false, item = "minecraft:carrot_on_a_stick", title = "Wag", desc = nil, func = function(value, action, auto)
        value = aylConfig:saveBoolean("wag", value)
        if not auto then
            sounds:playSound("entity.fox.sniff", player:getPos(), 1, 0.75, false)
        end
        -- Wag animation is inclusive
        animations.model.wag:setPlaying(value)
    end},
    vanillaSkin = {page = "settings", type = "boolean", value = true, item = "minecraft:armor_stand", title = "Use Vanilla Skin", desc = "Reload required.\nUse your vanilla skin automatically. Turn this off if you want to use a different skin from your player.\nNote that the vanilla §omodel §r§7is always hidden and replaced with the modded model.\nIf you want to use a modded model instead, refer to the guide in the README.", func = function(value)
        value = aylConfig:saveBoolean("vanillaSkin", value)
        if value then
            local isSlim = player:getModelType() == "SLIM"
            -- Set classic/slim arms based on the player's model type
            models.model.root.RightArm.RightArmSlim:setVisible(isSlim)
            models.model.root.RightArm.RightSleeveSlim:setVisible(isSlim)
            models.model.root.LeftArm.LeftArmSlim:setVisible(isSlim)
            models.model.root.LeftArm.LeftSleeveSlim:setVisible(isSlim)
            models.model.root.RightArm.RightArmClassic:setVisible(not isSlim)
            models.model.root.RightArm.RightSleeveClassic:setVisible(not isSlim)
            models.model.root.LeftArm.LeftArmClassic:setVisible(not isSlim)
            models.model.root.LeftArm.LeftSleeveClassic:setVisible(not isSlim)
            -- Set textures base on the player's texture
            models.model.root.Head.Head:setPrimaryTexture("SKIN")
            models.model.root.Head.Hat:setPrimaryTexture("SKIN")
            models.model.root.Body.Body:setPrimaryTexture("SKIN")
            models.model.root.Body.Jacket:setPrimaryTexture("SKIN")
            models.model.root.RightArm.RightArmClassic:setPrimaryTexture("SKIN")
            models.model.root.RightArm.RightSleeveClassic:setPrimaryTexture("SKIN")
            models.model.root.RightArm.RightArmSlim:setPrimaryTexture("SKIN")
            models.model.root.RightArm.RightSleeveSlim:setPrimaryTexture("SKIN")
            models.model.root.LeftArm.LeftArmClassic:setPrimaryTexture("SKIN")
            models.model.root.LeftArm.LeftSleeveClassic:setPrimaryTexture("SKIN")
            models.model.root.LeftArm.LeftArmSlim:setPrimaryTexture("SKIN")
            models.model.root.LeftArm.LeftSleeveSlim:setPrimaryTexture("SKIN")
            models.model.root.RightLeg.RightLeg:setPrimaryTexture("SKIN")
            models.model.root.RightLeg.RightPants:setPrimaryTexture("SKIN")
            models.model.root.LeftLeg.LeftLeg:setPrimaryTexture("SKIN")
            models.model.root.LeftLeg.LeftPants:setPrimaryTexture("SKIN")
        end
    end},
    elytraOnly = {page = "settings", type = "boolean", value = false, item = "minecraft:elytra", title = "Elytra Only", desc = "Hides your wings while not wearing elytra.\nThis setting will break if used in conjunction with hiding wings via the parts menu.", func = function(value, action, auto)
        value = aylConfig:saveBoolean("elytraOnly", value)
        if not auto and not value then
            showWings(true)
        end
    end},
    flapSFX = {page = "settings", type = "boolean", value = true, item = "minecraft:jukebox", title = "Flap SFX", desc = "Controls the flapping sounds from the creative flight & elytra flap animations, as well as the action wheel.", func = function(value)
        aylConfig:saveBoolean("flapSFX", value)
    end},
    wingContrails = {page = "contrails", type = "boolean", value = false, item = "minecraft:redstone_torch", title = "Wing Contrails", desc = "Particles will trail behind your wingtips.\nBy default, the particle is minecraft:lava. If you want to replace this, go into scripts/aylElytra.lua and change wingContrailParticle to your particle of choice.", func = function(value)
        aylConfig:saveBoolean("wingContrails", value)
    end},
    tailContrails = {page = "contrails", type = "boolean", value = false, item = "minecraft:soul_torch", title = "Tail Contrails", desc = "Particles will trail behind your tail.\nBy default, the particle is minecraft:smoke. If you want to replace this, go into scripts/aylElytra.lua and change tailContrailParticle to your particle of choice.", func = function(value)
        aylConfig:saveBoolean("tailContrails", value)
    end},
    contrailDensity = {page = "contrails", type = "integer", value = 1, item = "minecraft:firework_star", title = "Contrail Density", desc = "How many ticks to wait before spawning a new particle.\n1 will spawn a particle every tick, 2 will spawn a particle every two ticks, & 3 will spawn a particle every three ticks - so on and so on.", func = function(value, action, auto)
        aylConfig:saveInteger("contrailDensity", value, auto, 1, 20, 1)
    end},
    tailContrails = {page = "contrails", type = "boolean", value = false, item = "minecraft:soul_torch", title = "Tail Contrails", desc = "Particles will trail behind your tail.\nBy default, the particle is minecraft:smoke. If you want to replace this, go into scripts/aylElytra.lua and change tailContrailParticle to your particle of choice.", func = function(value)
        aylConfig:saveBoolean("tailContrails", value)
    end},
    soaringOrDiving = {page = "contrails", type = "boolean", value = false, item = "minecraft:lantern", title = "Soaring or Diving", desc = "Contrails will only appear when soaring or diving.", func = function(value)
        aylConfig:saveBoolean("soaringOrDiving", value)
    end},
    highVelocity = {page = "contrails", type = "boolean", value = false, item = "minecraft:firework_rocket", title = "High Velocity", desc = "Contrails will only appear at high velocities, such as when boosting with a firework rocket or diving.", func = function(value)
        aylConfig:saveBoolean("highVelocity", value)
    end},
    showCover = {page = "parts", type = "boolean", value = true, item = "minecraft:leather", title = "Show Cover", desc = "The cover is the small plate of skin which covers your back.", func = function(value)
        value = aylConfig:saveBoolean("showCover", value)
        models.model.root.Body.cover:setVisible(value)
    end},
    showTail = {page = "parts", type = "boolean", value = true, item = "minecraft:stick", title = "Show Tail", desc = nil, func = function(value)
        value = aylConfig:saveBoolean("showTail", value)
        models.model.root.Body.tail:setVisible(value)
    end},
    showWings = {page = "parts", type = "boolean", value = true, item = "minecraft:phantom_membrane", title = "Show Wings", desc = nil, func = function(value)
        value = aylConfig:saveBoolean("showWings", value)
        showWings(value)
    end},
}
aylConfig:init(dPages, dConfigs)