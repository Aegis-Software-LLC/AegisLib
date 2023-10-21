if ( SERVER ) then
    -- Send components to client.
    AddCSLuaFile( 'aegis_ui/ag_frame.lua' )
    AddCSLuaFile( 'aegis_ui/ag_notification.lua' )

    resource.AddFile( 'materials/icon/aegis/asoft32.png' )
    resource.AddFile( 'materials/icon/aegis/minus.png' )
    resource.AddFile( 'materials/icon/aegis/box.png' )
    resource.AddFile( 'materials/icon/aegis/x.png' )

    util.AddNetworkString( 'AegisLib_ShowNotif' )
    util.AddNetworkString( 'AegisLib_NotifReply' )

    --[[
      Display a notification window for a client.
      @param ply       Player to show notification to.
      @param notif     Notification table.
    ]]--
    function AegisLib.ShowNotification( ply, notif )
        if ( !IsValid(ply) ) then error( 'invalid player' ) end

        -- Generate a random id.
        local id = math.random( 0, 65535 )
        
        -- Build the actual notification table.
        local time = CurTime()
        local expires = time + 1
        local toSend = { 
            id         = id,
            title      = notif.title   or 'Alert',
            content    = notif.content or '',
            type       = notif.type    or AegisLib.NOTIFY_OK,
            customText = notif.customText,
            expires    = expires
        }
        notif.id      = id
        notif.expires = expires

        -- Associate notification with the player.
        if ( !ply.Notifications ) then ply.Notifications = { } end
        local plyNotifs = ply.Notifications
        plyNotifs[ id ] = notif

        -- Check if there are any expired notifications to clean up.
        for k, v in pairs ( plyNotifs ) do
            if ( time >= v.expires ) then
                if ( v.onExpire ) then
                    v.onExpire( k )
                end
                plyNotifs[ k ] = nil
            end
        end

        -- Send it over the interbutts.
        net.Start( 'AegisLib_ShowNotif' )
            net.WriteTable( toSend )
        net.Send( ply )
    end

    net.Receive( 'AegisLib_NotifReply', function( len, ply )
        local id = net.ReadUInt( 16 )
        local reply = net.ReadString()

        -- Is this even a real player?
        if ( !IsValid( ply ) || !ply.Notifications ) then return end

        -- Is there an outbound notification to this player?
        local notif = ply.Notifications[ id ]
        if ( !notif ) then return end

        -- Run the callback if there is one.
        if ( notif.onReply ) then
            notif.onReply( id, reply )
        end

        -- Remove notification entry.
        ply.Notifications[ id ] = nil
    end )

    concommand.Add( 'ag_alert_sv', function( ply, cmd, args )
        AegisLib.ShowNotification( ply, {
            title = 'Alert',
            content = args[ 1 ],
            type = AegisLib.NOTIFY_OK,
            onReply = function( id, reply )
                AegisLib.Log( 1, 'Notification reply %d recieved: %s', id, reply )
            end,
            onExpire = function( id )
                AegisLib.Log( 1, 'Notification %d expired.', id )
            end
        } )
    end )

    -- Don't run the rest of the file.
    return
end

-- Window title font.
surface.CreateFont("AGTitle", {
    font = "Arial",
    size = 18,
    weight = 500,
    antialias = false
})

-- Window title font.
surface.CreateFont("AGText", {
    font = "Courier New",
    size = 18,
    weight = 500,
    antialias = false
})

local AegisUI = {
    Colors = {
        FrameDark = Color( 20, 26, 38 ),
        FrameLight = Color( 35, 43, 56 ),
        FrameInternal = Color( 39, 49, 62 ),
        FrameClose = Color( 160, 30, 30 ),
        FrameCloseHovered = Color( 140, 30, 30 ),
        FrameMaximize = Color( 55, 63, 86 ),
        FrameMinimize = Color( 50, 57, 80 ),

        NotifOkay = Color( 44, 106, 195 ),
        NotifOkayHovered = Color( 34, 78, 140 ),
        NotifYes = Color( 50, 110, 58 ),
        NotifYesHovered = Color( 44, 128, 55),
        NotifNo = Color( 138, 45, 45),
        NotifNoHovered = Color( 173, 50, 50),

        ButtonText  = Color( 200, 200, 200 ),
        ButtonTextHovered  = Color( 255, 255, 255 ),

        DarkenedIcon  = Color( 180, 180, 180 )
    }
}

AegisLib.AegisUI = AegisUI

AegisLib.NOTIFY_OK     = 0
AegisLib.NOTIFY_YESNO  = 1
AegisLib.NOTIFY_CUSTOM = 2

--[[
  Display a notification window.
  @param title     Title of notification window.
  @param content   Text shown in notification.
  @param ntype     One of the AegisLib.NOTIFY_* constants.
  @param callback  Function to be called when the notification is acknowledged.
                   (When one of the buttons is pressed.)
  @param text      (Optional) Text to display on the button when type == NOTIFY_CUSTOM.
]]--
function AegisLib.Notification( title, content, ntype, callback, text )
    local notif = vgui.Create( 'AGNotification' )
    
    notif:SetTitle( title )
    notif:SetContent( content )
    notif:SetButtonType( ntype or AegisLib.NOTIFY_OK )
    notif:SetCallback( callback )
    notif:Center()
    notif:MakePopup()
end

net.Receive( 'AegisLib_ShowNotif', function( len )
    local notif = net.ReadTable()

    AegisLib.Notification( notif.title, notif.content, notif.type, function( self, choice )
        net.Start( 'AegisLib_NotifReply' )
            net.WriteUInt( notif.id, 16 )
            net.WriteString( choice )
        net.SendToServer()
    end )
end )

concommand.Add( 'ag_alert', function( ply, cmd, args )
    AegisLib.Notification( "Alert", args[1], AegisLib.NOTIFY_YESNO, function( self, choice )
        print( choice )
    end )
end )

-- Include components.
include( 'aegis_ui/ag_frame.lua' )
include( 'aegis_ui/ag_notification.lua' )