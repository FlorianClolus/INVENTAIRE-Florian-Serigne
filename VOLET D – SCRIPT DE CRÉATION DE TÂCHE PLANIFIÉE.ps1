param 
(
    [Parameter(Mandatory=$true)]
    [string]$ScriptPath
)

if (!(Test-Path $ScriptPath)) 
{
    Write-Host "Le script spécifié n'existe pas : $ScriptPath" -ForegroundColor Red
    exit 1
}

$TaskName = "InventaireSysteme"

# Action : exécuter PowerShell avec le script
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""

# Déclencheur : répéter toutes les 10 minutes, commence maintenant
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days 1)

# Paramètres : exécuter avec les privilèges les plus élevés
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Créer ou remplacer la tâche
try 
{
    if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) 
    {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        Write-Host "Ancienne tâche supprimée."
    }

    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Description "Exécute le script d'inventaire toutes les 10 minutes lorsque l'ordinateur est allumé" -ErrorAction Stop

    Write-Host "Tâche planifiée '$TaskName' créée avec succès pour exécuter : $ScriptPath" -ForegroundColor Green
} 
catch 
{
    Write-Host "Erreur lors de la création de la tâche : $_" -ForegroundColor Red
}
