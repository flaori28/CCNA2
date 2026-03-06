
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputFile = "full_page.html"
$outputFile = "scraped_content.txt"

if (-not (Test-Path $inputFile)) {
    Write-Host "File not found: $inputFile"
    exit
}

# Read content as a single string
$html = Get-Content -Path $inputFile -Raw -Encoding UTF8

# Remove scripts, styles, head
$html = $html -replace '(?s)<script.*?</script>', ''
$html = $html -replace '(?s)<style.*?</style>', ''
$html = $html -replace '(?s)<head.*?</head>', ''

# Replace Images with markdown format ![alt](src)
# This regex handles src and alt attributes in any order
# Case 1: src then alt
$html = $html -replace '(?i)<img[^>]*src=["'']([^"'']+)["''][^>]*alt=["'']([^"'']*)["''][^>]*>', "`n![$2]($1)`n"
# Case 2: alt then src
$html = $html -replace '(?i)<img[^>]*alt=["'']([^"'']*)["''][^>]*src=["'']([^"'']+)["''][^>]*>', "`n![$1]($2)`n"
# Case 3: src only (empty alt)
$html = $html -replace '(?i)<img[^>]*src=["'']([^"'']+)["''][^>]*>', "`n![]($1)`n"

# Replace semantic block tags with newlines to preserve structure
$html = $html -replace '(?i)<br\s*/?>', "`n"
$html = $html -replace '(?i)</p>', "`n`n"
$html = $html -replace '(?i)</div>', "`n"
$html = $html -replace '(?i)</li>', "`n"
$html = $html -replace '(?i)</tr>', "`n"
# Replace list items with dashes for bullet points
$html = $html -replace '(?i)<li>', "`n- " 

# Strip all remaining HTML tags
$text = $html -replace '<[^>]+>', ' '

# Decode HTML entities
Add-Type -AssemblyName System.Web 2>$null
if ([System.Web.HttpUtility]::HtmlDecode("test") -eq "test") {
    $text = [System.Web.HttpUtility]::HtmlDecode($text)
} else {
    # Fallback for basic entities
    $text = $text.Replace("&nbsp;", " ").Replace("&lt;", "<").Replace("&gt;", ">").Replace("&amp;", "&").Replace("&quot;", "`"")
}

# Normalize whitespace
# Split by lines, trim each line, filter empty lines
$lines = $text -split "`n"
$cleanLines = @()
foreach ($line in $lines) {
    if (-not [string]::IsNullOrWhiteSpace($line)) {
        $cleanLines += $line.Trim()
    }
}
$finalText = $cleanLines -join "`n"

Set-Content -Path $outputFile -Value $finalText -Encoding UTF8
Write-Host "Converted HTML to text successfully."
