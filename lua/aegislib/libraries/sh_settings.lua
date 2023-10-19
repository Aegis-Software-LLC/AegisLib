AegisLib.MySettings = {};
AegisLib.MySettings.__index = AegisLib.MySettings;

function AegisLib.MySettings:Load(filePath, defaultSettings)
    if(file.Find(filePath, "DATA")) then
        
    else
        local data = util.TableToJSON(defaultSettings);

        
    end
end

setmetatable(AegisLib.MySettings, {__call = AegisLib.MySettings.Load})

