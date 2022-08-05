set ws = createobject("wscript.shell") 
scriptdir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
ws.run "cmd.exe /c powercfg -s 6bbe339e-efeb-4cb1-848b-57b5c55da34b",vbhide
ws.run scriptdir & "..\tools\atrofac-cli.exe fan --plan windows --cpu 30c:20%,40c:30%,50c:30%,60c:40%,70c:60%,80c:80%,90c:90%,100c:95% --gpu 30c:20%,40c:25%,50c:30%,60c:40%,70c:65%,80c:86%,90c:90%,100c:95%",vbhide
ws.run scriptdir & "..\tools\ryzenadj-win64\ryzenadj.exe --stapm-limit=35000 --fast-limit=35000",vbhide