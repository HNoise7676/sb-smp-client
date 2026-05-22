EZAnims = require("scripts.EZAnims")
EZModel = EZAnims:addBBModel(animations.model)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.CAPE:setVisible(false)
-- Hide icarus wings
if icarus then
    icarus:setWingsVisible(false)
end
-- Increase GSAnimBlend blend times (I despise the default blend times)
-- the ezanims one only sets ezanims blend times
modelAnimations = animations:getAnimations()
for i, v in ipairs(modelAnimations) do
    modelAnimations[i]:setBlendTime(7)
end
-- Make flat textures transparent (delete this part if anything is breaking)
models.model:primaryRenderType("TRANSLUCENT_CULL")
-- Move nameplate to match model position
function events.tick()
    nameplate.entity:setPos(models.model.root:getTruePos()/20)
end
-- Fix emissive rendering under 1.21.4
function removeAlpha(color, x, y)
    color = color*color.a
    color.a = 1
    return color
end
function events.entity_init()
    if client:compareVersions("1.21.4", client:getVersionName()) == 1 then
        local textureList = textures:getTextures()
        for Index, Texture in pairs(textureList) do
            if Texture:getName():match("_e$") then
                local dimensions = Texture:getDimensions()
                Texture:applyFunc(0, 0, dimensions.x, dimensions.y, removeAlpha):update()
            end
        end
    end
end