local GodMode = _G.GodMode
local settings = GodMode.settings

----------------------------------------------------------------------
-- 1. ANTI-KNOCKBACK
----------------------------------------------------------------------
local old_push = PlayerMovement.push
function PlayerMovement:push(vel)
    if settings.master_switch and settings.invulnerable then
        return
    end
    return old_push(self, vel)
end

----------------------------------------------------------------------
-- 2. ANTI-CLOAKER
----------------------------------------------------------------------
local old_on_SPOOCed = PlayerMovement.on_SPOOCed
function PlayerMovement:on_SPOOCed(enemy_unit)
    if settings.master_switch and settings.no_cloaker then
        return
    end
    return old_on_SPOOCed(self, enemy_unit)
end

----------------------------------------------------------------------
-- 3. INFINITE STAMINA
----------------------------------------------------------------------
local old_subtract_stamina = PlayerMovement.subtract_stamina
function PlayerMovement:subtract_stamina(...)
    if settings.master_switch and settings.invulnerable then
        return
    end
    return old_subtract_stamina(self, ...)
end

local old_is_stamina_drained = PlayerMovement.is_stamina_drained
function PlayerMovement:is_stamina_drained(...)
    if settings.master_switch and settings.invulnerable then
        return false
    end
    return old_is_stamina_drained(self, ...)
end