if WScript.Arguments.Count = 0 then
    WScript.Echo "Missing parameters"
Else
targetGUID = WScript.Arguments(0)
isG14 = WScript.Arguments(1)
set ws = createobject("wscript.shell") 
ws.run "cmd.exe /c powercfg -s " & targetGUID,vbhide
end if