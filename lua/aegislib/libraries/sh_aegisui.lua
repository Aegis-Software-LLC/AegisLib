if ( SERVER ) then
    -- Send components to client.
    AddCSLuaFile( 'aegis_ui/ag_frame.lua' )
    AddCSLuaFile( 'aegis_ui/ag_notification.lua' )

    resource.AddFile( 'materials/icon/aegis/asoft32.png' )
    resource.AddFile( 'materials/icon/aegis/minus.png' )
    resource.AddFile( 'materials/icon/aegis/box.png' )
    resource.AddFile( 'materials/icon/aegis/x.png' )
    
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

concommand.Add( 'ag_alert', function( ply, cmd, args )
    AegisLib.Notification( "Alert", args[1], AegisLib.NOTIFY_YESNO, function( self, choice )
        print( choice )
    end )
end )

-- Include components.
include( 'aegis_ui/ag_frame.lua' )
include( 'aegis_ui/ag_notification.lua' )