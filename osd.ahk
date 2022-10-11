Class OSD {
    static ACCENT:= {"-1":"ffffff" ; MAIN ACCENT 4D5565
    ,"0":"DC3545" ; OFF ACCENT
    ,"1":"6eff74"} ; ON ACCENT 007BFF

    __New(pos:="", excludeFullscreen:=0, posEditorCallback:=""){      
        this.excludeFullscreen:= excludeFullscreen
        this.state:= 0
        ;get the primary monitor resolution
        SysGet, res, Monitor
        this.screenHeight:= resBottom
        this.screenWidth:= resRight
        ;get the primary monitor scaling
        this.scale:= A_ScreenDPI/96
        ;set the OSD width and height
        this.width:= Format("{:i}", 200 * this.scale)
        this.height:= Format("{:i}", 40 * this.scale)
        ;set the default pos object
        pos:= pos? pos : {x:-1,y:-1}
        ;get the final pos object
        this.pos:= this.getPosObj(pos.x, pos.y)
        ;set up bound func objects 
        this.hideFunc:= objBindMethod(this, "hide")
        this.onDragFunc:= objBindMethod(this, "__onDrag")
        this.onRClickFunc:= objBindMethod(this, "__onRClick")
        this.selfDestroy:= objBindMethod(this, "destroy")
        this.posEditorCallback:= posEditorCallback

        ;set the initial OSD theme
        this.setTheme(0)
        ;create the OSD window
        this.create()
    }

    ; creates the OSD window
    create(){
        Gui, New, +Hwndhwnd, OSD 
        this.hwnd:= hwnd
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border 
        Gui, Margin, 15
        Gui, Color, % this.theme, % OSD.ACCENT["-1"]
        Gui, Font,% Format("s{:i} w500 c{}", 12*this.scale, OSD.ACCENT["-1"]), Segoe UI
        Gui, Add, Text,% Format("HwndtxtHwnd w{} Center", this.width-30)
        this.hwndTxt:= txtHwnd
    }

    ; hides and destroys the OSD window
    destroy(){
        Gui,% this.hwnd ":Default"
        this.hide()
        Gui, Destroy
        this.hwnd:= ""
        this.hwndTxt:=""
    }

    ; shows the OSD window with the specified text and accent
    show(text,accent:=-1){
        ;if the window can't be shown -> return
        if(!this.canShow())
            return
        ;if the window does not exist -> create it first
        if(!this.hwnd)
            this.create()
        Gui, % this.hwnd ":Default" ;set the default window
        ;set the accent/theme colors
        if(color:=OSD.ACCENT[accent ""])
            accent:=color
        Gui, Color, % this.theme, % accent
        Gui, Font,% Format("s{:i} w500 c{}", 12*this.scale, accent)
        GuiControl, Font, % this.hwndTxt
        text:= this.processText(text)
        GuiControl, Text, % this.hwndTxt, %text%
        Gui, +LastFound
        Winset, Redraw
        ;show the OSD
        Gui, Show, % Format("w{} NoActivate NA x{} y{}", this.width, this.pos.x, this.pos.y)
        ;make the OSD corners rounded
        WinGetPos,,,Width, Height, % "ahk_id " . this.hwnd
        WinSet, Region, % Format("w{} h{} 0-0 R{3:i}-{3:i}", Width, Height, 15*this.scale ), % "ahk_id " . this.hwnd
        ;set the OSD transparency
        WinSet, Transparent, 200, % "ahk_id " . this.hwnd
        return this.state:= 1
    }

    ; shows the OSD window with the specified text and accent
    ; and activates a timer to hide it
    showAndHide(text, accent:=-1, seconds:=1){
        hideFunc:= this.hideFunc
        selfDestroy:=this.selfDestroy
        this.show(text,accent)
        SetTimer, % selfDestroy,% "-" . seconds*1000
    }

    ; shows a draggable OSD window with the specified text and accent
    showDraggable(text, accent:=-1){
        Gui,% this.hwnd ":Default"
        this.show(text, accent)
        OnMessage(0x201, this.onDragFunc)
    }

    ; shows a draggable OSD window to set the position
    showPosEditor(){
        Gui,% this.hwnd ":Default"
        this.showdraggable("RClick to confirm")
        OnMessage(0x205, this.onRClickFunc)
    }

    ; hides the OSD window
    hide(){
        if(!this.hwnd)
            return
        Gui, % this.hwnd ":Default"
        OnMessage(0x201, this.onDragFunc, 0)
        OnMessage(0x205, this.onRClickFunc, 0)
        SetWinDelay -1
        duration := 100
        MaxTemp := 200
        N := 10
        Loop %N%{
            currentTp := Round(MaxTemp - A_Index * (255 / N))
            WinSet, Transparent, %currentTp%, % "ahk_id " . this.hwnd
            Sleep % duration / N
        }
        Gui, Hide
        this.state:= 0
    }

    canShow(){
        return this.excludeFullscreen? !this.isWindowFullscreen() : 1
    }

    setTheme(theme:=""){
        if(theme != this.theme)
            this.theme:= theme? (theme=1? "f2f2f2" : theme) : "232323"
    }

    processText(text){
        if (StrLen(text)>28)
            text:= SubStr(text, 1, 26) . Chr(0x2026) ; fix overflow with ellipsis
        return text
    }

    isWindowFullscreen(win:="A"){
        winID := WinExist(win)
        if(!winID)
            return 0
        WinGet style, Style, ahk_id %WinID%
        WinGetPos ,,,winW,winH, %winTitle%
        return !((style & 0x20800000) or WinActive("ahk_class Progman") 
            or WinActive("ahk_class WorkerW") or winH < A_ScreenHeight or winW < A_ScreenWidth)
    }

    getPosObj(x:=-1,y:=-1){
        p_obj:= {}
        p_obj.x:= x=-1? Round(this.screenWidth/2 - this.width) : x
        p_obj.y:= y=-1? this.screenHeight * 0.68 : y ; 0.68
        return p_obj
    }

    __onDrag(wParam, lParam, msg, hwnd){
        if(hwnd = this.hwnd)
            PostMessage, 0xA1, 2,,, % "ahk_id " this.hwnd
    }

    __onRClick(wParam, lParam, msg, hwnd){
        if(hwnd != this.hwnd)
            return
        WinGetPos, xPos,yPos
        this.hide()
        this.pos.x:= xPos
        this.pos.y:= yPos
        if(IsFunc(this.posEditorCallback))
            this.posEditorCallback.Call(xPos,yPos)
    }
}