local hook_id = "Mod_GodMode_Immunity"
local GodMode = _G.GodMode
local settings = GodMode.settings 

local damage_types_general = {
    "damage_bullet",
    "damage_explosion",
    "damage_fire",
    "damage_simple"
}

----------------------------------------------------------------------
-- 1. NO DAMAGE HANDLERS
----------------------------------------------------------------------

-- Handler for standard damage types (Bullets, fire, etc.)
local function GodMode_GeneralDamage(self, attack_data)
    if not (settings.master_switch and settings.invulnerable) then 
        return 
    end

    if attack_data then 
        attack_data.damage = 0 
    end
end

-- Handler specifically for Fall Damage
local function GodMode_FallDamage(self, attack_data)
    if not (settings.master_switch and settings.invulnerable) then 
        return 
    end

    if attack_data then
        attack_data.height = 0 
        attack_data.damage = 0 
    end
end

-- Apply hooks for general damage
for _, func_name in ipairs(damage_types_general) do
    Hooks:PreHook(PlayerDamage, func_name, hook_id .. "_" .. func_name, GodMode_GeneralDamage)
end

-- Apply hook for fall damage separately
Hooks:PreHook(PlayerDamage, "damage_fall", hook_id .. "_damage_fall", GodMode_FallDamage)


----------------------------------------------------------------------
-- 2. CORE INVULNERABILITY (Health never drops below current value)
----------------------------------------------------------------------
local old_change_health = PlayerDamage.change_health
function PlayerDamage:change_health(change_of_health)
    if change_of_health < 0 and settings.master_switch and settings.invulnerable then
        change_of_health = 0
    end
    
    return old_change_health(self, change_of_health)
end

----------------------------------------------------------------------
-- 3. ANTI-MELEE
----------------------------------------------------------------------
local old_damage_melee = PlayerDamage.damage_melee
function PlayerDamage:damage_melee(attack_data)
    if settings.master_switch and settings.invulnerable then
        return
    end
    
    return old_damage_melee(self, attack_data)
end

----------------------------------------------------------------------
-- 4. ANTI-TASER
----------------------------------------------------------------------
local old_damage_tase = PlayerDamage.damage_tase
function PlayerDamage:damage_tase(attack_data)
    if settings.master_switch and settings.no_taser then
        return
    end
    
    return old_damage_tase(self, attack_data)
end

----------------------------------------------------------------------
-- 5. FLASHBANGS AND CONCUSSIONS SOUND EFFECT REMOVAL
----------------------------------------------------------------------
local old_on_flashbanged = PlayerDamage.on_flashbanged
function PlayerDamage:on_flashbanged(sound_source_pos)
    if settings.master_switch and settings.no_flash then
        return
    end
    
    return old_on_flashbanged(self, sound_source_pos)
end

local old_on_concussion = PlayerDamage.on_concussion
function PlayerDamage:on_concussion(mul, duration, twich_duration, duration_multiplier)
    if settings.master_switch and settings.no_flash then
        return
    end
    
    return old_on_concussion(self, mul, duration, twich_duration, duration_multiplier)
end