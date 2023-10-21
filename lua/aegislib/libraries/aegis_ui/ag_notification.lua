--[[
  AegisUI Notification.
  Kind of like a windows MessageBox.
]]--

local PANEL = { }

PANEL.MINIMUM_WIDTH = 320
PANEL.BUTTON_WIDTH  = 64
PANEL.BUTTON_HEIGHT = 24

function PANEL:Init()
    self:SetSize( 320, 100 )

    local content = vgui.Create( "DLabel", self )
    content:SetFont( "AGText" )
    content:SetContentAlignment( 8 ) -- Top Middle

    local okay = vgui.Create( "DButton", self )
    okay:SetText( "Okay" )
    okay:SetTextColor( self.colors.ButtonText )
    okay:SetFont( "AGText" )
    function okay.Paint( button, w, h )
        local color = self.colors.NotifOkay
        local textColor = self.colors.ButtonText
        if ( button.Hovered ) then 
            color = self.colors.NotifOkayHovered
            textColor = self.colors.ButtonTextHovered
        end
        self.buttonOkay:SetTextColor( textColor )
        draw.RoundedBox( 0, 0, 0, w, h, color )
    end
    function okay.DoClick()
        if ( !self:callback( "Okay" ) ) then self:Close() end
    end

    local yes = vgui.Create( "DButton", self )
    yes:SetText( "Yes" )
    yes:SetTextColor( self.colors.ButtonText )
    yes:SetFont( "AGText" )
    function yes.Paint( button, w, h )
        local color = self.colors.NotifYes
        local textColor = self.colors.ButtonText
        if ( button.Hovered ) then 
            color = self.colors.NotifYesHovered
            textColor = self.colors.ButtonTextHovered
        end
        self.buttonYes:SetTextColor( textColor )
        draw.RoundedBox( 0, 0, 0, w, h, color )
    end
    function yes.DoClick()
        if ( !self:callback( "Yes" ) ) then self:Close() end
    end

    local no = vgui.Create( "DButton", self )
    no:SetText( "No" )
    no:SetTextColor( self.colors.ButtonText )
    no:SetFont( "AGText" )
    function no.Paint( button, w, h )
        local color = self.colors.NotifNo
        local textColor = self.colors.ButtonText
        if ( button.Hovered ) then 
            color = self.colors.NotifNoHovered
            textColor = self.colors.ButtonTextHovered
        end
        self.buttonNo:SetTextColor( textColor )
        draw.RoundedBox( 0, 0, 0, w, h, color )
    end
    function no.DoClick()
       if ( !self:callback( "No" ) ) then self:Close() end
    end
    
    self.labelContent = content
    self.buttonOkay = okay
    self.buttonYes = yes
    self.buttonNo = no

    self:SetCallback()
    self:ShowCloseButton( false )
    self:SetButtonType( AegisLib.NOTIFY_OK )
end

function PANEL:SetCallback( fn )
    self.callback = fn or self.DefaultCallback
end

function PANEL:DefaultCallback()

end

function PANEL:SetButtonType( btype )
    if ( btype == AegisLib.NOTIFY_OK ) then
        self.buttonOkay:SetVisible( true )
        self.buttonYes:SetVisible( false )
        self.buttonNo:SetVisible( false )
    elseif ( btype == AegisLib.NOTIFY_YESNO ) then
        self.buttonOkay:SetVisible( false )
        self.buttonYes:SetVisible( true )
        self.buttonNo:SetVisible( true )
    end
end

function PANEL:SetContent( content )
    local w = math.max( self.MINIMUM_WIDTH, ScrW() * 0.2 ) 

    local chars = string.len( content )
    local charsPerLine = math.ceil( (w - 16) / 11 )
    local lines = math.ceil( string.len( content ) / charsPerLine )

    -- Count newlines.
    for i = 0, chars do
        if ( string.byte( content, i ) == 0x0A ) then
            lines = lines + 1
        end
    end

    if ( lines == 1 ) then
        self.labelContent:SetWrap( false )
    else
        self.labelContent:SetWrap( true )
    end

    local h = ( lines * 23 ) + 64

    self.labelContent:SetText( content )
    self:SetSize( w, h )
end

function PANEL:PerformLayout( w, h )
    self:GetTable().BaseClass.PerformLayout( self, w, h ) -- Thanks garry

    local contentH = h - self.TOP_BORDER - ( self.INNER_BORDER * 2 ) - self.BUTTON_HEIGHT
    self.labelContent:SetPos( 8, self.TOP_BORDER + ( self.INNER_BORDER * 2 ) )
    self.labelContent:SetSize( w - 16, contentH )

    local buttonY = h - self.BUTTON_HEIGHT - 8
    local okayX = ( w / 2 ) - ( self.BUTTON_WIDTH / 2 )
    self.buttonOkay:SetPos( okayX, buttonY )
    self.buttonOkay:SetSize( self.BUTTON_WIDTH, self.BUTTON_HEIGHT )

    local yesX = ( (w - okayX) / 2 ) - ( self.BUTTON_WIDTH / 2 )
    self.buttonYes:SetPos( yesX, buttonY )
    self.buttonYes:SetSize( self.BUTTON_WIDTH, self.BUTTON_HEIGHT )

    local noX = ( (w + okayX) / 2 ) - ( self.BUTTON_WIDTH / 2 )
    self.buttonNo:SetPos( noX, buttonY )
    self.buttonNo:SetSize( self.BUTTON_WIDTH, self.BUTTON_HEIGHT )
end

derma.DefineControl( "AGNotification", "An AegisUI notification", PANEL, "AGFrame" )