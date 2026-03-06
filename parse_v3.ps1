
try {
$path = ".\scraped_content.txt"
$content = Get-Content -Path $path -Raw -Encoding UTF8

# Normalize newlines
$content = $content -replace "`r`n", "`n"

# Split content by "Number. " at start of a line
# Using regex split with multiline mode (?m)
# Also handling varying spaces after dot
$chunks = $content -split "(?m)^\d{1,3}\.\s+"

$questions = @()

# $chunks[0] is the header (before "1. "), verify it doesn't start with a number.

$idCounter = 1

# Iterate through chunks, skipping the first one if it's header junk
for ($k = 0; $k -lt $chunks.Count; $k++) {
    $chunk = $chunks[$k]
    
    # Check if this chunk is likely a question
    # Heuristic: if it's the first chunk and very long/doesn't look like a question, skip.
    if ($k -eq 0 -and $chunk -notmatch "command") { 
        # Header junk usually starts with "Consent..."
        if ($chunk -match "Consent") { continue }
    }
    
    if ([string]::IsNullOrWhiteSpace($chunk)) { continue }

    # Split lines
    $lines = $chunk -split "\n"
    
    # First line is question text
    $qText = $lines[0].Trim()
    
    $options = @()
    $image = $null
    $explanation = ""
    $inExplanation = $false
    
    for ($i = 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -match "^\s*···") { continue } 
        if ($line -match "^#") { continue } 
        if ($line -match "^\.\.\.") { continue }

        # Check for Explanation
        if ($line -match "^Expli(cation|que|ain)\s*[:\-]?" -or $line -match "^Expl\s*[:\-]?" -or $line -match "^Réponse\s*:") {
            $inExplanation = $true
            # remove trigger word
            $line = $line -replace "^Expli(cation|que|ain)\s*[:\-]?", ""
            $line = $line -replace "^Expl\s*[:\-]?", ""
             $line = $line -replace "^Réponse\s*:", ""
        }

        if ($inExplanation) {
            $explanation += $line + " "
        } else {
            # Check for Image
            if ($line -match "!\[.*?\]\((.*?)\)") {
                $image = $matches[1]
                # Sometimes URL is followed by size
                if ($image -match "^(\S+)\s*") { 
                    $image = $matches[1].Trim() 
                }
                continue
            }

            # Check for bullet points
            # We look for lines starting with bullet char
            if ($line -match "^[•\-\*]\s*(.*)") {
                $opt = $matches[1].Trim()
                $options += $opt
            } else {
                # Table row
                if ($line -match "^\|") {
                    $qText += "`n" + $line
                } else {
                    # Continuation
                    if ($options.Count -gt 0) {
                         $options[$options.Count - 1] += " " + $line
                    } else {
                         $qText += " " + $line
                    }
                }
            }
        }
    }

    $qText = $qText.Trim()
    $explanation = $explanation.Trim()
    
    # Clean up garbage
    $qText = $qText -replace "CCNA 2 SRWE \(Version 7.00\) – Examen final du cours SRWEv7 Réponses Français", ""
    $qText = $qText -replace "# CCNA 2 Examen Final de Cours SRWE v7.0 Questions Réponses", ""
    $qText = $qText -replace "\.\.\.", ""
    $qText = $qText.Trim()

    # Find answer
    $answer = ""
    if ($options.Count -gt 0) {
        $answer = $options[0] # Default
        foreach ($opt in $options) {
             # Remove punctuation
             $cleanOpt = $opt -replace "[.,;]$", ""
             if ($explanation.Contains($cleanOpt)) {
                 $answer = $opt
                 break
             }
        }
    }

    if ($qText.Length -gt 5 -and $options.Count -gt 1) {
        $obj = [Ordered]@{
            id = $idCounter
            question = $qText
            options = $options
            answer = $answer
            image = $image
            explanation = $explanation
        }
        $questions += $obj
        $idCounter++
    }
}

$questions | ConvertTo-Json -Depth 5 | Set-Content -Path ".\questions.json" -Encoding UTF8
} catch {
    Write-Error $_
}
