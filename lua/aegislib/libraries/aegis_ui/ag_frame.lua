--[[
  AegisUI VGUI Frame.
  Basically a DFrame but better. :^)
]]--

local PANEL = { }

PANEL.TOP_BORDER   = 24
PANEL.INNER_BORDER = 4

PANEL.DEFAULT_ICON = Material( "icon/aegis/asoft32.png" )
PANEL.ICON_SIZE    = 16

PANEL.CLOSE_ICON      = Material( "icon/aegis/x.png" )
PANEL.CLOSE_ICON_SIZE = 7
PANEL.CLOSE_WIDTH     = 40

PANEL.MAXIMIZE_ICON      = Material( "icon/aegis/box.png" )
PANEL.MAXIMIZE_ICON_SIZE = 9
PANEL.MAXIMIZE_WIDTH     = 32

PANEL.MINIMIZE_ICON      = Material( "icon/aegis/minus.png" )
PANEL.MINIMIZE_ICON_SIZE = 7
PANEL.MINIMIZE_WIDTH     = 32

AccessorFunc( PANEL, "m_bIsMenuComponent",  "IsMenu",           FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable",        "Draggable",        FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable",          "Sizable",          FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock",       "ScreenLock",       FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose",    "DeleteOnClose",    FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow",      "PaintShadow",      FORCE_BOOL )
AccessorFunc( PANEL, "m_iMinWidth",         "MinWidth",         FORCE_NUMBER )
AccessorFunc( PANEL, "m_iMinHeight",        "MinHeight",        FORCE_NUMBER )
AccessorFunc( PANEL, "m_bBackgroundBlur",   "BackgroundBlur",   FORCE_BOOL )

function PANEL:Init()
    self:SetFocusTopLevel( true )
    self:SetPaintShadow( true )
    
    self.colors = AegisLib.AegisUI.Colors
    self.labelTitle = vgui.Create( "DLabel", self )
    self.labelTitle:SetFont( "AGTitle" )

    self.imageIcon = vgui.Create( "DImage", self )
    self.imageIcon:SetMaterial( self.DEFAULT_ICON )

    self.buttonClose = vgui.Create( "DButton", self )
    self.buttonClose:SetText( "" )
    self.buttonClose.Paint = function( button, w, h )
        local color = self.colors.FrameClose
        local iconColor = color_white

        if ( button.Hovered ) then
            color = self.colors.FrameCloseHovered
            iconColor = self.colors.DarkenedIcon
        end

        draw.RoundedBoxEx( 8, 0, 0, w, h, color, false, true, false, false )

        local size = self.CLOSE_ICON_SIZE
        local cx = math.floor((w / 2) - (size / 2))
        local cy = math.floor((h / 2) - (size / 2))

        surface.SetMaterial( self.CLOSE_ICON )
        surface.SetDrawColor( iconColor )
        surface.DrawTexturedRect( cx, cy, size, size )
    end
    self.buttonClose.DoClick = function( button )
        self:Close()
    end

    self.buttonMaximize = vgui.Create( "DButton", self )
    self.buttonMaximize:SetText( "" )
    self.buttonMaximize:SetTextColor( color_white )
    self.buttonMaximize.Paint = function( panel, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, self.colors.FrameMaximize )

        local size = self.MAXIMIZE_ICON_SIZE
        local cx = math.floor((w / 2) - (size / 2))
        local cy = math.floor((h / 2) - (size / 2))

        surface.SetMaterial( self.MAXIMIZE_ICON )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( cx, cy, size, size )
    end
    self.buttonMaximize.DoClick = function( button )
        
    end

    self.buttonMinimize = vgui.Create( "DButton", self )
    self.buttonMinimize:SetText( "" )
    self.buttonMinimize:SetTextColor( color_white )
    self.buttonMinimize.Paint = function( panel, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, self.colors.FrameMinimize )

        local size = self.MINIMIZE_ICON_SIZE
        local cx = math.floor((w / 2) - (size / 2))
        local cy = math.floor((h / 2) - (size / 2))

        surface.SetMaterial( self.MINIMIZE_ICON )
        surface.SetDrawColor( color_white )
        surface.DrawTexturedRect( cx, cy, size, size )
    end
    self.buttonMinimize.DoClick = function( button )
        
    end

    self:SetDraggable( true )
    self:SetSizable( false )
    self:SetScreenLock( true )
    self:SetDeleteOnClose( true )
    self:SetTitle( "AegisUI Window" )

    self:SetMinWidth( 50 )
    self:SetMinHeight( 50 )

    self:SetPaintBackgroundEnabled( false )
    self:SetPaintBorderEnabled( false )
end

function PANEL:ShowCloseButton( show )
	self.buttonClose:SetVisible( show )
    self.buttonMaximize:SetVisible( show )
    self.buttonMinimize:SetVisible( show )
end

function PANEL:GetTitle()
    return self.labelTitle:GetText()
end

function PANEL:SetTitle( title )
    self.labelTitle:SetText( title )
end

function PANEL:Close()
    self:SetVisible( false )
    if ( self:GetDeleteOnClose() ) then
        self:Remove()
    end
    self:OnClose()
end

function PANEL:OnClose()
    
end

function PANEL:Center()
    self:InvalidateLayout( true )
    self:CenterVertical()
    self:CenterHorizontal()
end

function PANEL:IsActive()
    if ( self:HasFocus() ) then return true end
    if ( vgui.FocusedHasParent( self ) ) then return true end
    return false
end

function PANEL:SetIcon( str )
    if ( !str && IsValid( self.imgIcon ) ) then
        return self.imgIcon:Remove() -- We are instructed to get rid of the icon, do it and bail.
    end

    if ( !IsValid( self.imgIcon ) ) then
        self.imgIcon = vgui.Create( "DImage", self )
    end

    if ( IsValid( self.imgIcon ) ) then
        self.imgIcon:SetMaterial( Material( str ) )
    end
end

function PANEL:Paint( w, h )
    if ( self.m_bBackgroundBlur ) then
        Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    end

    local topBorder = self.TOP_BORDER
    local innerBorder = self.INNER_BORDER
    
    -- Title bar.
    draw.RoundedBoxEx( 8, 0, 0, 
        w, topBorder, 
        self.colors.FrameDark, 
        true, true, false, false )
    
    -- Dark frame border.
    draw.RoundedBoxEx( 8, 0, topBorder, 
        w, h - topBorder, 
        self.colors.FrameLight, 
        false, false, true, true )
    
    -- Light inner frame.
    draw.RoundedBox( 8, innerBorder, topBorder + innerBorder, 
        w - (innerBorder * 2), h - (innerBorder * 2) - topBorder, 
        self.colors.FrameInternal )
    return true
end

--[[
  Sizing and dragging code borrowed from garrysmod/lua/vgui/dframe.lua. 
]]--

function PANEL:Think()
    local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
    local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

    if ( self.Dragging ) then

        local x = mousex - self.Dragging[1]
        local y = mousey - self.Dragging[2]

        -- Lock to screen bounds if screenlock is enabled
        if ( self:GetScreenLock() ) then

            x = math.Clamp( x, 0, ScrW() - self:GetWide() )
            y = math.Clamp( y, 0, ScrH() - self:GetTall() )

        end

        self:SetPos( x, y )

    end

    if ( self.Sizing ) then

        local x = mousex - self.Sizing[1]
        local y = mousey - self.Sizing[2]
        local px, py = self:GetPos()

        if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px && self:GetScreenLock() ) then x = ScrW() - px end
        if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py && self:GetScreenLock() ) then y = ScrH() - py end

        self:SetSize( x, y )
        self:SetCursor( "sizenwse" )
        return

    end

    local screenX, screenY = self:LocalToScreen( 0, 0 )

    if ( self.Hovered && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + self:GetTall() - 20 ) ) then

        self:SetCursor( "sizenwse" )
        return

    end

    if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
        self:SetCursor( "sizeall" )
        return
    end

    self:SetCursor( "arrow" )

    -- Don't allow the frame to go higher than 0
    if ( self.y < 0 ) then
        self:SetPos( self.x, 0 )
    end
end

function PANEL:OnMousePressed()
    local screenX, screenY = self:LocalToScreen( 0, 0 )
    if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
        self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
        self:MouseCapture( true )
        return
    end

    if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
        self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
        self:MouseCapture( true )
        return
    end
end

function PANEL:OnMouseReleased()
    self.Dragging = nil
    self.Sizing = nil
    self:MouseCapture( false )
end

function PANEL:PerformLayout( w, h )
    self.imageIcon:SetPos( 6, 4 )
    self.imageIcon:SetSize( 16, 16 )

    self.labelTitle:SetPos( 8 + self.ICON_SIZE + 4, 2 )
    self.labelTitle:SetSize( w - 25 - self.ICON_SIZE - 4, 20 )

    local closeX = w - self.CLOSE_WIDTH + 1
    self.buttonClose:SetPos( closeX, 0 )
    self.buttonClose:SetSize( self.CLOSE_WIDTH, self.TOP_BORDER )

    local maximizeX = closeX - self.MAXIMIZE_WIDTH
    self.buttonMaximize:SetPos( maximizeX, 0 )
    self.buttonMaximize:SetSize( self.MAXIMIZE_WIDTH, self.TOP_BORDER )

    local minimizeX = maximizeX - self.MINIMIZE_WIDTH
    self.buttonMinimize:SetPos( minimizeX, 0 )
    self.buttonMinimize:SetSize( self.MINIMIZE_WIDTH, self.TOP_BORDER )
end   

derma.DefineControl( "AGFrame", "An AegisUI window", PANEL, "EditablePanel" )