-- Logger levels.
AegisLib.DEBUG   = 0
AegisLib.INFO    = 1
AegisLib.WARNING = 2
AegisLib.ERROR   = 3

AegisLib.LogColors = {
    -- Debug/Info
    [1] = Color(0, 200, 255),
    -- Warning
    [2] = Color(200, 100, 0),
    -- Error
    [3] = Color(255, 0, 0)
}

AegisLib.LogPrefixes = {
    [1] = "[Aegis Lib - Info] ",
    [2] = "[Aegis Lib - Warning] ",
    [3] = "[Aegis Lib - Error] "
}

AegisLib.NotifySounds = {
    [0] = "", -- NOTIFY_GENERIC
    [1] = "", -- NOTIFY_ERROR
    [2] = "", -- NOTIFY_UNDO
    [3] = "", -- NOTIFY_HINT
    [4] = ""  -- NOTIFY_CLEANUP
}

function AegisLib.Log(level, message, ...)
    message = Format(message, ...);

    if(level == 1) then
        MsgC(AegisLib.LogColors[1], AegisLib.LogPrefixes[1], Color(255, 255, 255), message);
        MsgN();
    elseif(level == 2) then
        MsgC(AegisLib.LogColors[2], AegisLib.LogPrefixes[2], Color(255, 255, 255), message);
        MsgN();
    elseif(level == 3) then
        MsgC(AegisLib.LogColors[3], AegisLib.LogPrefixes[3], Color(255, 255, 255), message);
        MsgN();
    end
end

function AegisLib.Message(ply, message, ...)
    message = Format(message, ...);

    if(CLIENT) then
        chat.AddText(Color(0, 200, 255), "[Bald Gaming] ", Color(255, 255, 255), message);
    else
        net.Start("AegisLib.Message");
            net.WriteString(message);
        net.Send(ply);
    end
end

function AegisLib.MessageRaw(ply, ...)

    if(CLIENT) then
        chat.AddText(Color(0, 200, 255), "[Bald Gaming] ", Color(255, 255, 255), message);
    else
        net.Start("AegisLib.MessageRaw");
            net.WriteTable({...});
        net.Send(ply);
    end
end

function AegisLib.PlaySound(ply, sound)
    if(SERVER) then
        net.Start("AegisLib.PlaySound");
            net.WriteString(sound);
        net.Send(ply);
    else
        surface.PlaySound(sound);
    end
end

-- Converts a string to minutes, ie 1d will return 1440
function AegisLib.stringTimeToMinutes(str)
    str = string.gsub(str, " ", "");

	local minutes = 0;
	local keycode_location = string.find(str, "%a");

	while keycode_location do
        local keycode = string.sub(str, keycode_location, keycode_location)
		local num = tonumber(str:sub(1, keycode_location - 1));

		if(!num) then
			return nil;
		end

		local multiplier;
		if(keycode == "h") then
			multiplier = 60;
        elseif(keycode == "d") then
			multiplier = 60 * 24;
		elseif(keycode == "w") then
			multiplier = 60 * 24 * 7;
		elseif(keycode == "m") then
			multiplier = 60 * 24 * 30;
		else
			return nil;
		end

        str = string.sub(str, keycode_location + 1);
		keycode_location = string.find(str, "%a");
		minutes = minutes + num * multiplier;
	end

	local num = 0;
	if(str ~= "") then
		num = tonumber(str);
	end

	return minutes + num;
end
-- turns input time into a pretty string. Ie 3600 will return "1 hour"
function AegisLib.TimePrettyPrint(time, showmins)
	time = tonumber(time);

	if(type(time) == "number") then
		if(time == 0) then -- forever
			return "permanent";
		elseif(time < 3600) then -- less than a hour
			showmins = true;
		end;
		local mins = math.floor(time / 60);
		local hours = math.floor(mins / 60);
		local days = math.floor(hours / 24);
		local minstorem = hours * 60;
		local minsrem = mins - minstorem;
		local hourstorem = days * 24;
		local hoursrem = hours - hourstorem;
		local timestring = "";
		if(days > 0) then timestring = days.." day";
			if(days > 1) then timestring = timestring.."s"; end;
			if(minsrem > 0 and showmins and hoursrem > 0) then timestring = timestring..", "; 
			elseif((minsrem > 0 and showmins) or hoursrem > 0) then timestring = timestring.." and "; end;
		end;
		if(hoursrem > 0) then timestring = timestring..hoursrem.." hour";
			if(hoursrem > 1) then timestring = timestring.."s"; end;
			if(minsrem > 0 and showmins) then timestring = timestring.." and "; end;
		end;
		if(minsrem > 0 and showmins) then timestring = timestring..minsrem.." minute"; end;
		if(minsrem > 1 and showmins) then timestring = timestring.."s"; end;
		return (timestring);
	else
		return "Invalid number";
	end;
end;

function AegisLib.Notify(t, ply, message, ...)
    if(t > 4) then t = 4 end;

    message = Format(message, ...);

    if(SERVER) then
        net.Start("AegisLib.SendNotification");
            net.WriteString(message);
            net.WriteString(AegisLib.NotifySounds[t]);
            net.WriteInt(t, 4);
        net.Send(ply);
    else -- we on the client
        notification.AddLegacy(message, t, 5);
        surface.PlaySound(AegisLib.NotifySounds[t]);
        Msg(message);
        MsgN();
    end
end