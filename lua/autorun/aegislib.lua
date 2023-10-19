AegisLib = {};

local VERSION = "1.2";

Msg([[
////////////////////////////////////////////////////
             _              _     _     _ _     
            / \   ___  __ _(_)___| |   (_) |__  
           / _ \ / _ \/ _` | / __| |   | | '_ \ 
          / ___ \  __/ (_| | \__ \ |___| | |_) |
         /_/   \_\___|\__, |_|___/_____|_|_.__/ 
                      |___/                     
             
            Aegis Lib version ]]..VERSION..[[ loading...
////////////////////////////////////////////////////]]);
MsgN();

function UpdateCheck()
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
    ["sh_atest.lua"] = "sh_class.lua"
}

local loadedLibs = {};
local toLoadLibs = {};

if(SERVER) then
    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading serverside...\n")

    include("aegislib/sv_init.lua");
    include("aegislib/shared.lua");

    AddCSLuaFile("aegislib/cl_init.lua");
    AddCSLuaFile("aegislib/shared.lua");

    local files, folders = file.Find("aegislib/libraries/*.lua", "LUA");

    for k, v in pairs(files) do
        local tag = string.sub(v, 1, 3);
        if(AegisLib.Libraries[v] != nil) then
            if(loadedLibs[AegisLib.Libraries[v]] == nil && !toLoadLibs[v]) then
                table.insert(toLoadLibs, v);

                continue
            end
        end

        if(tag == "sv_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading server-side library '"..v.."'\n")
            include("aegislib/libraries/"..v); 
        elseif(tag == "sh_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading shared library '"..v.."'\n")
            include("aegislib/libraries/"..v); 

            AddCSLuaFile("aegislib/libraries/"..v);
        elseif(tag == "cl_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading client library '"..v.."'\n")
            AddCSLuaFile("aegislib/libraries/"..v);
        end

        if(k == #files) then
            for _, f in pairs(toLoadLibs) do
                tag = string.sub(f, 1, 3);

                if(tag == "sv_") then
                    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading server-side library '"..f.."'\n")
                    include("aegislib/libraries/"..f); 
                elseif(tag == "sh_") then
                    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading shared library '"..f.."'\n")
                    include("aegislib/libraries/"..f); 
        
                    AddCSLuaFile("aegislib/libraries/"..f);
                elseif(tag == "cl_") then
                    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading client library '"..f.."'\n")
                    AddCSLuaFile("aegislib/libraries/"..f);
                end

                table.remove(toLoadLibs, _)
            end
        end
    end

    local files, subfolders = file.Find("aegislib_module/*.lua", "LUA");

    for __, f in pairs(files) do   
        include("aegislib_module/"..f);

        AddCSLuaFile("aegislib_module/"..f);
    end

    resource.AddFile("sound/nope.wav");
    resource.AddFile("sound/scronched.wav");
else
    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading Clientside...\n")

    include("aegislib/cl_init.lua");
    include("aegislib/shared.lua");

    local files, folders = file.Find("aegislib/libraries/*.lua", "LUA");

    for k, v in pairs(files) do
        local tag = string.sub(v, 1, 3);

        if(AegisLib.Libraries[v] != nil) then
            if(loadedLibs[AegisLib.Libraries[v]] == nil && !toLoadLibs[v]) then
                table.insert(toLoadLibs, v);

                continue
            end
        end

        if(tag == "cl_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading client-side library '"..v.."'\n")
            include("aegislib/libraries/"..v);
        elseif(tag == "sh_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading shared library '"..v.."'\n")
            include("aegislib/libraries/"..v); 
        end

        if(k == #files) then
            for _, f in pairs(toLoadLibs) do
                tag = string.sub(f, 1, 3);
                
                if(tag == "sh_") then
                    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading shared library '"..f.."'\n")
                    include("aegislib/libraries/"..f); 
                elseif(tag == "cl_") then
                    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading client library '"..f.."'\n")
                    include("aegislib/libraries/"..f);
                end

                table.remove(toLoadLibs, _)
            end
        end
    end

    local files, subfolders = file.Find("aegislib_module/*.lua", "LUA");

    for __, f in pairs(files) do
        include("aegislib_module/"..f);
    end

end