if WScript.Arguments.Count = 0 then
    WScript.Echo "Missing parameters"
Else
targetGUID = WScript.Arguments(0)
isG14 = WScript.Arguments(1)
set ws = createobject("wscript.shell") 
scriptdir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
ws.run "cmd.exe /c powercfg -s " & targetGUID,vbhide
if isG14 = 1 then
ws.run scriptdir & "..\tools\atrofac-cli.exe fan --plan windows --cpu 30c:0%,40c:5%,50c:10%,60c:20%,70c:35%,80c:55%,90c:65%,100c:65% --gpu 30c:0%,40c:5%,50c:10%,60c:20%,70c:35%,80c:55%,90c:65%,100c:65%",vbhide
ws.run scriptdir & "..\tools\ryzenadj-win64\ryzenadj.exe --stapm-limit=23000 --fast-limit=23000",vbhide
end if
end if