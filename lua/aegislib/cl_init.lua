-- made for bald gaming

function AegisLib.ReceiveMessage(len, ply)
    local message = net.ReadString();

    chat.AddText(Color(0, 55, 255), "[Server] ", Color(255, 255, 255), message);
end
net.Receive("AegisLib.Message", AegisLib.ReceiveMessage);

function AegisLib.ReceiveRawMessage(len, ply)
    local shit = net.ReadTable();

    chat.AddText(unpack(shit));
end
net.Receive("AegisLib.MessageRaw", AegisLib.ReceiveRawMessage);

function AegisLib.ReceiveSound(len, ply)
    surface.PlaySound(net.ReadString());
end
net.Receive("AegisLib.PlaySound", AegisLib.ReceiveSound);

function AegisLib.ReceiveNotification(len, ply)
    local message = net.ReadString();
    local soundFile = net.ReadString();
    local type = net.ReadInt(4);

    notification.AddLegacy(message, type, 5);
    surface.PlaySound(soundFile);
    Msg(message);
    MsgN();
end
net.Receive("AegisLib.SendNotification", AegisLib.ReceiveNotification)