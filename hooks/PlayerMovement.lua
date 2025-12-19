----------------------------------------------------------------------
-- ANTI-KNOCKBACK
----------------------------------------------------------------------
local old_push = PlayerMovement.push
function PlayerMovement:push(vel)
    if GodMode.settings.master_switch and GodMode.settings.invulnerable then
        return -- remain stationary
    end
    return old_push(self, vel)
end