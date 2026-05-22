-- KorboSpeech v2.1.3 by @korbosoft
-- With edits by @manuel_2867, @customable, @skunkmommy179
local voiceSounds = {
    -- put at least 1 or 2 sound names here
    -- for example: "sound1", "sound2"
    -- also use only mono channel sounds, otherwise will be heard globally!
    "Violet_Hmm"
}
local voiceSpeechRate = 2 -- rate of speech, how many ticks to wait per character
local voiceVolume = 1 -- voice volume
local voicePitchRange = 0.25 -- range of pitch randomization, set to zero to disable
local voiceMinLength = 1 -- minimum amount of sounds to play even if message is shorter
local voiceMaxLength = 999 -- maximum amount of characters to speak if you want to limit it
local cancelPreviousSound = true -- set to true if you want to avoid overlapping sounds

-- DO NOT CHANGE ANYTHING UNDER HERE!

local queue = 0
local basePitch = 1 - voicePitchRange / 2
local currentSound = nil

function pings.KorboSpeak(amount)
    if player:isLoaded() then
        queue = queue + amount
    end
end

function events.tick()
    if queue > 0 and world.getTime() % voiceSpeechRate == 0 then
        queue = queue - 1
        if cancelPreviousSound and currentSound then
            currentSound:stop()
        end
        currentSound = sounds[voiceSounds[math.random(#voiceSounds)]]
        currentSound:pos(player:getPos())
            :volume(voiceVolume)
            :pitch(basePitch + math.random() * voicePitchRange)
            :subtitle(player:getName() .. " speaks")
            :play()
    end
end

function events.chat_send_message(msg)
    if not msg then return end
    if string.sub(msg, 1, 1) ~= "/" then
        local nospaces = msg:gsub("%s+", "")
        pings.KorboSpeak(math.max(voiceMinLength, math.min(#nospaces, voiceMaxLength)))
    end
    return msg
end