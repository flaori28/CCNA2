
$content = Get-Content -Path ".\scraped_content.txt" -Raw -Encoding UTF8

# Normalize newlines
$content = $content -replace "`r`n", "`n"

# Split by Question Number (Lookahead validation to ensure it's at start of line)
# Regex: Newline followed by digits, a dot, and a space.
$chunks = $content -split "`n(?=\d+\. )"

$questions = @()

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk)) { continue }

    $lines = $chunk -split "`n"
    
    # First line often contains the number, e.g. "1. Question..."
    # We remove the number.
    $firstLine = $lines[0] -replace "^\d+\.\s*", ""
    
    $questionText = $firstLine
    $options = @()
    $image = $null
    $explanation = ""
    $parsingOptions = $false
    $parsingExplanation = $false

    for ($i = 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -match "^\s*···") { continue } # Skip separator

        # Check for Image
        if ($line -match "!\[.*\]\((.*)\)") {
            $image = $matches[1]
            continue
        }

        # Check for Options
        if ($line -match "^• (.*)") {
            $parsingOptions = $true
            $optText = $matches[1].Trim()
            $options += $optText
            continue
        }
        
        # Check for Matching/Table questions (start with |)
        if ($line -match "^\|") {
             # Handle tables as part of question text or options?
             # For now, append to question text if no options yet
             if (-not $parsingOptions) {
                 $questionText += "`n" + $line
             }
             continue
        }

        # Check for Explanation
        if ($line -match "^Explication" -or $line -match "^Explique") {
            $parsingExplanation = $true
        }

        if ($parsingExplanation) {
            $explanation += $line + " "
        } elseif ($parsingOptions) {
            # Could be multi-line option? Or just next option
            # Assuming single line options for now or bulleted
        } else {
            # Still in question text
            if ($line -notmatch "^•") {
                $questionText += " " + $line
            }
        }
    }

    $questionText = $questionText.Trim()
    
    # Simple heuristic for answer: check if explanation contains the option text
    $correctAnswer = ""
    if ($options.Count -gt 0) {
        $correctAnswer = $options[0] # Default
        
        # Try to find exact match in explanation
        foreach ($opt in $options) {
             # Remove punctuation for comparison
             $cleanOpt = $opt -replace "[.,;]", ""
             if ($explanation.Contains($cleanOpt)) {
                 $correctAnswer = $opt
                 break
             }
        }
    }

    if ($questionText.Length -gt 2) {
        $obj = [Ordered]@{
            question = $questionText
            options = $options
            answer = $correctAnswer
            image = $image
        }
        $questions += $obj
    }
}

$questions | ConvertTo-Json -Depth 5 | Set-Content -Path ".\questions.json" -Encoding UTF8
