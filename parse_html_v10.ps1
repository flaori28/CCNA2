
Add-Type -AssemblyName System.Web

$htmlPath = "$PSScriptRoot\full_page.html"
if (-not (Test-Path $htmlPath)) {
    Write-Host "File not found: $htmlPath" -ForegroundColor Red
    exit
}

$htmlContent = Get-Content -Path $htmlPath -Raw -Encoding utf8
# Remove Windows line endings to simplify regex if needed, though Singleline usually handles it.
# $htmlContent = $htmlContent -replace "`r`n", "`n" 

# Regex Explanation:
# <\s*p[^>]*>          : Matches <p> with optional attributes
# \s*                  : Optional whitespace
# <\s*(?:strong|b)[^>]*>: Matches <strong> or <b>
# \s*                  : Optional whitespace
# (\d+)                : Capture Group 1: Question Number
# \.?                  : Optional literal dot (matches "50" and "50.")
# \s+                  : Required whitespace (separates number from text)
# (.*?)                : Capture Group 2: The text inside the bold tag
# <\/\s*(?:strong|b)\s*>: Closing bold tag

$qPattern = '<\s*p[^>]*>\s*<\s*(?:strong|b)[^>]*>\s*(\d+)\.?\s+(.*?)<\/\s*(?:strong|b)\s*>'
$questionMatches = [regex]::Matches($htmlContent, $qPattern, 'Singleline,IgnoreCase')

$questions = @()

Write-Host "Found $($questionMatches.Count) matches."

for ($i = 0; $i -lt $questionMatches.Count; $i++) {
    $match = $questionMatches[$i]
    $startIndex = $match.Index
    $id = [int]$match.Groups[1].Value
    $inlineText = $match.Groups[2].Value

    if ($i -lt $questionMatches.Count - 1) {
        $endIndex = $questionMatches[$i+1].Index
    } else {
        $endIndex = $htmlContent.Length
    }

    $chunkLength = $endIndex - $startIndex
    $chunk = $htmlContent.Substring($startIndex, $chunkLength)

    # --- Parse Chunk ---
    
    # 1. Image (look for img inside the chunk)
    $imageSrc = $null
    # Simple regex for src. Be careful of "lazy" matches.
    $mImg = [regex]::Match($chunk, '<img[^>]+src="([^"]+)"')
    if ($mImg.Success) {
        $imageSrc = $mImg.Groups[1].Value
    }

    # 2. Options (<ul>...</ul>) and Correct Answers
    # The <ul> usually follows the <p>Title</p>
    $mUL = [regex]::Match($chunk, '<ul>(.*?)</ul>', 'Singleline')
    
    $optionsArr = @()
    $correctIndices = @()

    if ($mUL.Success) {
        $ulContent = $mUL.Groups[1].Value
        # Parse <li> items
        $liMatches = [regex]::Matches($ulContent, '<li(.*?)>(.*?)</li>', 'Singleline')
        
        $idx = 0
        foreach ($li in $liMatches) {
            $attrs = $li.Groups[1].Value
            $text = $li.Groups[2].Value
            
            # Clean text
            $cleanText = $text -replace '<[^>]+>', ''
            $cleanText = [System.Web.HttpUtility]::HtmlDecode($cleanText).Trim()
            
            $optionsArr += $cleanText
            
            # Check for correct answer class/attribute or style
            if ($attrs -match 'correct_answer' -or $attrs -match 'color:\s*red') {
                $correctIndices += $idx
            }
            $idx++
        }
    }

    # 3. Question Text
    # The text we captured in Group 2 is just the bold part. 
    # The question text might continue after the bold part, OR be entirely in Group 2.
    # Usually in this file, it's all in the bold part.
    # We clean it up.
    $qText = $inlineText -replace '<[^>]+>', ''
    $qText = [System.Web.HttpUtility]::HtmlDecode($qText).Trim()

    # 4. Explanation
    $explanation = ""
    $mExpl = [regex]::Match($chunk, '<div class="message_box announce">(.*?)</div>', 'Singleline')
    if ($mExpl.Success) {
        $explRaw = $mExpl.Groups[1].Value
        $cleanExpl = $explRaw -replace '<[^>]+>', ' '
        $cleanExpl = [System.Web.HttpUtility]::HtmlDecode($cleanExpl).Trim()
        $cleanExpl = $cleanExpl -replace '\s+', ' '
        $explanation = $cleanExpl
    }

    $qObj = [PSCustomObject]@{
        id = $i + 1
        original_id = $id
        question = $qText
        options = $optionsArr
        correct = $correctIndices
        explanation = $explanation
        image = $imageSrc
    }

    $questions += $qObj
}

# Save new JSON
$jsonPath = "$PSScriptRoot\questions.json"
$questions | ConvertTo-Json -Depth 5 | Set-Content -Path $jsonPath -Encoding utf8

# Check for missing
$foundIds = $questions | Select-Object -ExpandProperty id
$maxId = ($foundIds | Measure-Object -Maximum).Maximum
$missing = (1..$maxId) | Where-Object { $foundIds -notcontains $_ }

Write-Host "Max ID: $maxId"
Write-Host "Missing IDs: $($missing -join ', ')"
Write-Host "JSON saved to $jsonPath"
