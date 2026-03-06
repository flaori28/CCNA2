
# Set UTF-8 encoding for console output
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$path = "c:\Users\Flavio\Desktop\Site_Web_CCNA2\scraped_content.txt"
if (-not (Test-Path $path)) {
    Write-Host "File not found: $path" -ForegroundColor Red
    exit
}

# Read content as a single string
$content = Get-Content -Path $path -Raw -Encoding UTF8

# Normalize newlines
$content = $content -replace "`r`n", "`n"

# 1. Clean up known garbage headers
$content = $content -replace "# CCNA 2 Examen Final de Cours SRWE v7.0 Questions Réponses", ""
$content = $content -replace "### CCNA 2 SRWE \(Version 7.00\) – Examen final du cours SRWEv7 Réponses Français", ""
$content = $content -replace "CCNA 2 ENSA .*?Réponses Français \d+", ""
$content = $content -replace "#### ARTICLES LIÉS", ""
$content = $content -replace "Consent to Cookies.*?(?=1\.\s)", ""

# 2. Split into blocks based on "Number. " pattern at start of line
$chunks = $content -split "(?m)^\d+\.\s+"

$jsonOutput = @()
$idCounter = 1

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk)) { continue }
    if ($chunk.Length -lt 10) { continue }
    
    $cleanChunk = $chunk.Trim()
    
    # Init variables
    $questionText = ""
    $optionsList = @()
    $answerText = ""
    $explanationText = ""
    $imageUrl = $null

    # Extract Explanation
    if ($cleanChunk -match "(?is)(Explication|Explique|Reponse)\s*[:\-]?(.*)") {
        $explanationText = $matches[2].Trim()
        $cleanChunk = $cleanChunk -replace "(?is)(Explication|Explique|Reponse)\s*[:\-]?(.*)", ""
    }

    # Extract Image
    if ($cleanChunk -match "!\[.*?\]\((.*?)\)") {
        $imageUrl = $matches[1].Trim()
        $cleanChunk = $cleanChunk -replace "!\[.*?\]\(.*?\)", ""
    }

    # Extract Options (Bullets •, -, *)
    # Use \u2022 for bullet point
    $bulletPattern = "(?m)^[\u2022\-\*]\s+"
    
    # Split by bullets
    $parts = $cleanChunk -split $bulletPattern
    
    if ($parts.Count -gt 1) {
        # First part is question
        $questionText = $parts[0].Trim()
        
        # Rest are options
        for ($i = 1; $i -lt $parts.Count; $i++) {
            $opt = $parts[$i].Trim()
            if (-not [string]::IsNullOrWhiteSpace($opt)) {
                $optionsList += $opt
            }
        }
    } else {
        # Fallback: No bullets found
        $questionText = $cleanChunk.Trim()
    }
    
    # Try to extract answer from explanation (simple heuristic)
    # Often "Reponse: B" or similar
    if ($explanationText -match "Réponse\s*:?\s*([A-Z])") {
         # logic to map letter to index if options exist? Complex without ordered options.
         # For now, store the raw explanation as a hint.
    }

    $obj = [PSCustomObject]@{
        id = $idCounter
        question = $questionText
        options = $optionsList
        answer = $explanationText # Using explanation as answer source for now
        image = $imageUrl
    }
    
    $jsonOutput += $obj
    $idCounter++
}

# Output valid JSON
$jsonString = $jsonOutput | ConvertTo-Json -Depth 5
Set-Content -Path "c:\Users\Flavio\Desktop\Site_Web_CCNA2\questions.json" -Value $jsonString -Encoding UTF8

Write-Host "Done. Parsed $($jsonOutput.Count) questions to questions.json"
