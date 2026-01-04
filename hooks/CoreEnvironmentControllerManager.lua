local settings = nil

----------------------------------------------------------------------
-- 1. ANTI-FLASHBANGS
----------------------------------------------------------------------
local old_set_flashbang = CoreEnvironmentControllerManager.set_flashbang
function CoreEnvironmentControllerManager:set_flashbang(...)
    if not settings then
        if _G.GodMode then
            settings = _G.GodMode.settings
        end
    end

    if settings and settings.master_switch and settings.no_flash then
        return
    end

    return old_set_flashbang(self, ...)
end


----------------------------------------------------------------------
-- 2. ANTI-DISTORTION
----------------------------------------------------------------------
local old_set_concussion = CoreEnvironmentControllerManager.set_concussion_grenade
function CoreEnvironmentControllerManager:set_concussion_grenade(...)
    if not settings then
        if _G.GodMode then
            settings = _G.GodMode.settings
        end
    end

    if settings and settings.master_switch and settings.no_flash then
        return
    end

    return old_set_concussion(self, ...)
end