
# Set output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$filePath = "c:\Users\Flavio\Desktop\Site_Web_CCNA2\scraped_content.txt"
if (-not (Test-Path $filePath)) {
    Write-Host "File not found."
    exit
}

$content = Get-Content -Path $filePath -Raw -Encoding UTF8
$content = $content -replace "`r`n", "`n"

# Remove recurring headers using ASCII wildcard patterns
# Original: # CCNA 2 Examen Final de Cours SRWE v7.0 Questions Reponses
$content = $content -replace "# CCNA 2 Examen Final de Cours SRWE v7\.0 Questions R.ponses", ""
# Original: ### CCNA 2 SRWE (Version 7.00) - Examen final du cours SRWEv7 Reponses Francais
# Note: The dash might be en-dash or hyphen. The 'Reponses' has accent.
$content = $content -replace "### CCNA 2 SRWE \(Version 7\.00\) . Examen final du cours SRWEv7 R.ponses Fran.ais", ""
# remove linked articles
$content = $content -replace "#### ARTICLES LI.S", ""
# remove cookie consent
$content = $content -replace "(?s)^.*?Consent to Cookies.*?(?=1\.\s)", ""

# Split by "Number. " at start of line
$chunks = $content -split "(?m)^\d+\.\s+"

$outputRegex = [regex]"(?is)(Explication|Explique|Reponse)\s*[:\-]?(.*)"
$imageRegex = [regex]"!\[.*?\]\((.*?)\)"
# Bullet: \u2022 (bullet), - (hyphen), * (asterisk)
$bulletPattern = "(?m)^[\u2022\-\*]\s+"

$questions = @()
$id = 1

foreach ($chunk in $chunks) {
    if ([string]::IsNullOrWhiteSpace($chunk)) { continue }
    if ($chunk.Length -lt 10) { continue }
    
    $txt = $chunk.Trim()
    
    # Extract Explanation
    $explanation = ""
    if ($outputRegex.IsMatch($txt)) {
        $matches = $outputRegex.Match($txt)
        $explanation = $matches.Groups[2].Value.Trim()
        $txt = $outputRegex.Replace($txt, "")
    }
    
    # Extract Image
    $imgUrl = $null
    if ($imageRegex.IsMatch($txt)) {
        $matches = $imageRegex.Match($txt)
        $imgUrl = $matches.Groups[1].Value.Trim()
        $txt = $imageRegex.Replace($txt, "")
    }
    
    # Split Question / Options
    $parts = $txt -split $bulletPattern
    $qBody = ""
    $opts = @()
    
    if ($parts.Count -gt 1) {
        $qBody = $parts[0].Trim()
        for ($i=1; $i -lt $parts.Count; $i++) {
            $o = $parts[$i].Trim()
            if ($o.Length -gt 0) { $opts += $o }
        }
    } else {
        $qBody = $txt.Trim()
    }
    
    if ($qBody.Length -gt 0) {
        $obj = [PSCustomObject]@{
            id = $id
            question = $qBody
            options = $opts
            answer = $explanation # Placeholder
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
