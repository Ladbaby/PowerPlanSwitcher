Class PlanList {
    static ACCENT:= {"-1":"ffffff" ; MAIN ACCENT 4D5565
    ,"0":"DC3545" ; OFF ACCENT
    ,"1":"6eff74"} ; ON ACCENT 007BFF

    static selectedScheme := ""

    __New(pos:="", excludeFullscreen:=0, posEditorCallback:=""){      
        this.excludeFullscreen:= excludeFullscreen
        this.state:= 0
        ;get the primary monitor resolution
        SysGet, resWorkArea, MonitorWorkArea
        this.screenHeight:= resWorkAreaBottom
        this.screenWidth:= resWorkAreaRight
        ;get the primary monitor scaling
        this.scale:= A_ScreenDPI/96
        ;set the PlanList width and height
        this.width:= Format("{:i}", 200 * this.scale)
        this.height:= Format("{:i}", 40 * this.scale)
        ;set the default pos object
        pos:= pos? pos : {x:-1,y:-1}
        ;get the final pos object
        this.pos:= this.getPosObj(pos.x, pos.y)
        ;set up bound func objects 
        this.hideFunc:= objBindMethod(this, "hide")
        this.selfDestroy:= objBindMethod(this, "destroy")
        this.posEditorCallback:= posEditorCallback

        ;set the initial PlanList theme
        this.setTheme(0)
        ;create the PlanList window
        this.create()
    }

    ; creates the PlanList window
    create(){
        Gui, New, +Hwndhwnd, PlanList 
        this.hwnd:= hwnd
        Gui, +AlwaysOnTop -SysMenu +ToolWindow -caption -Border 
        ; Gui, Margin, 15
        Gui, Color, % this.theme, % PlanList.ACCENT["-1"]
        Gui, Font,% Format("s{:i} w500 c{}", 12*this.scale, PlanList.ACCENT["-1"]), Segoe UI
        
        this.hwndTxt:= txtHwnd
    }

    ; hides and destroys the PlanList window
    destroy(){
        Gui,% this.hwnd ":Default"
        this.hide()
        Gui, Destroy
        this.hwnd:= ""
        this.hwndTxt:=""
        PlanList.selectedScheme := ""
    }

    ; shows the PlanList window with the specified text and accent
    show(powerSchemeArray,accent:=-1){
        ;if the window can't be shown -> return
        if(!this.canShow())
            return
        ;if the window does not exist -> create it first
        if(!this.hwnd)
            this.create()
        Gui, % this.hwnd ":Default" ;set the default window
        Gui, Margin, 0, 0
        ;set the accent/theme colors
        if(color:=PlanList.ACCENT[accent ""])
            accent:=color
        Gui, Color, % this.theme, % accent
        Gui, Font,% Format("s{:i} w500 c{}", 9*this.scale, accent)
        GuiControl, Font, % this.hwndTxt
        ; GuiControl, Text, % this.hwndTxt, %text%
        ListViewHeightTemp := powerSchemeArray.MaxIndex()-1
        widthTemp := this.width
        Gui, Add, ListView, r%ListViewHeightTemp% w%widthTemp% gMyListView Background385b92 -Hdr -Multi altsubmit LV0x40 x+0 y+0, Battery Modes
        Loop % powerSchemeArray.MaxIndex() - 1{
            ; MsgBox % powerSchemeArray.MaxIndex()
            stringTemp := powerSchemeArray[A_Index]

            if (stringTemp != ""){
                if (stringTemp = powerSchemeArray[powerSchemeArray.MaxIndex()]){
                    this.currentFocusedScheme := stringTemp
                    this.currentFocusedIndex:=A_Index
                    stringTemp := this.addIcon(stringTemp)
                    LV_Add("Select", stringTemp)
                }
                else {
                    stringTemp := this.addIcon(stringTemp)
                    LV_Add("", stringTemp)
                }
            }
            ; MsgBox, %stringTemp%
        }
        ; LV_ModifyCol(1, "Center")

        Gui, +LastFound
        Winset, Redraw
        ;show the PlanList
        Gui, Show, % Format("NoActivate NA x{} y{}", this.pos.x - (widthTemp) * this.scale, this.pos.y - this.scale * (ListViewHeightTemp * 35))
        ; make the PlanList corners rounded
        WinGetPos,,,Width, Height, % "ahk_id " . this.hwnd
        WinSet, Region, % Format("w{} h{} 10-5 R{3:i}-{3:i}", Width - 10, Height - 5, 30*this.scale), % "ahk_id " . this.hwnd
        ;set the PlanList transparency
        ; WinSet, Transparent, 200, % "ahk_id " . this.hwnd
        SetWinDelay -1
        this.destinationX := this.pos.x - (widthTemp) * this.scale
        this.destinationY := this.pos.y - this.scale * (ListViewHeightTemp * 35)
        moveX := widthTemp / 2
        startX := this.destinationX + moveX
        duration := 100
        MaxTemp := 200
        N := 10
        Loop %N%{
            currentTp := Round(A_Index * (MaxTemp / N))
            WinMove, % "ahk_id " . this.hwnd, , % startX - moveX / N * A_Index, destinationY
            WinSet, Transparent, %currentTp%,  % "ahk_id " . this.hwnd
            Sleep % duration / N
        }
        powerSchemeArray.Remove(powerSchemeArray.MaxIndex())
        this.powerSchemeArray:=powerSchemeArray

        MyListView:
        if (A_GuiEvent = "Normal")
        {
            LV_GetText(stringTemp, A_EventInfo)  ; Get the text from the row's first field.
            if (stringTemp = "    🍃 Power saver"){
                PlanList.selectedScheme :=  "Power Saver"
            }
            else if (stringTemp = "    ☯️ Balanced"){
                PlanList.selectedScheme :=  "Balanced"
            }
            else if (stringTemp = "    🌀 Cooler Gaming"){
                PlanList.selectedScheme :=  "Cooler Gaming"
            }
            else if (stringTemp = "    🚀 High performance"){
                PlanList.selectedScheme :=  "High Performance"
            }
            else if (stringTemp = "    ☢ Ultimate Performance"){
                PlanList.selectedScheme :=  "Ultimate Performance"
            }
            else {
                PlanList.selectedScheme :=  LTrim(stringTemp, " `t")
            }
            
        }
        return
        return this.state:= 1
    }
    addIcon(stringTemp){
        if (stringTemp = "Power saver"){
            return "    🍃 Power Saver"
        }
        else if (stringTemp = "Balanced"){
            return "    ☯️ Balanced"
        }
        else if (stringTemp = "Cooler Gaming"){
            return "    🌀 Cooler Gaming"
        }
        else if (stringTemp = "High performance"){
            return "    🚀 High Performance"
        }
        else if (stringTemp = "Ultimate Performance"){
            return "    ☢ Ultimate Performance"
        }
        else {
            return "    " . stringTemp
        }
    }
    getSelectedScheme(){
        return PlanList.selectedScheme
    }

    getCurrentFocusedScheme(){
        return this.currentFocusedScheme
    }

    setNextFocusedScheme(){
        ; Gui, +LastFound
        Gui, % this.hwnd ":Default"
        ; LV_Modify(this.currentFocusedIndex, "-Select")
        this.currentFocusedIndex := Mod((this.currentFocusedIndex + 1), this.powerSchemeArray.MaxIndex() + 1)
        if (this.currentFocusedIndex = 0){
            this.currentFocusedIndex += 1
        }
        this.currentFocusedScheme := this.powerSchemeArray[this.currentFocusedIndex]
        LV_Modify(this.currentFocusedIndex, "Select")
        ; MsgBox % this.currentFocusedIndex
        ; Winset, Redraw
        return this.currentFocusedScheme
    }

    getID(){
        return this.hwnd
    }

    ; hides the PlanList window
    hide(){
        if(!this.hwnd)
            return
        Gui, % this.hwnd ":Default"
        OnMessage(0x201, this.onDragFunc, 0)
        OnMessage(0x205, this.onRClickFunc, 0)
        SetWinDelay -1
        moveX := this.width / 2
        this.destinationX += moveX
        startX := this.destinationX
        duration := 100
        MaxTemp := 200
        N := 10
        Loop %N%{
            currentTp := Round(MaxTemp - A_Index * (255 / N))
            WinSet, Transparent, %currentTp%, % "ahk_id " . this.hwnd
            WinMove, % "ahk_id " . this.hwnd, , % startX + moveX / N * A_Index, this.destinationY
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
            this.theme:= theme? (theme=1? "232323" : theme) : "385b92" ; f2f2f2
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
        p_obj.x:= x=-1? Round(this.screenWidth) : x
        p_obj.y:= y=-1? this.screenHeight : y ; 0.68
        return p_obj
    }

}