AegisLib = {};

local VERSION = "1.2";
local LOGO_GRAY  = Color( 61, 64, 73)
local LOGO_RED   = Color( 200, 30, 40 )
local LOGO_WHITE = Color( 170, 170, 170)

local function printLogo()
    local side = "clientside"
    if (SERVER) then
        side = "serverside"
    end

    MsgC( LOGO_GRAY, '####################################################\n' )
    MsgC( LOGO_RED, [[
            _              _     _     _ _     
           / \   ___  __ _(_)___| |   (_) |__  
          / _ \ / _ \/ _` | / __| |   | | '_ \ 
         / ___ \  __/ (_| | \__ \ |___| | |_) |
        /_/   \_\___|\__, |_|___/_____|_|_.__/ 
                     |___/                     
        ]], LOGO_WHITE, "AegisLib ", side, " version ", VERSION, " loading...")
    MsgC( LOGO_GRAY, '\n####################################################\n' )
end

local function UpdateCheck()
    http.Fetch("https://raw.githubusercontent.com/Aegis-Software-LLC/AegisLib/master/version.txt", function(body)
        if(VERSION != body) then
            MsgC(Color(255, 0, 0), "[Aegis Lib - Update Alert] ", Color(255, 255, 255), "An update is available for AegisLib (https://github.com/Aegis-Software-LLC/AegisLib). Please be sure to download the update as soon as possible to ensure addons are working properly!\n");
        else
            MsgC(Color(0, 255, 255), "[Aegis Lib - Info] ", Color(255, 255, 255), "You're using the latest version of AegisLib!\n");

            timer.Remove("AegisLib.UpdateCheckTimer");
        end
    end)
end
timer.Create("AegisLib.UpdateCheckTimer", 600,  0, UpdateCheck);
UpdateCheck();

AegisLib.Libraries = {
    ["sh_class.lua"] = nil,
    ["sv_database.lua"] = nil,
    ["sh_modules.lua"] = nil,
    ["sh_settings.lua"] = nil,
    ["sh_atest.lua"] = "sh_class.lua",
    ["sh_aegisui.lua"] = "sh_class.lua"
}

local loadedLibs = {};
local toLoadLibs = {};

local function loadModules()
    local files, subfolders = file.Find("aegislib_module/*.lua", "LUA")
    for _, f in pairs(files) do   
        local path = "aegislib_module/" .. f
        
        if (SERVER) then AddCSLuaFile(path) end
        include(path)
    end
end

local function loadLibrary(libName)
    local tag = string.sub(libName, 1, 3);
    local path = "aegislib/libraries/" .. libName
    if(tag == "sv_") then
        AegisLib.Info("Loading serverside library '%s'", libName)
        if (SERVER) then include(path) end 
    elseif(tag == "sh_") then
        AegisLib.Info("Loading shared library '%s'", libName)
        if (SERVER) then AddCSLuaFile(path) end
        include(path); 
    elseif(tag == "cl_") then
        AegisLib.Info("Loading clientside library '%s'", libName)
        if (SERVER) then AddCSLuaFile(path) end
        if (CLIENT) then include(path) end
    end
end

local function loadLibraries()
    local files, folders = file.Find("aegislib/libraries/*.lua", "LUA");
    for k, v in pairs(files) do
        if(AegisLib.Libraries[v] != nil) then
            if(loadedLibs[AegisLib.Libraries[v]] == nil && !toLoadLibs[v]) then
                table.insert(toLoadLibs, v);
                continue
            end
        end

        loadLibrary(v)

        if(k == #files) then
            for _, f in pairs(toLoadLibs) do
                loadLibrary(v)
                table.remove(toLoadLibs, _)
            end
        end
    end
end

printLogo()

if(SERVER) then
    include("aegislib/sv_init.lua");
    include("aegislib/shared.lua");

    AddCSLuaFile("aegislib/cl_init.lua");
    AddCSLuaFile("aegislib/shared.lua");

    loadLibraries()
    loadModules()

    resource.AddFile("sound/nope.wav");
    resource.AddFile("sound/scronched.wav");
else
    include("aegislib/cl_init.lua");
    include("aegislib/shared.lua");
    
    loadLibraries()
    loadModules()
end