# Importer les types nécessaires pour WPF
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Text.RegularExpressions


# Charger les fonctions depuis les fichiers
. ./modules/system.ps1
. ./modules//hardware.ps1
. ./modules//network.ps1
. ./modules//security.ps1
. ./modules//user.ps1
. ./modules//performance.ps1


# Fonction pour créer un bouton
function New-Button {
    param (
        [string]$content,
        [int]$row,
        [int]$col,
        [scriptblock]$clickAction
    )

    $button = New-Object System.Windows.Controls.Button
    $button.Content = $content
    $button.Width = 100 
    $button.Height = 50 # Taille réduite de 50%
    $button.Margin = '5'
    $button.Add_Click($clickAction)
    $buttonGrid.Children.Add($button)
    [System.Windows.Controls.Grid]::SetRow($button, $row)
    [System.Windows.Controls.Grid]::SetColumn($button, $col)
}

# Créer la fenêtre principale
$window = New-Object System.Windows.Window
$window.Title = "System Check"
$window.Width = 400
$window.Height = 200
$window.WindowStartupLocation = 'CenterScreen'

# Créer une grille principale
$mainGrid = New-Object System.Windows.Controls.Grid
$mainGrid.Margin = '10'

# Définir les lignes de la grille principale
$mainGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{ Height = "Auto" }))
$mainGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{ Height = "*" }))
$mainGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition -Property @{ Height = "Auto" }))

# Créer une grille pour les boutons
$buttonGrid = New-Object System.Windows.Controls.Grid
$buttonGrid.Margin = '10'

# Définir les lignes et colonnes de la grille de boutons
for ($i = 0; $i -lt 2; $i++) {
    $row = New-Object System.Windows.Controls.RowDefinition
    $buttonGrid.RowDefinitions.Add($row)
}
for ($j = 0; $j -lt 3; $j++) {
    $col = New-Object System.Windows.Controls.ColumnDefinition
    $buttonGrid.ColumnDefinitions.Add($col)
}

# Créer une zone pour afficher les informations, initialement invisible
$infoPanel = New-Object System.Windows.Controls.StackPanel
$infoPanel.Visibility = 'Collapsed'
$infoPanel.Margin = '10'

$titleTextBlock = New-Object System.Windows.Controls.TextBlock
$titleTextBlock.Margin = '10'
$titleTextBlock.HorizontalAlignment = 'Center'
$titleTextBlock.FontWeight = 'Bold'
$infoPanel.Children.Add($titleTextBlock)

$infoTextBlock = New-Object System.Windows.Controls.TextBlock
$infoTextBlock.Margin = '10'
$infoTextBlock.TextWrapping = 'Wrap'
$infoPanel.Children.Add($infoTextBlock)

# Ajouter les grilles à la grille principale
$mainGrid.Children.Add($buttonGrid)
[System.Windows.Controls.Grid]::SetRow($buttonGrid, 0)

$mainGrid.Children.Add($infoPanel)
[System.Windows.Controls.Grid]::SetRow($infoPanel, 1)

# Désactiver les messages de la console
$ErrorActionPreference = "SilentlyContinue"

# Créer les boutons en appelant la méthode New-Button
New-Button -content "Système" -row 0 -col 0 -clickAction {
    $window.Height = 400
    $infoPanel.Visibility = 'Visible'
    $titleTextBlock.Text = "Système"
    $infoTextBlock.Text = Show-SystemInfo
}

New-Button -content "Matériel" -row 0 -col 1 -clickAction {
    $window.Height = 800
    $infoPanel.Visibility = 'Visible'
    $titleTextBlock.Text = "Matériel"
    $infoTextBlock.Text = Show-HardwareInfo
}

New-Button -content "Réseau" -row 0 -col 2 -clickAction {
    $window.Height = 800
    $infoPanel.Visibility = 'Visible'
    $titleTextBlock.Text = "Réseau"
    $infoTextBlock.Text = Show-NetworkInfo
}

New-Button -content "Sécurité" -row 1 -col 0 -clickAction {
    $window.Height = 400
    $infoPanel.Visibility = 'Visible'
    $titleTextBlock.Text = "Sécurité"
    $infoTextBlock.Text = Show-SecurityInfo
}

New-Button -content "Utilisateur" -row 1 -col 1 -clickAction {
    $window.Height = 400
    $infoPanel.Visibility = 'Visible'
    $titleTextBlock.Text = "Utilisateur"
    $infoTextBlock.Text = Show-UserInfo
}

New-Button -content "Performances" -row 1 -col 2 -clickAction {
    $window.Height = 800
    $infoPanel.Visibility = 'Visible'
    $titleTextBlock.Text = "Performances"
    $infoTextBlock.Text = Show-PerformanceInfo
}

# Ajouter la grille principale à la fenêtre et afficher la fenêtre
$window.Content = $mainGrid
$window.ShowDialog() | Out-Null

# Réactiver les messages de la console
$ErrorActionPreference = "Continue"