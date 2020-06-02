Add-Type -AssemblyName Microsoft.VisualBasic
$req1 = 'chv - נעילת המחשב בטיימר'
$msg   = ':(בעוד כמה זמן לנעול (שניות'
$req2 = 'הגדרת הודעת אזהרה'
$sub   = ':הזינו כמה שניות לפני הנעילה תעלה הודעת אזהרה - אופציונלי'
$time = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $req1)
if (!$time) { exit } 
$minutes = $time/60
$messagesubseq = [Microsoft.VisualBasic.Interaction]::InputBox($sub, $req2)
if (!$messagesubseq) { 
$nowarn = New-Object -ComObject Wscript.Shell
$nowarn.Popup("המחשב יינעל בעוד $time שניות ($minutes דקות), ללא אזהרה",5,"בוצע",64 + 1048576) | Out-Null
start-sleep -seconds $time
rundll32.exe user32.dll,LockWorkStation 
exit }
$warn = $time-$messagesubseq
$timeseted = New-Object -ComObject Wscript.Shell
$timeseted.Popup("המחשב יינעל בעוד $time שניות ($minutes דקות), אזהרה תופיע בעוד $warn שניות",5,"בוצע",64 + 1048576) | Out-Null
start-sleep -seconds $warn
$warnmes = New-Object -ComObject Wscript.Shell
$warnmes.Popup("המחשב ננעל בעוד $messagesubseq שניות",$messagesubseq,"שים לב!",4096 + 48 + 1048576) | Out-Null
rundll32.exe user32.dll,LockWorkStation 
exit