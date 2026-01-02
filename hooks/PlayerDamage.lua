local hook_id = "Mod_GodMode_Immunity"

local damage_types = {
    "damage_bullet",
    "damage_explosion",
    "damage_fire",
    "damage_fall",
    "damage_simple"
}

----------------------------------------------------------------------
-- HELPER: Fast check to see if GodMode settings are loaded
----------------------------------------------------------------------
local function IsSettingActive(setting_key)
    local GM = _G.GodMode
    if GM and GM.settings and GM.settings.master_switch then
        return GM.settings[setting_key]
    end
    return false
end

----------------------------------------------------------------------
-- 1. NO DAMAGE + CAMERA SHAKE REMOVAL (PreHook)
----------------------------------------------------------------------
local function GodMode_DamageHandler(self, attack_data)
    -- Fast check: If mod is invalid or invulnerability is off, do nothing
    if not IsSettingActive("invulnerable") then 
        return 
    end

    if not attack_data then return end

    -- Anti-FallDamage: If height parameter exists, reset it.
    if attack_data.height then
        attack_data.height = 0 
    end
    
    -- Nullify damage
    attack_data.damage = 0 
end

for _, func_name in ipairs(damage_types) do
    Hooks:PreHook(PlayerDamage, func_name, hook_id .. "_" .. func_name, GodMode_DamageHandler)
end

----------------------------------------------------------------------
-- 2. CORE INVULNERABILITY (Health never drops below current value)
----------------------------------------------------------------------
local old_change_health = PlayerDamage.change_health
function PlayerDamage:change_health(change_of_health)
    -- If health change is negative (damage) and invulnerable is ON, block it
    if change_of_health < 0 and IsSettingActive("invulnerable") then
        change_of_health = 0
    end
    
    return old_change_health(self, change_of_health)
end

----------------------------------------------------------------------
-- 3. ANTI-MELEE
----------------------------------------------------------------------
local old_damage_melee = PlayerDamage.damage_melee
function PlayerDamage:damage_melee(attack_data)
    if IsSettingActive("invulnerable") then
        return
    end
    
    return old_damage_melee(self, attack_data)
end

----------------------------------------------------------------------
-- 4. ANTI-TASER
----------------------------------------------------------------------
local old_damage_tase = PlayerDamage.damage_tase
function PlayerDamage:damage_tase(attack_data)
    if IsSettingActive("no_taser") then
        return
    end
    
    return old_damage_tase(self, attack_data)
end

----------------------------------------------------------------------
-- 5. FLASHBANGS AND CONCUSSIONS SOUND EFFECT REMOVAL
----------------------------------------------------------------------
local old_on_flashbanged = PlayerDamage.on_flashbanged
function PlayerDamage:on_flashbanged(sound_source_pos)
    if IsSettingActive("no_flash") then
        return
    end
    
    return old_on_flashbanged(self, sound_source_pos)
end

local old_on_concussion = PlayerDamage.on_concussion
function PlayerDamage:on_concussion(mul, duration, twich_duration, duration_multiplier)
    if IsSettingActive("no_flash") then
        return
    end
    
    return old_on_concussion(self, mul, duration, twich_duration, duration_multiplier)
end