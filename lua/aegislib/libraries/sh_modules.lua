-- Module class
AegisLib.Module = {};
AegisLib.Module.__index = AegisLib.Module;

--[[
  Create a new AegisLib module.
  @param moduleName  Name of module.
  @param author      Name of author.
  @param version     Module version.
  @param initFn      Function to initialize the module.
  @param dependson   Table of module dependencies in format { Name: string, Version: string }
]]--
function AegisLib.Module:New(moduleName, author, version, initFn, dependson)
    AegisLib.Log(1, "Loading module '%s' v%s made by %s...", moduleName, version, author);

    if(!dependson) then dependson = {} end;
    
    local Data = {
        ModuleName = moduleName,
        Author = author,
        Version = version,
        Dependency = dependson
    }

    if(!table.IsEmpty(dependson)) then -- we only really wanna loop if we have to, so if the table is empty, no point in looping.
        local foundDepend = false;
        for k, v in pairs(AegisLib.Modules) do
            if(v.Data.ModuleName == dependson.Name && v.Data.Version == dependson.Version) then
                foundDepend = true;
            end
        end

        if(!foundDepend) then
            AegisLib.Log(3, "Failed loading module %s! Couldn't find dependency '%s'", moduleName, dependson);

            return nil;
        end
    end

    setmetatable(Data, AegisLib.Module);

    if(SERVER) then
        AegisLib.Modules[moduleName] = Data
    end

    local succ, err = pcall(initFn, Data);
    if(!succ) then
        AegisLib.Log(3, "Error loading module %s! Error: %s", moduleName, debug.traceback(err));
    end

    return Data;
end

--[[
  Print a formatted message to the console.
  @param level    Logger level.
  @param message  Message format (printf-style).
]]--
function AegisLib.Module:Log(level, message, ...)
    local Levels = {
        [AegisLib.DEBUG]   = "["..self.ModuleName.." - Debug] ",
        [AegisLib.INFO]    = "["..self.ModuleName.." - Info] ",
        [AegisLib.WARNING] = "["..self.ModuleName.." - Warning] ",
        [AegisLib.ERROR]   = "["..self.ModuleName.." - Error] "
    }

    MsgC(AegisLib.LogColors[level], Levels[level], Color(255, 255, 255), Format(message, ...));
    MsgN();
end

--[[
  Print a formatted info message to the console.
  @param message  Message format (printf-style).
]]--
function AegisLib.Module:Info(message, ...)
    self:Log(AegisLib.INFO, message, ...)
end

--[[
  Display a message in a player's chat box.
  @param ply      Player.
  @param message  Message format (printf-style).
]]--
function AegisLib.Module:Message(ply, message, ...)
    print(self.ModuleName);
    message = Format(message, ...);

    if(SERVER) then
        net.Start("AegisLib.MessageRaw");
            net.WriteTable({Color(0, 100, 255), "["..self.ModuleName.."] ", Color(255, 255, 255), message})
        net.Send(ply);
    else
        chat.AddText(Color(0, 100, 255), "["..self.ModuleName.."] ", Color(255, 255, 255), message);
    end
end

--[[
  Get the specified module's table.
  @param name  Module name.
  @return Module table or nil.
]]--
function AegisLib.GetModule(name)
    return AegisLib.Modules[name]
end

setmetatable(AegisLib.Module, {
    -- AegisLib.Module(...) -> AegisLib.Module.New(AegisLib.Module, ...)
    __call = AegisLib.Module.New
});

AegisLib.Log(AegisLib.INFO, "Modules Library loaded!");