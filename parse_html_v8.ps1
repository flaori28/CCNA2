
Add-Type -AssemblyName System.Web

$htmlPath = "$PSScriptRoot\full_page.html"
if (-not (Test-Path $htmlPath)) {
    Write-Host "File not found: $htmlPath" -ForegroundColor Red
    exit
}

$htmlContent = Get-Content -Path $htmlPath -Raw -Encoding utf8
$htmlContent = $htmlContent -replace "`r`n", "`n"

# 1. Identify Question Blocks
$qPattern = '<p><strong>(\d+)\.(.*?)</strong>'
$questionMatches = [regex]::Matches($htmlContent, $qPattern)

$questions = @()

for ($i = 0; $i -lt $questionMatches.Count; $i++) {
    $match = $questionMatches[$i]
    $startIndex = $match.Index
    $id = $match.Groups[1].Value
    
    if ($i -lt $questionMatches.Count - 1) {
        $endIndex = $questionMatches[$i+1].Index
    } else {
        $endIndex = $htmlContent.Length
    }
    
    $chunkLength = $endIndex - $startIndex
    $chunk = $htmlContent.Substring($startIndex, $chunkLength)
    
    # --- Parse Within Chunk ---
    
    # 1. Image
    # Search whole chunk for image
    $imageSrc = $null
    $mImg = [regex]::Match($chunk, '<img[^>]+src="([^"]+)"')
    if ($mImg.Success) {
        $imageSrc = $mImg.Groups[1].Value
    }
    
    # 2. Options and Correct Answer
    # We strip the chunk before the first <ul> to isolate question text from options
    # Regex with Singleline option to match newlines
    $mUL = [regex]::Match($chunk, '<ul>(.*?)</ul>', 'Singleline')
    
    $options = @()
    $correctIndex = -1
    
    if ($mUL.Success) {
        $ulContent = $mUL.Groups[1].Value
        
        # Get question text as everything before this UL
        $preULBytes = $mUL.Index
        $preUL = $chunk.Substring(0, $preULBytes)
        
        # Parse LIs
        $liMatches = [regex]::Matches($ulContent, '<li(.*?)>(.*?)</li>', 'Singleline')
        
        $idx = 0
        foreach ($li in $liMatches) {
            $attrs = $li.Groups[1].Value
            $text = $li.Groups[2].Value
            
            $cleanText = $text -replace '<[^>]+>', ''
            $cleanText = [System.Web.HttpUtility]::HtmlDecode($cleanText).Trim()
            
            $options += $cleanText
            
            if ($attrs -match 'correct_answer') {
                $correctIndex = $idx
            }
            $idx++
        }
    } else {
        # No UL found? Maybe question text is whole chunk?
        $preUL = $chunk
    }
    
    # 3. Clean Question Text
    # Remove tags
    $qTextRaw = $preUL -replace '<[^>]+>', ' '
    # Remove ID prefix "106. "
    $qTextRaw = $qTextRaw -replace "^\d+\.\s*", ""
    $qTextRaw = [System.Web.HttpUtility]::HtmlDecode($qTextRaw).Trim()
    $qTextRaw = $qTextRaw -replace '\s+', ' '
    
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
