#NoEnv
#include ListView.ahk
#SingleInstance force
#include osd.ahk
Menu, Tray, NoStandard
Menu, Tray, Add, &Show Power Modes, showAndMonitor
Menu, Tray, Default, &Show Power Modes
Menu, Tray, Add, Exit, Exit
Menu, Tray, Click, 1

IfPlanListShowing := 0
planListObj := 0
focusedSchemeName := ""
GUI_ID := 0
nameAndCommand := {"Power saver":".\vbs\Power_Saver.vbs "
    ,"Balanced":".\vbs\Balanced.vbs "
    ,"Cooler Gaming":".\vbs\Cooler_Gaming.vbs "
    ,"High performance":".\vbs\High_Performance.vbs "
    ,"Ultimate Performance":".\vbs\Ultimate_Performance.vbs "
    ,"any":".\vbs\any.vbs "}
nameAndIcon := {"Power saver":".\icons\Power saver.ico"
    ,"Balanced":".\icons\Balanced.ico"
    ,"Cooler Gaming":".\icons\Cooler Gaming.ico"
    ,"High performance":".\icons\High performance.ico"
    ,"Ultimate Performance":".\icons\Ultimate Performance.ico"
    ,"any":".\icons\any.ico"}
; en
nameAndGUID := {}
; not en
defaultPowerSchemeArray := []
ACMode:=0
DCMode:=0
ifWinF4Enabled := 1
ifWinF5Enabled := 1
ifG14:=0
initializeProgram()

#if ifWinF4Enabled
#F4::
    switchByHotKey(){
        ; MsgBox, wtf
        SetTimer, monitorForSelection, Off
        global IfPlanListShowing
        global planListObj
        global focusedSchemeName
        ; global ifMonitoring
        if (IfPlanListShowing = 0){
            getAllPowerSchemes()
            IfPlanListShowing := 1
            ; ifMonitoring := 1
        }
        else{
            focusedSchemeName := planListObj.setNextFocusedScheme()
        }
        ; if (IfPlanListShowing = 0){
        ;     monitorForSelection()
        ; }
    }
    switchByHotKey()
return
#if

#if ifWinF5Enabled
#F5::
    change()
    {
        global nameAndCommand
        global nameAndGUID
        global defaultPowerSchemeArray
        global ifG14

        static counter := 2
        static previousCounter := 2


        ; currentPowerScheme := StdOutToVar("powercfg -getactivescheme")
        ; RegExMatch(currentPowerScheme, "\((.*?)\)", M, 1+StrLen(M1) )
        M1 := translateToEn(getActiveScheme())
        if (M1 = defaultPowerSchemeArray[1]){
            counter := 1
        }
        else if (M1 = defaultPowerSchemeArray[2]){
            counter := 2
        }
        else if (M1 = defaultPowerSchemeArray[3] || M1 = "Cooler Gaming" || M1 = "High performance" || M1 = "Ultimate Performance"){
            counter := 3
        }
        if(counter = 2) {
            if (previousCounter = 3) {
                ; Run, % nameAndCommand[defaultPowerSchemeArray[1]]
                counter := 1
                previousCounter := 2
            } else {
                ; Run, % nameAndCommand[defaultPowerSchemeArray[3]]
                counter := 3
                previousCounter := 2
            }
        } else if (counter = 3) {
            ; Run, % nameAndCommand[defaultPowerSchemeArray[2]]
            counter := 2
            previousCounter := 3
        } else {
            ; Run, % nameAndCommand[defaultPowerSchemeArray[2]]
            counter := 2
            previousCounter := 1
        }
        osdTemp := New OSD
        temp := translateToEn(defaultPowerSchemeArray[counter])
        if (temp = "Power saver" || temp = "Balanced" || temp = "Cooler Gaming" || temp = "High performance" || temp = "Ultimate Performance"){
            Run, % nameAndCommand[temp] . nameAndGUID[temp] . " " . ifG14
        }
        else{
            Run, % nameAndCommand["any"] . nameAndGUID[temp] . " " . ifG14
        }
        DisplayOSD(osdTemp, defaultPowerSchemeArray[counter])
        ; sleep, 500
        ; DisplayOSD(osdTemp, getActiveScheme())
        if (not checkIfActivated(defaultPowerSchemeArray[counter])){
            counter := previousCounter
        }
    }
    change()
Return
#if

#If IfPlanListShowing
Esc::
    closePlanList(){
        global planListObj
        global IfPlanListShowing
        ; global ifMonitoring
        global focusedSchemeName
        planListObj.hide()
        planListObj.destroy()
        planListObj := 0
        IfPlanListShowing := 0
        ; ifMonitoring := 0
        focusedSchemeName := ""
        SetTimer, monitorForSelection, Off
    }
    closePlanList()
return

; #If IfPlanListShowing
Enter::
    setPlan(){
        SetTimer, monitorForSelection, Off
        global planListObj
        global IfPlanListShowing
        ; global ifMonitoring
        global focusedSchemeName
        global nameAndCommand
        global nameAndGUID
        global ifG14

        ; close the plan list ui earlier, or it may seems too slow
        planListObj.hide()
        planListObj.destroy()
        planListObj := 0

        if (focusedSchemeName != ""){
            focusedSchemeName_en := translateToEn(focusedSchemeName)
            osdTemp := New OSD
            if (focusedSchemeName_en != "Power saver" && focusedSchemeName_en != "Balanced" && focusedSchemeName_en != "Cooler Gaming" && focusedSchemeName_en != "High performance" && focusedSchemeName_en != "Ultimate Performance"){
                Run, % nameAndCommand["any"] . nameAndGUID[focusedSchemeName_en] . " " . ifG14
            }
            else{
                Run, % nameAndCommand[focusedSchemeName_en] . nameAndGUID[focusedSchemeName_en] . " " . ifG14
            }
            DisplayOSD(osdTemp, focusedSchemeName)
            ; sleep, 500
            ; DisplayOSD(osdTemp, getActiveScheme())
        }
        
        IfPlanListShowing := 0
        ; ifMonitoring := 0
        focusedSchemeName := ""
    }
    setPlan()
return

; #If IfPlanListShowing
~LWin Up::
    setPlan()
return
#If

initializeProgram(){
    global nameAndIcon
    global GUI_ID
    global nameAndGUID
    global defaultPowerSchemeArray
    global ACMode
    global DCMode
    global ifWinF4Enabled
    global ifWinF5Enabled
    global ifG14
    ; if the computer is ROG G14
    IniRead, ifG14, .\setting.ini, G14, isG14
    ; shortcuts enabled
    IniRead, WinF4, .\setting.ini, Shortcuts, WinF4
    IniRead, WinF5, .\setting.ini, Shortcuts, WinF5
    if (WinF4 = 0){
        ifWinF4Enabled := false
    }
    else{
        ifWinF4Enabled := true
    }
    if (WinF5 = 0){
        ifWinF5Enabled := false
    }
    else{
        ifWinF5Enabled := true
    }
    ; initialize tray icon
    M1 := getActiveScheme()
    M1_en := translateToEn(M1)
    if (FileExist(nameAndIcon[M1_en])){
        Menu, Tray, Icon, % nameAndIcon[M1_en]
    }
    else {
        Menu, Tray, Icon, % nameAndIcon["any"]
    }
    ; initialize power plans' names and GUIDs
    IniDelete, .\setting.ini, PowerPlans
    allPowerSchemes := StdOutToVar("powercfg -l")
    Pos := 1
    Pos2 := 1
    GUIDTemp := 0
    While Pos {
        if (Pos = 1){
            Pos:=RegExMatch(allPowerSchemes, "\((.*?)\)", M, Pos+StrLen(M1) )
            Pos2:=RegExMatch(allPowerSchemes, "GUID: (.*?)  \(", N, Pos2+StrLen(N1) )
            GUIDTemp := N1
            ; MsgBox % N1
        }
        else {
            Pos:=RegExMatch(allPowerSchemes, "\((.*?)\)", M, Pos+StrLen(M1) )
            Pos2:=RegExMatch(allPowerSchemes, "GUID: (.*?)  \(", N, Pos2+StrLen(N1) )
            if(StrLen(M1) != 0){
                M1_en := translateToEn(M1)
                IniWrite, %GUIDTemp%, .\setting.ini, PowerPlans, %M1_en%
                nameAndGUID[M1_en] := GUIDTemp
                GUIDTemp := N1
            }
        }
    }
    ; initialize 3 default modes for win+f5
    if (ifWinF5Enabled){
        Loop 3{
            IniRead, OutputVar, .\setting.ini, DefaultThreeModes, %A_Index%
            defaultPowerSchemeArray.push(OutputVar)
            if(nameAndGUID[OutputVar] = ""){
                MsgBox, Warning: %OutputVar% does not exist on your computer, Win+F5 shortcut will be disabled
                ifWinF5Enabled := false
            }
        }
    }
    ; initialize AC/DC modes to switch to
    IniRead, ifEnabled, .\setting.ini, ACDCModes, Enabled
    if (ifEnabled){
        IniRead, AC, .\setting.ini, ACDCModes, Plugged In
        IniRead, DC, .\setting.ini, ACDCModes, On Battery
        if(nameAndGUID[AC] = ""){
            MsgBox, Warning: Cannot switch to %AC% when on battery, since it does not exist on your computer. AC and DC Switchers will be disabled.
            ifEnabled := false
        }
        if(nameAndGUID[DC] = ""){
            MsgBox, Warning: Cannot switch to %AC% when plugged in, since it does not exist on your computer. AC and DC Switchers will be disabled.
            ifEnabled := false
        }
        ACMode := AC
        DCMode := DC
    }
    ; start AC/DC auto switch
    if (ifEnabled){
        #Persistent
        SetTimer, powerPlanAutoManage, 100
    }
}
showAndMonitor(){
    ; global ifMonitoring
    getAllPowerSchemes()
    ; ifMonitoring := 1
    SetTimer, monitorForSelection, 100
}
getAllPowerSchemes(){
    global IfPlanListShowing
    global planListObj
    global nameAndCommand
    ; global ifMonitoring
    global GUI_ID
    if (IfPlanListShowing = 1){
        planListObj.destroy()
        planListObj := 0
        IfPlanListShowing := 0
        ; ifMonitoring := 0
        return
    }
    else {
        IfPlanListShowing := 1
    }
    allPowerSchemes := StdOutToVar("powercfg -l")
    powerSchemeArray := []
    Pos := 1
    While Pos {
        if (Pos = 1){
            Pos:=RegExMatch(allPowerSchemes, "\((.*?)\)", M, Pos+StrLen(M1) )
        }
        else {
            Pos:=RegExMatch(allPowerSchemes, "\((.*?)\)", M, Pos+StrLen(M1) )
            if(StrLen(M1) != 0){
                ; M1 := translateToEn(M1)
                powerSchemeArray.push(M1)
            }
        }
    }
    ; currentPowerScheme := StdOutToVar("powercfg -getactivescheme")
    ; RegExMatch(currentPowerScheme, "\((.*?)\)", M, 1+StrLen(M1) )
    M1 := getActiveScheme()
    ; M1 := translateToEn(M1)
    powerSchemeArray.push(M1)

    planListObj := New PlanList
    planListObj.show(powerSchemeArray)
    GUI_ID := planListObj.getID()
}
StdOutToVar(cmd)
{
	DllCall("CreatePipe", "PtrP", hReadPipe, "PtrP", hWritePipe, "Ptr", 0, "UInt", 0)
	DllCall("SetHandleInformation", "Ptr", hWritePipe, "UInt", 1, "UInt", 1)

	VarSetCapacity(PROCESS_INFORMATION, (A_PtrSize == 4 ? 16 : 24), 0)    ; http://goo.gl/dymEhJ
	cbSize := VarSetCapacity(STARTUPINFO, (A_PtrSize == 4 ? 68 : 104), 0) ; http://goo.gl/QiHqq9
	NumPut(cbSize, STARTUPINFO, 0, "UInt")                                ; cbSize
	NumPut(0x100, STARTUPINFO, (A_PtrSize == 4 ? 44 : 60), "UInt")        ; dwFlags
	NumPut(hWritePipe, STARTUPINFO, (A_PtrSize == 4 ? 60 : 88), "Ptr")    ; hStdOutput
	NumPut(hWritePipe, STARTUPINFO, (A_PtrSize == 4 ? 64 : 96), "Ptr")    ; hStdError
	
	if !DllCall(
	(Join Q C
		"CreateProcess",             ; http://goo.gl/9y0gw
		"Ptr",  0,                   ; lpApplicationName
		"Ptr",  &cmd,                ; lpCommandLine
		"Ptr",  0,                   ; lpProcessAttributes
		"Ptr",  0,                   ; lpThreadAttributes
		"UInt", true,                ; bInheritHandles
		"UInt", 0x08000000,          ; dwCreationFlags
		"Ptr",  0,                   ; lpEnvironment
		"Ptr",  0,                   ; lpCurrentDirectory
		"Ptr",  &STARTUPINFO,        ; lpStartupInfo
		"Ptr",  &PROCESS_INFORMATION ; lpProcessInformation
	)) {
		DllCall("CloseHandle", "Ptr", hWritePipe)
		DllCall("CloseHandle", "Ptr", hReadPipe)
		return ""
	}

	DllCall("CloseHandle", "Ptr", hWritePipe)
	VarSetCapacity(buffer, 4096, 0)
	while DllCall("ReadFile", "Ptr", hReadPipe, "Ptr", &buffer, "UInt", 4096, "UIntP", dwRead, "Ptr", 0)
		sOutput .= StrGet(&buffer, dwRead, "CP0")

	DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, 0))         ; hProcess
	DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize)) ; hThread
	DllCall("CloseHandle", "Ptr", hReadPipe)
	return sOutput
}
Exit() {
    ; FileDelete, .\setting.ini
    ExitApp
}
monitorForSelection(){
    global IfPlanListShowing
    global planListObj
    global nameAndCommand
    ; global ifMonitoring
    global GUI_ID
    global nameAndGUID
    global ifG14
    ; SetTimer LoopStart, 100
    ; LoopStart:
    ; if (ifMonitoring = 0){
    ;     ifMonitoring := 1
    ;     return
    ; }
    ; Sleep, 100
    schemeTemp := planListObj.getSelectedScheme()
    if (schemeTemp != ""){
        schemeTemp_en := translateToEn(schemeTemp)
        osdTemp := New OSD
        if (nameAndCommand[schemeTemp_en] != ""){
            commandTemp := nameAndCommand[schemeTemp_en]
            Run, % commandTemp . nameAndGUID[schemeTemp_en] . " " . ifG14
        }
        else{
            commandTemp := nameAndCommand["any"]
            ; MsgBox % nameAndGUID[schemeTemp_en]
            Run, % commandTemp . nameAndGUID[schemeTemp_en] . " " . ifG14
        }
        DisplayOSD(osdTemp, schemeTemp)
        ; sleep, 500
        ; DisplayOSD(osdTemp, getActiveScheme())
        planListObj.hide()
        planListObj.destroy()
        planListObj := 0
        GUI_ID := 0
        IfPlanListShowing := 0
        SetTimer, monitorForSelection, Off
    }
    ; return
}
displayOSD(osdTemp, schemeTemp){
    global nameAndIcon
    if (schemeTemp = "Power saver"){
        osdTemp.showAndHide("🍃 Power Saver", 1) ; 
    }
    else if (schemeTemp = "节能"){
        osdTemp.showAndHide("🍃 节能", 1) ; 
    }
    else if (schemeTemp = "Balanced"){
        osdTemp.showAndHide("☯️ Balanced")
    }
    else if (schemeTemp = "平衡"){
        osdTemp.showAndHide("☯️ 平衡")
    }
    else if (schemeTemp = "Cooler Gaming"){
        osdTemp.showAndHide("🌀 Cooler Gaming")
    }
    else if (schemeTemp = "High performance"){
        osdTemp.showAndHide("🚀 High Performance", 0)
    }
    else if (schemeTemp = "高性能"){
        osdTemp.showAndHide("🚀 高性能", 0)
    }
    else if (schemeTemp = "Ultimate Performance"){
        osdTemp.showAndHide("☢ Ultimate Performance", 0)
    }
    else if (schemeTemp = "卓越性能"){
        osdTemp.showAndHide("☢ 卓越性能", 0)
    }
    else {
        osdTemp.showAndHide(schemeTemp)
    }
    schemeTemp_en := translateToEn(schemeTemp)
    if (FileExist(nameAndIcon[schemeTemp_en])){
        Menu, Tray, Icon, % nameAndIcon[schemeTemp_en]
    }
    else {
        Menu, Tray, Icon, % nameAndIcon["any"]
    }
}


powerPlanAutoManage()
{
    Global
    getPowerState()
    ; ACMode
    ; DCMode
    ; nameAndCommand
    ; MsgBox, wtf
    
    ; if ( loopCounter < 1)	;to manually retrieve currentPowerScheme only on initial run
    ;     loopCounter := 0
    ; if ( loopCounter = 0 )
    ;     Gosub, getactivePOWERscheme
    ; loopCounter += 1
    
    
    if acLineStatus = 0 ;if not on AC power
    {
        IfNotEqual, powerStateChange, 1 ;so if equal to 2
        {
            message := New OSD
            ; acLineStatus = Offline
            if (DCMode = "Power saver" || DCMode = "Balanced" || DCMode = "Cooler Gaming" || DCMode = "High performance" || DCMode = "Ultimate Performance"){
                Run, % nameAndCommand[translateToEn(DCMode)] . nameAndGUID[translateToEn(DCMode)] . " " . ifG14
            }
            else{
                Run, % nameAndCommand["any"] . nameAndGUID[translateToEn(DCMode)] . " " . ifG14
            }
            powerStateChange:=1
            sleep, 2000		;wait for asus's osd
            ; message.showAndHide("☯️ Balanced")
            DisplayOSD(message, getActiveScheme())
        }
    }
    Else If acLineStatus = 1	;if on AC power
    {
        IfNotEqual, powerStateChange, 2 ;so if equal to 1
        {
            message := New OSD
            ; acLineStatus = Online
            if (ACMode = "Power saver" || ACMode = "Balanced" || ACMode = "Cooler Gaming" || ACMode = "High performance" || ACMode = "Ultimate Performance"){
                Run, % nameAndCommand[translateToEn(ACMode)] . nameAndGUID[translateToEn(ACMode)] . " " . ifG14
            }
            else{
                Run, % nameAndCommand["any"] . nameAndGUID[translateToEn(ACMode)] . " " . ifG14
            }
            powerStateChange:=2
            sleep, 2000
            ; message.showAndHide("☯️ Balanced")
            DisplayOSD(message, getActiveScheme())
        }
    }
}



GetInteger(ByRef @source, _offset = 0, _bIsSigned = false, _size = 4)
{
    local result
    Loop %_size%  ; Build the integer by adding up its bytes.
    {
        result += *(&@source + _offset + A_Index-1) << 8*(A_Index-1)
    }
    if (!_bIsSigned OR _size > 4 OR result < 0x80000000)
        Return result  ; Signed vs. unsigned doesn't matter in these cases.
    ; Otherwise, convert the value (now known to be 32-bit & negative) to its signed counterpart:
    return -(0xFFFFFFFF - result + 1)
}

getPowerState()
{
    Global
    VarSetCapacity(powerStatus, 1+1+1+1+4+4)
    success := DllCall("GetSystemPowerStatus", "UInt", &powerStatus)
    if (ErrorLevel != 0 OR success = 0) {
        MsgBox 16, Power Status, Can't get the power status...
        Exit
    }
    acLineStatus := GetInteger(powerStatus, 0, false, 1)
}

translateToEn(stringTemp){
    if (stringTemp = "节能"){
        return "Power saver"
    }
    else if (stringTemp = "平衡"){
        return "Balanced"
    }
    else if (stringTemp = "高性能"){
        return "High performance"
    }
    else if (stringTemp = "卓越性能"){
        return "Ultimate Performance"
    }
    else {
        return stringTemp
    }
}

getActiveScheme(){
    currentPowerScheme := StdOutToVar("powercfg -getactivescheme")
    RegExMatch(currentPowerScheme, "\((.*?)\)", M, 1+StrLen(M1) )
    return M1
}

checkIfActivated(targetScheme){
    if (targetScheme = getActiveScheme()){
        return true
    }
    else {
        return false
    }
}
; toString(num){
;     return "" . num
; }
