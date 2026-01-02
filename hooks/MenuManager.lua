_G.GodMode = _G.GodMode or {}
GodMode._path = ModPath
GodMode._data_path = SavePath .. "god_mode_options.txt"

-- Default settings configuration
GodMode.settings = {
    language_index = 1,   -- 1: Auto, 2: English (Default), 3+: Other Languages
    master_switch = true,
    invulnerable = true,
    no_taser = true,
    no_cloaker = true,
    no_flash = true
}

-- Language Filename Map
local supported_languages_map = {
    italian     = "italian.txt",
    french      = "french.txt",
    german      = "german.txt",
    spanish     = "spanish.txt",
    russian     = "russian.txt",
    portuguese  = "portuguese.txt",
    dutch       = "dutch.txt",
    polish      = "polish.txt",
    turkish     = "turkish.txt",
    swedish     = "swedish.txt",
    czech       = "czech.txt",
    indonesian  = "indonesian.txt"
}

-- Menu Index -> Language Key Map (For manual selection)
local manual_selection_map = {
    [3] = "italian", [4] = "french", [5] = "german", [6] = "spanish",
    [7] = "russian", [8] = "portuguese", [9] = "dutch", [10] = "polish",
    [11] = "turkish", [12] = "swedish", [13] = "czech", [14] = "indonesian"
}

-- Save settings to JSON file
function GodMode:Save()
    local file = io.open(self._data_path, "w+")
    if file then
        file:write(json.encode(self.settings))
        file:close()
    end
end

-- Load settings from JSON file safely
function GodMode:Load()
    local file = io.open(self._data_path, "r")
    if file then
        local success, data = pcall(json.decode, file:read("*all"))
        file:close()
        if success and data then
            for k, v in pairs(data) do
                -- Backward compatibility if keys change
                if k == "enabled" and self.settings.invulnerable ~= nil then
                    self.settings.invulnerable = v
                elseif self.settings[k] ~= nil then
                    self.settings[k] = v
                end
            end
        end
    end
end

-- Load settings immediately on startup
GodMode:Load()

------------------------------------------------------------------------
-- HOOK 1: LOCALIZATION INITIALIZATION
------------------------------------------------------------------------
Hooks:Add("LocalizationManagerPostInit", "GodMode_Loc", function(loc)
    -- 1. Always load English first as a fallback/base
    loc:load_localization_file(GodMode._path .. "loc/english.txt")

    local lang_choice = GodMode.settings.language_index
    local file_to_load = nil

    -- 2. Determine which language file to load
    if lang_choice == 1 then
        -- AUTO-DETECT MODE
        local sys_lang_key = SystemInfo:language():key()
        
        for key, filename in pairs(supported_languages_map) do
            if Idstring(key):key() == sys_lang_key then
                file_to_load = filename
                break
            end
        end
        
    elseif manual_selection_map[lang_choice] then
        -- MANUAL SELECTION MODE
        local key = manual_selection_map[lang_choice]
        file_to_load = supported_languages_map[key]
    end

    -- 3. Load the target language file if found
    if file_to_load then
        loc:load_localization_file(GodMode._path .. "loc/" .. file_to_load)
    end
end)

------------------------------------------------------------------------
-- HOOK 2: MENU INITIALIZATION
------------------------------------------------------------------------
Hooks:Add("MenuManagerInitialize", "GodMode_Menu_Init", function(menu_manager)
    
    local function setup_callback(name, key)
        MenuCallbackHandler[name] = function(self, item)
            GodMode.settings[key] = (item:value() == "on")
            GodMode:Save()
        end
    end

    setup_callback("GodMode_Master_Callback", "master_switch")
    setup_callback("GodMode_Invuln_Callback", "invulnerable")
    setup_callback("GodMode_Taser_Callback", "no_taser")
    setup_callback("GodMode_Cloaker_Callback", "no_cloaker")
    setup_callback("GodMode_Flash_Callback", "no_flash")

    MenuCallbackHandler.GodMode_Language_Callback = function(self, item)
        GodMode.settings.language_index = item:value()
        GodMode:Save()
    end

    MenuHelper:LoadFromJsonFile(GodMode._path .. "menu/options.json", GodMode, GodMode.settings)
end)