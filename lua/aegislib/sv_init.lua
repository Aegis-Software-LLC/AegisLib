-- Made for bald gaming

util.AddNetworkString("AegisLib.Message");
util.AddNetworkString("AegisLib.MessageRaw");
util.AddNetworkString("AegisLib.PlaySound");
util.AddNetworkString("AegisLib.SendNotification");

AegisLib.Modules = {};

function AegisLib.FindPlayer(input)
    if(!input) then
        return "No player found.";
    end

    input = string.lower(input);

    local Found = {};

    for k, v in pairs(player.GetAll()) do
        local vName = string.lower(v:Name());

        -- This section will just return the player. Reason behind this is because each of these identifiers are unique.
        if(tonumber(input)== v:UserID()) then
            return v;
        elseif(v:UniqueID()== input) then  -- Unique ID shouldn't really be used, but we'll support it.
            return v;
        elseif(v:SteamID()== input) then
            return v;
        end

        -- Names, however, are not unique, so we'll throw it in a table for later use.
        if(string.find(vName, input)) then
            table.insert(Found, v);
        end
    end

    if(#Found > 1) then
        local rtMessage = "More than one player found: ";

        for k, v in pairs(Found) do
            if(k == 1) then
                rtMessage = rtMessage..v:Name()

                break;
            end

            rtMessage = rtMessage..", "..v:Name()
        end

        return rtMessage;
    elseif(#Found == 0) then
       return "No players found by that name."; 
    end

    return Found[1];
end


hook.Call("AegisLib.Initialized"); -- done balding