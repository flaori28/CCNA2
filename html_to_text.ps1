
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$inputFile = "full_page.html"
$outputFile = "scraped_content.txt"

if (-not (Test-Path $inputFile)) {
    Write-Host "File not found: $inputFile"
    exit
}

$html = Get-Content -Path $inputFile -Raw -Encoding UTF8

# Remove scripts, styles
$html = $html -replace '(?s)<script.*?</script>', ''
$html = $html -replace '(?s)<style.*?</style>', ''
$html = $html -replace '(?s)<head.*?</head>', ''

# Replace Images
# Regex: <img ... src="url" ... alt="text" ...>
# Naive approach:
$html = $html -replace '(?i)<img[^>]*src=["'']([^"'']+)["''][^>]*alt=["'']([^"'']*)["''][^>]*>', "`n![$2]($1)`n"

# Replace break tags
$html = $html -replace '(?i)<br\s*/?>', "`n"
$html = $html -replace '(?i)</p>', "`n`n"
$html = $html -replace '(?i)</div>', "`n"
$html = $html -replace '(?i)</tr>', "`n"
$html = $html -replace '(?i)</li>', "`n"

# Strip all tags
$text = $html -replace '<[^>]+>', ' '

# Decode HTML entities
Add-Type -AssemblyName System.Web
try {
    $decoded = [System.Web.HttpUtility]::HtmlDecode($text)
} catch {
    $decoded = $text.Replace("&nbsp;", " ").Replace("&amp;", "&").Replace("&quot;", "`"").Replace("&lt;", "<").Replace("&gt;", ">")
}

# Collapse whitespace
$clean = $decoded -replace '\s+', ' '
# Restore newlines manually or split by newlines preserved earlier?
# The stripped tags approach loses newlines if not replaced carefully.
# Let's fix newline handling:
# Regex split by newline chars if they survived? No, html has many newlines.
# We want to format it nicely.
# The previous `parse_v5.ps1` expects lines.
# So we should save it line by line.

# Better strategy: Replace semantic block tags with unique delimiters, then split.
# <br> -> \n
# </p> -> \n
# </div> -> \n
# </li> -> \n

# Re-run logic for clean text
# 1. Scripts/Styles gone.
# 2. Block tags to newlines.
# 3. Strip tags.
# 4. Decode entities.
# 5. Squeeze blank lines.

Set-Content -Path $outputFile -Value $decoded -Encoding UTF8
Write-Host "Done."
