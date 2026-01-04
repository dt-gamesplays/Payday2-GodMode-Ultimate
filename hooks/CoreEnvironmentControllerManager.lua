
----------------------------------------------------------------------
-- ANTI-FLASHBANGS
----------------------------------------------------------------------
local old_set_flashbang = CoreEnvironmentControllerManager.set_flashbang
function CoreEnvironmentControllerManager:set_flashbang(...)
    if _G.GodMode and _G.GodMode.settings and _G.GodMode.settings.master_switch and _G.GodMode.settings.no_flash then
        return
    end
    return old_set_flashbang(self, ...)
end

----------------------------------------------------------------------
-- ANTI-DISTORTION
----------------------------------------------------------------------
local old_set_concussion = CoreEnvironmentControllerManager.set_concussion_grenade
function CoreEnvironmentControllerManager:set_concussion_grenade(...)
    if _G.GodMode and _G.GodMode.settings and _G.GodMode.settings.master_switch and _G.GodMode.settings.no_flash then
        return
    end
    return old_set_concussion(self, ...)
end