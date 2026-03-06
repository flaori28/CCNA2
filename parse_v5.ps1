
# Set output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$filePath = "c:\Users\Flavio\Desktop\Site_Web_CCNA2\scraped_content.txt"
if (-not (Test-Path $filePath)) {
    Write-Host "File not found."
    exit
}

$content = Get-Content -Path $filePath -Raw -Encoding UTF8
$content = $content -replace "`r`n", "`n"

# Remove known garbage headers globally
# Note: Using regex with dot matching newline for some multi-line headers if needed, 
# but mostly they are single lines in the text file.
$headersToRemove = @(
    "# CCNA 2 Examen Final de Cours SRWE v7.0 Questions Reponses",
    "### CCNA 2 SRWE \(Version 7.00\) .*? Reponses Francais",
    "CCNA 2 ENSA .*? Reponses Francais \d+",
    "#### ARTICLES LI.S",
    "Consent to Cookies.*?(?=1\.\s)"
)

foreach ($header in $headersToRemove) {
    $content = $content -replace "(?i)$header", ""
}

# Remove ... lines
$content = $content -replace "(?m)^\s*\.{3,}\s*$", ""
$content = $content -replace "(?m)^\s*···\s*$", ""
$content = $content -replace "\.{3,}", "" # Remove inline ellipses if they are junk

# Split by "Number. " at start of line
$chunks = $content -split "(?m)^\d+\.\s+"

$questions = @()
$id = 1

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk)) { continue }
    if ($chunk.Length -lt 10) { continue }
    
    $lines = $chunk -split "`n"
    
    $qText = ""
    $options = @()
    $explanation = ""
    $imgUrl = $null
    
    $mode = "question" # question, options, explanation
    
    foreach ($line in $lines) {
        $line = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        
        # Check for start of Explanation
        if ($line -match "^(Explication|Explique|Reponse)\s*[:\-]?") {
            $mode = "explanation"
            # Remove the label "Explication :" from the line
            $line = $line -replace "^(Explication|Explique|Reponse)\s*[:\-]?", ""
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
        }
        
        # Check for Image
        if ($line -match "!\[.*?\]\((.*?)\)") {
            $imgUrl = $matches[1].Trim()
            # Remove image markdown from line
            $line = $line -replace "!\[.*?\]\(.*?\)", ""
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
        }
        
        # Check for Option start
        # Bullet char \u2022 is •. Also check - and *
        if ($line -match "^[\u2022\-\*]\s+") {
            $mode = "options"
            # Remove bullet
            $optText = $line -replace "^[\u2022\-\*]\s+", ""
            $options += $optText
            continue
        }
        
        # Process content based on mode
        if ($mode -eq "question") {
            $qText += " " + $line
        }
        elseif ($mode -eq "options") {
            # Append to last option if it exists (multiline option)
            if ($options.Count -gt 0) {
                $lastIndex = $options.Count - 1
                $options[$lastIndex] += " " + $line
            } else {
                # Weird case: option text without bullet? Treat as question continued?
                # Or just start a new option?
                # Let's assume it belongs to question if no options yet
                $qText += " " + $line 
            }
        }
        elseif ($mode -eq "explanation") {
            $explanation += " " + $line
        }
    }
    
    # Cleanup
    $qText = $qText.Trim()
    $explanation = $explanation.Trim()
    
    if ($qText.Length -gt 0) {
        # Try to find answer in explanation
        # e.g. "Reponse: C" or just rely on explanation
        
        $obj = [PSCustomObject]@{
            id = $id
            question = $qText
            options = $options
            answer = $explanation # Temporary, needs manual verification
            explanation = $explanation
            image = $imgUrl
        }
        $questions += $obj
        $id++
    }
}

$json = $questions | ConvertTo-Json -Depth 5
Set-Content -Path "c:\Users\Flavio\Desktop\Site_Web_CCNA2\questions.json" -Value $json -Encoding UTF8
Write-Host "Parsed $($questions.Count) questions."
