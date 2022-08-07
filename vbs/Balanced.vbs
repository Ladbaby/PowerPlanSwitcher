if WScript.Arguments.Count = 0 then
    WScript.Echo "Missing parameters"
Else
targetGUID = WScript.Arguments(0)
set ws = createobject("wscript.shell") 
scriptdir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
ws.run "cmd.exe /c powercfg -s " & targetGUID,vbhide
ws.run scriptdir & "..\tools\atrofac-cli.exe fan --plan windows --cpu 30c:5%,40c:5%,50c:10%,60c:20%,70c:35%,80c:55%,90c:70%,100c:80% --gpu 30c:5%,40c:5%,50c:10%,60c:20%,70c:35%,80c:55%,90c:70%,100c:80%",vbhide
ws.run scriptdir & "..\tools\ryzenadj-win64\ryzenadj.exe --stapm-limit=25000 --fast-limit=25000",vbhide
end if