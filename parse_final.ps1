
$path = ".\scraped_content.txt"
$content = Get-Content -Path $path -Raw -Encoding UTF8
$content = $content -replace "`r`n", "`n"

# Split by Question Number
# The regex (?m)^\d+\.\s+ works if there are line breaks before numbers.
$chunks = $content -split "(?m)^\d{1,3}\.\s+"
if ($chunks.Count -lt 2) {
    # If standard split failed, try to split by known patterns or just look for "1. ", "2. "
    Write-Host "Initial split failed, trying regex split on 'number dot space'"
    $chunks = [regex]::Split($content, "(?m)^\d+\.\s+")
}

$questions = @()
$idCounter = 1

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk) -or $chunk.Length -lt 10) { continue }
    if ($chunk -match "^Consent") { continue } 
    if ($chunk -notmatch "[a-zA-Z]") { continue }

    # Extract Explanation (from end of chunk usually)
    $explanation = ""
    if ($chunk -match "(?s)(Explication|Explique|Réponse)\s*[:\-]?(.*)") {
        $explanation = $matches[2].Trim()
        # Remove explanation block from chunk text
        $chunk = $chunk -replace "(?s)(Explication|Explique|Réponse)\s*[:\-]?(.*)", ""
    }

    # Extract Image
    $image = $null
    if ($chunk -match "(?s)!\[.*?\]\((.*?)\)") {
        $image = $matches[1].Trim()
        # Clean up URL (sometimes has size info after space)
        if ($image -match "^(\S+)") { $image = $matches[1] }
        # Remove image markdown
        $chunk = $chunk -replace "(?s)!\[.*?\]\(.*?\)", ""
    }

    # Clean up specific garbage strings
    $chunk = $chunk -replace "CCNA 2 SRWE \(Version 7.00\) – Examen final du cours SRWEv7 Réponses Français", ""
    $chunk = $chunk -replace "# CCNA 2 Examen Final de Cours SRWE v7.0 Questions Réponses", ""
    $chunk = $chunk -replace "···", ""
    $chunk = $chunk.Trim()

    # Extract Options
    $options = @()
    $qText = ""

    # Check for bullets
    # Regex: find 'bullet' followed by text, non-greedy, until next bullet or end of string
    # (?s) makes dot match newlines
    $optPattern = "(?s)[•\-\*]\s+(.+?)(?=\s*[•\-\*]|$)"
    $matchesIter = [regex]::Matches($chunk, $optPattern)
    
    if ($matchesIter.Count -gt 0) {
        foreach ($m in $matchesIter) {
            $options += $m.Groups[1].Value.Trim()
        }
        # The question text is everything before the first valid option match
        $splitByOpt = $chunk -split "(?s)[•\-\*]\s+", 2
        $qText = $splitByOpt[0].Trim()
    } else {
        # No bullets found. Could be a matching question (table) or plain text.
        # If it contains "|", it's a table.
        if ($chunk -match "\|") {
             # Keep table structure as part of question text
             $qText = $chunk
        } else {
             $qText = $chunk
             # If no options, maybe separate lines are options?
             # Check for lines starting with lowercase letters?
             # Heuristic: split by newline if > 2 lines
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

    # Clean up Question Text
    $qText = $qText -replace "^\d+\.\s*", "" # Remove number if present at start (redundant check)
    $qText = $qText.Trim()

    # Find Answer
    $answer = ""
    # Strategy: Look for option text in Explanation
    if ($explanation.Length -gt 0 -and $options.Count -gt 0) {
        # Try to find exact match
        foreach ($opt in $options) {
             # Remove common trailing punctuation and spaces
             $cleanOpt = $opt -replace "[.,;]$", ""
             if ($explanation.Contains($cleanOpt)) {
                 $answer = $opt
                 break
             }
        }
        # Backup strategy: if explanation mentions "Option A" or similar?
        # Unlikely in this format.
    }
    
    # If no answer found, default to first option (for quiz functionality)
    if ([string]::IsNullOrEmpty($answer) -and $options.Count -gt 0) {
        $answer = $options[0]
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
