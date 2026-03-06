
Add-Type -AssemblyName System.Web

$htmlPath = "$PSScriptRoot\full_page.html"
if (-not (Test-Path $htmlPath)) {
    Write-Host "File not found: $htmlPath" -ForegroundColor Red
    exit
}

$htmlContent = Get-Content -Path $htmlPath -Raw -Encoding utf8
# Normalize newlines to simplify regex
$htmlContent = $htmlContent -replace "`r`n", "`n"

# 1. Identify Question Blocks
# Pattern: <p><strong>Number.
$qPattern = '<p><strong>(\d+)\.(.*?)</strong>'
$questionMatches = [regex]::Matches($htmlContent, $qPattern)

$questions = @()

for ($i = 0; $i -lt $questionMatches.Count; $i++) {
    $match = $questionMatches[$i]
    $startIndex = $match.Index
    $id = $match.Groups[1].Value
    
    # Check bounds
    if ($i -lt $questionMatches.Count - 1) {
        $endIndex = $questionMatches[$i+1].Index
    } else {
        $endIndex = $htmlContent.Length
    }
    
    $chunkLength = $endIndex - $startIndex
    $chunk = $htmlContent.Substring($startIndex, $chunkLength)
    
    # --- Parse Within Chunk ---
    
    # Question Text
    # The question text starts after the number.
    # It might span multiple lines until the first <ul> or <figure> or before options.
    # We take everything from the start of the chunk until the first <ul or <div class="message_box">
    
    $splitByUL = $chunk -split '<ul'
    $preUL = $splitByUL[0]
    
    # Remove HTML tags to get raw text
    $qTextRaw = $preUL -replace '<[^>]+>', ' '
    # Remove the starting number "106. "
    $qTextRaw = $qTextRaw -replace "^\d+\.\s*", ""
    $qTextRaw = [System.Web.HttpUtility]::HtmlDecode($qTextRaw).Trim()
    $qTextRaw = $qTextRaw -replace '\s+', ' '
    
    # Image
    $imageSrc = $null
    # Look for image in the pre-UL part usually
    if ($chunk -match '<img[^>]+src="([^"]+)"') {
        $imageSrc = $matches[0].Groups[1].Value
    }
    
    # Options
    $options = @()
    $correctIndex = -1 # Default to none found
    
    # Find the FIRST <ul> block which contains the options
    if ($chunk -match '<ul>(.*?)</ul>') {
        $ulContent = $matches[0].Groups[1].Value
        
        # Parse LI items
        $liPattern = '<li(.*?)>(.*?)</li>'
        $liMatches = [regex]::Matches($ulContent, $liPattern, 'Singleline')
        
        $idx = 0
        foreach ($li in $liMatches) {
            $attrs = $li.Groups[1].Value
            $text = $li.Groups[2].Value
            
            # Clean text
            $cleanText = $text -replace '<[^>]+>', ''
            $cleanText = [System.Web.HttpUtility]::HtmlDecode($cleanText).Trim()
            
            $options += $cleanText
            
            if ($attrs -match 'correct_answer') {
                $correctIndex = $idx
            }
            $idx++
        }
    }
    
    # Explanation
    $explanation = ""
    if ($chunk -match '<div class="message_box announce">(.*?)</div>') {
        $explContent = $matches[0].Groups[1].Value
        $customText = $explContent -replace '<[^>]+>', ' '
        $customText = [System.Web.HttpUtility]::HtmlDecode($customText).Trim()
        $customText = $customText -replace '\s+', ' '
        $explanation = $customText
    }
    
    $qObj = [PSCustomObject]@{
        id = [int]$id
        question = $qTextRaw
        options = $options
        correct = $correctIndex
        explanation = $explanation
        image = $imageSrc
    }
    
    $questions += $qObj
}

$jsonPath = "$PSScriptRoot\questions.json"
$questions | ConvertTo-Json -Depth 5 | Set-Content -Path $jsonPath -Encoding utf8

Write-Host "Parsed $($questions.Count) questions."
