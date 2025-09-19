# ============================
# Script de détection de changement sur inventaire.csv
# ============================

# Emplacement du fichier inventaire
$InventaireCSV = "C:\Users\TINFO-User\Documents\ADT\INVENTAIRE ET SURVEILLANCE\inventaire.csv"

# Vérifier si le fichier existe
if (!(Test-Path $InventaireCSV)) 
{
    Write-Host "Le fichier inventaire n'existe pas : $InventaireCSV"
    return
}

# Lire les deux dernières lignes du CSV
$dernieresLignes = Import-Csv $InventaireCSV | Select-Object -Last 2

if ($dernieresLignes.Count -lt 2) 
{
    Write-Host "Pas assez de lignes pour comparer."
    return
}

$lignePrecedente = $dernieresLignes[0]
$ligneActuelle   = $dernieresLignes[1]

# Colonnes à comparer (ignorer Timestamp)
$colonnesAComparer = $ligneActuelle.PSObject.Properties.Name | Where-Object { $_ -ne "Timestamp" }

$changementDetecte = $false
foreach ($col in $colonnesAComparer) 
{
    $valPrecedente = $lignePrecedente.$col
    $valActuelle   = $ligneActuelle.$col

    # Si colonne LocalAdmins, comparer après tri des noms séparés par ;
    if ($col -eq "LocalAdmins") 
    {
        $listePrecedente = if ($valPrecedente) { ($valPrecedente -split ';' | Sort-Object) -join ';' } else { '' }
        $listeActuelle   = if ($valActuelle)   { ($valActuelle -split ';' | Sort-Object) -join ';' } else { '' }

        if ($listePrecedente -ne $listeActuelle) 
        {
            $changementDetecte = $true
            break
        }
    }
    else 
    {
        if ($valPrecedente -ne $valActuelle) 
        {
            $changementDetecte = $true
            break
        }
    }
}

# Afficher résultat
if ($changementDetecte) 
{
    Write-Host " Changement détecté dans le système !" -ForegroundColor Red

    # Popup d'alerte
    function Show-Alert {
        param([string]$Message, [string]$Title = "Alerte Inventaire")
        try {
            Add-Type -AssemblyName PresentationFramework
            [System.Windows.MessageBox]::Show($Message, $Title, 'OK', 'Warning') | Out-Null
        } catch {
            try { msg * "$Title : $Message" } catch { Write-Warning "Impossible d'afficher la notification : $_" }
        }
    }

    Show-Alert -Message " Des changements ont été détectés dans la configuration du poste.`nVeuillez prévenir un responsable."
} 
else 
{
    Write-Host "Aucun changement détecté."
}
