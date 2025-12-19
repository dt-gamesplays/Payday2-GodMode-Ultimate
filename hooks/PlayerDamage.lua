local hook_id = "Mod_GodMode_Immunity"

local damage_types = {
    "damage_bullet",
    "damage_explosion",
    "damage_melee",
    "damage_fire",
    "damage_fall",
    "damage_simple"
}

----------------------------------------------------------------------
-- 1. CAMERA SHAKE REMOVAL + ANTI-FALL DAMAGE + ANTI-CLOAKER
----------------------------------------------------------------------
for _, func_name in ipairs(damage_types) do
    Hooks:PreHook(PlayerDamage, func_name, hook_id .. "_" .. func_name, function(self, attack_data)
        if not GodMode.settings.master_switch or not attack_data then return end

        -- Anti-Cloaker
        if GodMode.settings.no_cloaker and attack_data.variant == "counter_tase" then
            attack_data.variant = "melee"
            attack_data.damage = 0
        end

        -- Anti-FallDamage + Camera shake removal
        if GodMode.settings.invulnerable then
            if attack_data.height then
                attack_data.height = 0 -- immune to fall damage
            end
            attack_data.damage = 0 -- The camera does not shake.
        end
    end)
end

----------------------------------------------------------------------
-- 2. CORE INVULNERABILITY
----------------------------------------------------------------------
local old_change_health = PlayerDamage.change_health
function PlayerDamage:change_health(change_of_health)
    if GodMode.settings.master_switch and GodMode.settings.invulnerable and change_of_health < 0 then
        change_of_health = 0
    end
    return old_change_health(self, change_of_health)
end

----------------------------------------------------------------------
-- 3. ANTI-TASER
----------------------------------------------------------------------
local old_damage_tase = PlayerDamage.damage_tase
function PlayerDamage:damage_tase(attack_data)
    if GodMode.settings.master_switch and GodMode.settings.no_taser then
        return
    end
    return old_damage_tase(self, attack_data)
end

----------------------------------------------------------------------
-- 4. FLASHBANGS AND CONCUSSIONS SOUND EFFECT REMOVAL
----------------------------------------------------------------------
local old_on_flashbanged = PlayerDamage.on_flashbanged
function PlayerDamage:on_flashbanged(sound_source_pos)
    if GodMode.settings.master_switch and GodMode.settings.no_flash then
        return
    end
    return old_on_flashbanged(self, sound_source_pos)
end

local old_on_concussion = PlayerDamage.on_concussion
function PlayerDamage:on_concussion(mul, duration, twich_duration, duration_multiplier)
    if GodMode.settings.master_switch and GodMode.settings.no_flash then
        return
    end
    return old_on_concussion(self, mul, duration, twich_duration, duration_multiplier)
end