Add-Type -AssemblyName Microsoft.VisualBasic
Function Invoke-BalloonTip {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,HelpMessage="The message text to display. Keep it short and simple.")]
        [string]$Message,
        [Parameter(HelpMessage="The message title")]
        [string]$Title="Attention $env:username",
        [Parameter(HelpMessage="The message type: Info,Error,Warning,None")]
        [System.Windows.Forms.ToolTipIcon]$MessageType="Info",
        [Parameter(HelpMessage="The path to a file to use its icon in the system tray")]
        [string]$SysTrayIconPath='C:\Windows\System32\UserAccountControlSettings.exe',     
        [Parameter(HelpMessage="The number of milliseconds to display the message.")]
        [int]$Duration=4000
    )
    Add-Type -AssemblyName System.Windows.Forms
    If (-NOT $global:balloon) {
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        [void](Register-ObjectEvent -InputObject $balloon -EventName MouseDoubleClick -SourceIdentifier IconClicked -Action {
            Write-Verbose 'Disposing of balloon'
            $global:balloon.dispose()
            Unregister-Event -SourceIdentifier IconClicked
            Remove-Job -Name IconClicked
            Remove-Variable -Name balloon -Scope Global
        })
    }
    $path = Get-Process -id $pid | Select-Object -ExpandProperty Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($SysTrayIconPath)
    $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]$MessageType
    $balloon.BalloonTipText  = $Message
    $balloon.BalloonTipTitle = $Title
    $balloon.Visible = $true
    $balloon.ShowBalloonTip($Duration)
    #Write-Verbose "Ending function"
}
$req1 = 'chv - נעילת המחשב בטיימר'
$msg   = ':(בעוד כמה זמן לנעול (שניות'
$req2 = 'הגדרת הודעת אזהרה'
$sub   = ':הזינו כמה שניות לפני הנעילה תעלה הודעת אזהרה - אופציונלי'
do {
$time = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $req1) }
until (($time -match '^\d+$') -or (!$time))
if (!$time) { exit }
$minutes = $time/60
$minutes = [math]::Round($minutes,1)
do {
$messagesubseq = [Microsoft.VisualBasic.Interaction]::InputBox($sub, $req2) }
until (($messagesubseq -match '^\d+$') -or (!$messagesubseq))
if (!$messagesubseq) {
Invoke-BalloonTip -Message "המחשב יינעל בעוד $time שניות ($minutes דקות), ללא אזהרה" -Title 'בוצע' -MessageType  info
start-sleep -seconds $time
rundll32.exe user32.dll,LockWorkStation 
exit }
Invoke-BalloonTip -Message "המחשב יינעל בעוד $time שניות ($minutes דקות), אזהרה תופיע $messagesubseq שניות לפני הנעילה" -Title 'בוצע' -MessageType  info
$warn = $time-$messagesubseq
start-sleep -seconds $warn
Invoke-BalloonTip -Message "המחשב יינעל בעוד $messagesubseq שניות" -Title 'אזהרה!' -MessageType  Warning
start-sleep -Seconds $messagesubseq
rundll32.exe user32.dll,LockWorkStation 
exit