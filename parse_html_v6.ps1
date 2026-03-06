
$htmlContent = Get-Content -Path "full_page.html" -Raw -Encoding utf8

# Normalize newlines
$htmlContent = $htmlContent -replace "`r`n", "`n"

# Split by question start pattern <p><strong>Number.
# using a regex split that keeps delimiters is hard in simple split, so we use regex matches.

# Regex to find the start index of each question
$matches = $htmlContent | Select-String -Pattern '<p><strong>(\d+)\.' -AllMatches
$indices = $matches.Matches | Select-Object -ExpandProperty Index

$questions = @()

for ($i = 0; $i -lt $indices.Count; $i++) {
    $startIndex = $indices[$i]
    if ($i -eq $indices.Count - 1) {
        $endIndex = $htmlContent.Length
    } else {
        $endIndex = $indices[$i+1]
    }
    
    $chunk = $htmlContent.Substring($startIndex, $endIndex - $startIndex)
    
    # 1. Parse ID and Question Text
    # Pattern: <p><strong>(\d+)\.\s*(.*?)</strong>
    # Note: The closing </strong> might be far away if there's an image inside?
    # Actually usually it's <p><strong>106. Text...</strong><br /> <img ... /></p>
    # So we look for the first </strong>
    
    $id = 0
    $text = ""
    if ($chunk -match '<p><strong>(\d+)\.(.*?)</strong>') {
        $id = $matches[1]
        $rawText = $matches[2]
        # Clean tags from text (like <br />)
        $text = $rawText -replace '<[^>]+>', ''
        $text = $text.Trim()
        
        # HTML decode text
        $text = [System.Web.HttpUtility]::HtmlDecode($text)
    }

    # 2. Extract Image
    # Look for <img ... src="..." ...>
    # It might be in the question <p> or in a <figure> after it.
    $imageSrc = ""
    # We want the FIRST image in this chunk, but before the <ul> options ideally, 
    # OR if it's inside the text.
    # Actually just grab the first jpg/png in the chunk.
    if ($chunk -match '<img[^>]+src="([^"]+)"') {
        $imageSrc = $matches[1]
    }

    # 3. Extract Options
    # Look for <ul> ... </ul>
    # And <li> inside.
    $options = @()
    $correctIndices = @()
    
    # Find the ul block
    if ($chunk -match '<ul>(.*?)</ul>') {
        $ulContent = $matches[1]
        
        # Find all LI matches
        $liPattern = '<li([^>]*)>(.*?)</li>'
        $liMatches = [regex]::Matches($ulContent, $liPattern, 'Singleline')
        
        $optIndex = 0
        foreach ($li in $liMatches) {
            $attrs = $li.Groups[1].Value
            $liText = $li.Groups[2].Value
            
            # Clean text
            $cleanOpt = $liText -replace '<[^>]+>', ''
            $cleanOpt = [System.Web.HttpUtility]::HtmlDecode($cleanOpt).Trim()
            
            $options += $cleanOpt
            
            if ($attrs -match 'correct_answer') {
                $correctIndices += $optIndex
            }
            $optIndex++
        }
    }

    # 4. Extract Explanation
    # Look for div class="message_box announce"
    $explanation = ""
    if ($chunk -match '<div class="message_box announce">(.*?)</div>') {
        $rawExpl = $matches[1]
        $explanation = $rawExpl -replace '<[^>]+>', ' '
        $explanation = [System.Web.HttpUtility]::HtmlDecode($explanation).Trim()
        # Clean extra whitespace
        $explanation = $explanation -replace '\s+', ' '
    }

    $qObj = [PSCustomObject]@{
        id = [int]$id
        question = $text
        options = $options
        correctIndices = $correctIndices
        explanation = $explanation
        image = $imageSrc
    }
    
    $questions += $qObj
}

# Convert to JSON
$json = $questions | ConvertTo-Json -Depth 5 -Compress
$json | Set-Content -Path "questions_v6.json" -Encoding utf8

Write-Host "Parsed $($questions.Count) questions."
