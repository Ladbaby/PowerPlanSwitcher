set ws = createobject("wscript.shell") 
scriptdir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
ws.run "cmd.exe /c powercfg -s 5cd2e7d8-b015-4f99-b77d-50d6058c1923",vbhide
ws.run scriptdir & "..\tools\atrofac-cli.exe fan --plan windows --cpu 30c:20%,40c:30%,50c:30%,60c:40%,70c:60%,80c:80%,90c:90%,100c:95% --gpu 30c:20%,40c:25%,50c:30%,60c:40%,70c:65%,80c:86%,90c:90%,100c:95%",vbhide
ws.run scriptdir & "..\tools\ryzenadj-win64\ryzenadj.exe --stapm-limit=25000 --fast-limit=25000",vbhide