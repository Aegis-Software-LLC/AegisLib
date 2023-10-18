AegisLib = {};

local VERSION = "1.1";

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

if(SERVER) then
    MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading serverside...\n")

    include("aegislib/sv_init.lua");
    include("aegislib/shared.lua");

    AddCSLuaFile("aegislib/cl_init.lua");
    AddCSLuaFile("aegislib/shared.lua");

    local files, folders = file.Find("aegislib/libraries/*.lua", "LUA");

    for k, v in pairs(files) do
        local tag = string.sub(v, 1, 3);

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
        if(tag == "cl_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading client-side library '"..v.."'\n")
            include("aegislib/libraries/"..v);
        elseif(tag == "sh_") then
            MsgC(Color(math.random(100, 255), math.random(100, 255), math.random(100, 255)), "[Aegis Lib - Info] ", Color(255, 255, 255), "Loading shared library '"..v.."'\n")
            include("aegislib/libraries/"..v); 
        end
    end

    local files, subfolders = file.Find("aegislib_module/*.lua", "LUA");

    for __, f in pairs(files) do
        include("aegislib_module/"..f);
    end

end