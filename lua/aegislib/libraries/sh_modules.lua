-- Module class
AegisLib.Module = {};
AegisLib.Module.__index = AegisLib.Module;

function AegisLib.Module:new(moduleName, author, version, func, dependson)
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
        table.insert(AegisLib.Modules, Data);
    end

    local succ, err = pcall(func, Data);
    if(!succ) then
        AegisLib.Log(3, "Error loading module %s! Error: %s", moduleName, err);
    end

    return Data;
end

function AegisLib.Module:Log(level, message, ...)
    local Levels = {
        [1] = "["..self.ModuleName.." - Info] ",
        [2] = "["..self.ModuleName.." - Warning] ",
        [3] = "["..self.ModuleName.." - Error] "
    }

    MsgC(AegisLib.LogColors[level], Levels[level], Color(255, 255, 255), Format(message, ...));
    MsgN();
end

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

setmetatable(AegisLib.Module, {__call = AegisLib.Module.new});

AegisLib.Log(1, "Modules Library loaded!");