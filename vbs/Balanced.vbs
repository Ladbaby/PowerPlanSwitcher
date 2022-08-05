set ws = createobject("wscript.shell") 
scriptdir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
ws.run "cmd.exe /c powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e",vbhide
ws.run scriptdir & "..\tools\atrofac-cli.exe fan --plan windows --cpu 30c:5%,40c:5%,50c:10%,60c:20%,70c:35%,80c:55%,90c:70%,100c:80% --gpu 30c:5%,40c:5%,50c:10%,60c:20%,70c:35%,80c:55%,90c:70%,100c:80%",vbhide
ws.run scriptdir & "..\tools\ryzenadj-win64\ryzenadj.exe --stapm-limit=25000 --fast-limit=25000",vbhide