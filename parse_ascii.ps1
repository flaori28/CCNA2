
$path = ".\scraped_content.txt"
$content = Get-Content -Path $path -Raw -Encoding UTF8
$content = $content -replace "`r`n", "`n"

# Split by Number. Space
$chunks = $content -split "(?m)^\d+\.\s+"

$questions = @()
$idCounter = 1

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk) -or $chunk.Length -lt 10) { continue }
    if ($chunk -match "^Consent") { continue } 
    if ($chunk -notmatch "[a-zA-Z]") { continue }

    # Extract Explanation
    $explanation = ""
    if ($chunk -match "(?s)(Explication|Explique|Reponse)\s*[:\-]?(.*)") {
        $explanation = $matches[2].Trim()
        $chunk = $chunk -replace "(?s)(Explication|Explique|Reponse)\s*[:\-]?(.*)", ""
    }

    # Extract Image
    $image = $null
    if ($chunk -match "(?s)!\[.*?\]\((.*?)\)") {
        $image = $matches[1].Trim()
        if ($image -match "^(\S+)") { $image = $matches[1] }
        $chunk = $chunk -replace "(?s)!\[.*?\]\(.*?\)", ""
    }

    # Clean up garbage (ASCII only regex)
    $chunk = $chunk -replace "CCNA 2 SRWE.*?Reponses Francais", ""
    $chunk = $chunk -replace "# CCNA 2 Examen Final.*", ""
    $chunk = $chunk -replace "\.\.\.", ""
    $chunk = $chunk.Trim()

    # Extract Options
    $options = @()
    $qText = ""

    # Bullet regex: unicode 2022, or hyphen, or asterisk
    $bulletRegex = "(?s)[\x{2022}\-\*]\s+(.+?)(?=\s*[\x{2022}\-\*]|$)"
    
    $matchesIter = [regex]::Matches($chunk, $bulletRegex)
    
    if ($matchesIter.Count -gt 0) {
        foreach ($m in $matchesIter) {
            $options += $m.Groups[1].Value.Trim()
        }
        $splitPattern = "(?s)[\x{2022}\-\*]\s+"
        $splitByOpt = $chunk -split $splitPattern, 2
        $qText = $splitByOpt[0].Trim()
    } else {
        if ($chunk -match "\|") {
             $qText = $chunk
        } else {
             $qText = $chunk
             $lines = $chunk -split "`n"
             if ($lines.Count -gt 2) {
                 $qText = $lines[0].Trim()
                 for ($i=1; $i -lt $lines.Count; $i++) {
                     $line = $lines[$i].Trim()
                     if ($line.Length -gt 0) { $options += $line }
                 }
             }
        }
    }

    $qText = $qText -replace "^\d+\.\s*", ""
    $qText = $qText.Trim()

    $answer = ""
    if ($options.Count -gt 0) {
        $answer = $options[0]
        if ($explanation.Length -gt 0) {
            foreach ($opt in $options) {
                 $cleanOpt = $opt -replace "[.,;]$", ""
                 if ($explanation.Contains($cleanOpt)) {
                     $answer = $opt
                     break
                 }
            }
        }
    }
    
    # Check if answer is correctly identified, if not, try to match explanation start
    # Sometimes explanation says "Response: Option Text"
    
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
