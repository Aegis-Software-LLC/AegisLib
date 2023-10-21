local AegisUI = {
    Colors = {
        FrameDark = Color( 20, 26, 38 ),
        FrameLight = Color( 35, 43, 56 ),
        FrameClose = Color( 160, 30, 30 ),
    }
}
AegisLib.AegisUI = AegisUI

--[[
  Main panel class, everything is derived from this.
]]--

AegisLib.Class( 'Panel', {

    New = function ( self, className, parent, w, h, x, y, title )
        self.w = w
        self.h = h
        self.x = x
        self.y = y
        
        self.parent = parent
        self.children = { }
        self.colors = AegisUI.Colors

        if (parent) then
            parent = parent.panel
        end

        local panel = vgui.Create( className, parent )
        if ( title ) then
            panel:SetTitle( title )
            self.title = title
        end

        panel:SetSize( w, h )
        panel:SetPos( x, y )
        self.panel = panel

        self.DefaultPaint = panel.Paint
        panel.Paint = function ( panel, w, h )
            return self:Paint( w, h )
        end

        -- Hook into event functions.
        -- Panels can return false in their event functions to let the default function run.
        local onCursorEntered = panel.OnCursorEntered
        local onCursorExited = panel.OnCursorExited
        local updateColors = panel.UpdateColors

        if ( self.OnCursorEntered ) then 
            panel.OnCursorEntered = function ( panel )
                if ( self:OnCursorEntered() ) then
                    return
                end
                if ( onCursorEntered ) then
                    onCursorEntered( panel )
                end
            end
        end

        if ( self.OnCursorExited ) then
            panel.OnCursorExited = function ( panel )
                if ( self:OnCursorExited() ) then
                    return
                end
                if ( onCursorExited ) then
                    onCursorExited( panel )
                end
            end
        end

        if ( self.OverrideColors ) then
            panel.UpdateColors = function ( self, skin )
                if ( self:OverrideColors( skin ) ) then
                    return
                end
                if ( updateColors ) then
                    updateColors( panel )
                end
            end
        end
    end,

    AddChild = function ( self, className, id, ... )
        local newPanel = AegisLib.New( className, self, ... )
        self.children[ id ] = newPanel
        return newPanel
    end,

    ScreenPos = function ( self )
        return self.panel:LocalToScreen( self.x, self.y )
    end,

    Paint = function ( self, w, h )
        return self.DefaultPaint( self.panel, w, h )
    end
})

--[[
  Yup, it's a button.
]]--

AegisLib.Class( 'Button', {
    New = function ( self, parent, w, h, x, y, text )
        self.SUPER.New( self, 'DButton', parent, w, h, x, y, nil )
        if ( text ) then
            self.panel:SetText( text )
        end
        self.panel.DoClick = function ( )
            if ( self.OnClick ) then self:OnClick( x, y ) end
        end
    end,

    OnClick = function ( self, x, y )
        return false
    end,

    OverrideColors = function ( self, skin )
        return true
    end
}, 'Panel' )

--[[
  A frame, AKA a window.
]]--

AegisLib.Class( 'Frame', {

    CLOSE_WIDTH = 48,
    MAXIMIZE_WIDTH = 24,
    MINIMIZE_WIDTH = 24,
    TOP_BORDER = 24,

    New = function ( self, w, h, x, y, title )
        self.SUPER.New( self, 'DFrame', nil, w, h, x, y, title )
        self.panel:SetIcon("icon/asoft32.png")
        self.panel:ShowCloseButton( false )
        self.panel:MakePopup()

        self:AddChild( 'Button', 'btnClose', self.CLOSE_WIDTH, self.TOP_BORDER - 4, w - self.CLOSE_WIDTH, y, 'X' )
        function self.children.btnClose:Paint( w, h )
            draw.RoundedBoxEx( 8, 0, 0, w, h, self.colors.FrameClose, false, true, false, false )
        end
        function self.children.btnClose:OnClick( )
            self.parent:Close()
        end

        self:AddChild( 'Button', 'btnMax', self.MAXIMIZE_WIDTH, self.TOP_BORDER - 4, (w - self.CLOSE_WIDTH - self.MAXIMIZE_WIDTH), y, '[]' )
        function self.children.btnMax:Paint( w, h )
            draw.RoundedBox( 0, 0, 0, w, h, self.colors.FrameClose )
        end
        function self.children.btnMax:OnClick( )
            self.parent:Close()
        end
    end,

    Paint = function ( self, w, h )
        local topBorder = self.TOP_BORDER
        local x = self.x
        local y = self.y
        
        draw.RoundedBoxEx( 8, x, y, w, topBorder, self.colors.FrameDark, true, true, false, false )
        draw.RoundedBoxEx( 8, x, y + topBorder, w, h - topBorder, self.colors.FrameLight, false, false, true, true )
    end,

    Close = function ( self )
        self.panel:Close()
    end

}, 'Panel' )

concommand.Add( "chongus", function()
    AegisLib.New( 'Frame', 300, 300, 0, 0, 'Title' )
end )