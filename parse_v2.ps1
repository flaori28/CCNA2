
$path = ".\scraped_content.txt"
$content = Get-Content -Path $path -Raw -Encoding UTF8

# Normalize newlines
$content = $content -replace "`r`n", "`n"

# Split content by "Number. " at start of a line
# Using regex split
$chunks = $content -split "`n(?=\d{1,3}\. )"

$questions = @()

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk)) { continue }

    $lines = $chunk -split "`n"
    
    # First line often contains the number, e.g. "1. Question..."
    if ($lines[0] -match "^(\d+)\.\s+(.*)") {
        $id = $matches[1]
        $firstLine = $matches[2].Trim()
    } else {
        continue
    }

    $qText = $firstLine
    $options = @()
    $image = $null
    $explanation = ""
    $inExplanation = $false
    
    for ($i = 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -match "^\s*···") { continue } # Skip separator
        if ($line -match "^#") { continue } # Skip headers

        # Mark explanation block
        if ($line -match "^Explication" -or $line -match "^Explique") {
            $inExplanation = $true
            # remove "Explication :" or "Explique :"
            $line = $line -replace "^Expli(cation|que)\s*[:\-]?", ""
        }

        if ($inExplanation) {
            $explanation += $line + " "
        } else {
            # Check for Image
            if ($line -match "!\[.*?\]\((.*?)\)") {
                $image = $matches[1]
                continue
            }

            # Check for bullet point options
            if ($line -match "^[•\-\*]\s*(.*)") {
                $opt = $matches[1].Trim()
                $options += $opt
            } else {
                # Could be table row (often formatted with |)
                if ($line -match "^\|") {
                    # Append table row to question text (usually formatted tables)
                    # Use newlines to preserve table structure
                    $qText += "`n" + $line
                } else {
                    # Continuation of question or option?
                    # If we have options, maybe append to last option?
                    if ($options.Count -gt 0) {
                         $lastOptIndex = $options.Count - 1
                         $options[$lastOptIndex] += " " + $line
                    } else {
                         # Continuation of question text
                         $qText += " " + $line
                    }
                }
            }
        }
    }

    $qText = $qText.Trim()
    $explanation = $explanation.Trim()
    
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

    if ($options.Count -gt 0) {
        $obj = [Ordered]@{
            id = [int]$id
            question = $qText
            options = $options
            answer = $answer
            image = $image
            explanation = $explanation
        }
        $questions += $obj
    }
}

$questions | ConvertTo-Json -Depth 5 | Set-Content -Path ".\questions.json" -Encoding UTF8
