----------------------------------------------------------------------
-- ANTI-FLASHBANGS
----------------------------------------------------------------------
local old_set_flashbang = CoreEnvironmentControllerManager.set_flashbang
function CoreEnvironmentControllerManager:set_flashbang(...)
    if GodMode and GodMode.settings.master_switch and GodMode.settings.no_flash then
        return -- No white screen
    end
    return old_set_flashbang(self, ...)
end

----------------------------------------------------------------------
-- ANTI-DISTORTION
----------------------------------------------------------------------
local old_set_concussion = CoreEnvironmentControllerManager.set_concussion_grenade
function CoreEnvironmentControllerManager:set_concussion_grenade(...)
    if GodMode and GodMode.settings.master_switch and GodMode.settings.no_flash then
        return -- No distortion
    end
    return old_set_concussion(self, ...)
end