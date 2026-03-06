
$path = ".\scraped_content.txt"
# Force UTF8 reading
$content = Get-Content -Path $path -Raw -Encoding UTF8
$content = $content -replace "`r`n", "`n"

# Split by Question Number
# Using regex split with multiline mode, matching "Digits. " at start of line
$chunks = $content -split "(?m)^\d{1,3}\.\s+"

$questions = @()
$idCounter = 1

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk) -or $chunk.Length -lt 10) { continue }
    if ($chunk -match "^Consent") { continue } 
    # Skip chunks that don't look like questions (no letters?)
    if ($chunk -notmatch "[a-zA-Z]") { continue }

    # Extract Explanation
    # Look for "Explication" or variants, followed by colon or hyphen, then rest of text
    $explanation = ""
    # Use regex with Singleline mode (?s) to match across newlines
    if ($chunk -match "(?s)(Explication|Explique|Réponse)\s*[:\-]?(.*)") {
        $explanation = $matches[2].Trim()
        # Remove explanation part from the chunk
        $chunk = $chunk -replace "(?s)(Explication|Explique|Réponse)\s*[:\-]?(.*)", ""
    }

    # Extract Image
    $image = $null
    if ($chunk -match "(?s)!\[.*?\]\((.*?)\)") {
        $image = $matches[1].Trim()
        # Clean up URL if it has trailing size info
        if ($image -match "^(\S+)") { $image = $matches[1] }
        # Remove image markdown
        $chunk = $chunk -replace "(?s)!\[.*?\]\(.*?\)", ""
    }

    # Clean up specific garbage strings
    # Escape parentheses in regex
    $chunk = $chunk -replace "CCNA 2 SRWE \(Version 7\.00\) – Examen final du cours SRWEv7 Réponses Français", ""
    $chunk = $chunk -replace "# CCNA 2 Examen Final de Cours SRWE v7\.0 Questions Réponses", ""
    $chunk = $chunk -replace "···", ""
    $chunk = $chunk.Trim()

    # Extract Options
    $options = @()
    $qText = ""

    # Regex for options: Bullet, whitespace, text, lookahead for next bullet or end
    # Bullet is \u2022, or hyphen -, or asterisk *
    # We use \x95 for bullet sometimes? Standard bullet is \u2022.
    # PowerShell regex uses .NET regex.
    # We use [\u2022\-\*]
    
    $optPattern = "(?s)[\u2022\-\*]\s+(.+?)(?=\s*[\u2022\-\*]|$)"
    $matchesIter = [regex]::Matches($chunk, $optPattern)
    
    if ($matchesIter.Count -gt 0) {
        foreach ($m in $matchesIter) {
            $options += $m.Groups[1].Value.Trim()
        }
        # Question text is before the first option
        $splitByOpt = $chunk -split "(?s)[\u2022\-\*]\s+", 2
        $qText = $splitByOpt[0].Trim()
    } else {
        # No bullets found.
        # Check for table
        if ($chunk -match "\|") {
             $qText = $chunk
        } else {
             $qText = $chunk
             # Try splitting by newline if looks like list
             $lines = $chunk -split "\n"
             if ($lines.Count -gt 2) {
                 $qText = $lines[0].Trim()
                 for ($i=1; $i -lt $lines.Count; $i++) {
                     $line = $lines[$i].Trim()
                     if ($line.Length -gt 0) { $options += $line }
                 }
             }
        }
    }

    # Remove residual numbering if any
    $qText = $qText -replace "^\d+\.\s*", ""
    $qText = $qText.Trim()

    # Find Answer
    $answer = ""
    # Default to first option
    if ($options.Count -gt 0) {
        $answer = $options[0]
        # Try to match explanation
        if ($explanation.Length -gt 0) {
            foreach ($opt in $options) {
                 # Remove punctuation from end
                 $cleanOpt = $opt -replace "[.,;]$", ""
                 if ($explanation.Contains($cleanOpt)) {
                     $answer = $opt
                     break
                 }
            }
        }
    }

    if ($qText.Length -gt 5) {
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

$json = $questions | ConvertTo-Json -Depth 5
$json | Set-Content -Path ".\questions.json" -Encoding UTF8
