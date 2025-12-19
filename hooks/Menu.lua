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

-- Supported Languages Configuration Table
local supported_languages = {
    [3] = { file = "italian.txt",    id = "italian" },
    [4] = { file = "french.txt",     id = "french" },
    [5] = { file = "german.txt",     id = "german" },
    [6] = { file = "spanish.txt",    id = "spanish" },
    [7] = { file = "russian.txt",    id = "russian" },
    [8] = { file = "portuguese.txt", id = "portuguese" },
    [9] = { file = "dutch.txt",      id = "dutch" },
    [10] = { file = "polish.txt",    id = "polish" },
    [11] = { file = "turkish.txt",   id = "turkish" },
    [12] = { file = "swedish.txt",   id = "swedish" },
    [13] = { file = "czech.txt",     id = "czech" },
    [14] = { file = "indonesian.txt", id = "indonesian" }
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
        local sys_lang = SystemInfo:language()
        
        for _, lang_data in pairs(supported_languages) do
            if sys_lang == Idstring(lang_data.id) then
                file_to_load = lang_data.file
                break
            end
        end
        
    elseif supported_languages[lang_choice] then
        -- MANUAL SELECTION MODE
        file_to_load = supported_languages[lang_choice].file
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