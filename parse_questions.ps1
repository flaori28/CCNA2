
$htmlContent = Get-Content -Raw "c:\Users\Flavio\Desktop\Site_Web_CCNA2\page_content.html"

# Fix some common HTML issues for easier regex matching if needed
# But regex is usually robust enough if written well.

$questionsList = @()

# Regex to capture each question block:
# Look for <p><strong>NUMBER. Question...
# Capture until the next <p><strong>NUMBER. or end of string.
$questionPattern = '(?ms)<p><strong>(\d+)\.\s*(.*?)<\/strong><\/p>(.*?)(?=<p><strong>\d+\.\s|<!--|<h3>|$)'

$matches = [regex]::Matches($htmlContent, $questionPattern)

Write-Host "Found $($matches.Count) question blocks."

foreach ($match in $matches) {
    $id = [int]$match.Groups[1].Value
    $rawQuestion = $match.Groups[2].Value
    $body = $match.Groups[3].Value

    # Decode HTML info in question
    $questionText = [System.Net.WebUtility]::HtmlDecode($rawQuestion)
    $questionText = $questionText -replace '<[^>]+>', '' # Remove any lingering tags
    $questionText = $questionText.Trim()

    # Extract Image URL
    $imgUrl = $null
    if ($body -match '<img[^>]+src="([^"]+)"') {
        $imgUrl = $matches[1]
    }

    # Extract Options (UL/LI based)
    $options = @()
    $correctAnswerIndex = -1
    
    # Regex for LIs. We need to handle class="correct_answer" in the LI or a span inside.
    $liPattern = '(?ms)<li(.*?)>(.*?)<\/li>'
    $lis = [regex]::Matches($body, $liPattern)

    # Debugging first question
    if ($id -eq 1) {
        Write-Host "Match Groups Count: $($match.Groups.Count)"
        Write-Host "Group 0 Length: $($match.Groups[0].Value.Length)"
        Write-Host "Group 1 (ID): $($match.Groups[1].Value)"
        Write-Host "Group 2 (Text): $($match.Groups[2].Value)"
        Write-Host "Group 3 (Body): '$($match.Groups[3].Value)'"
    }

    if ($lis.Count -gt 0) {
        $currentIndex = 0
        foreach ($li in $lis) {
            $liAttributes = $li.Groups[1].Value
            $liContent = $li.Groups[2].Value

            # Check correctness
            $isCorrect = $false
            if ($liAttributes -match 'correct_answer') { $isCorrect = $true }
            if ($liContent -match 'class="correct_answer"') { $isCorrect = $true }
            # Sometimes it's <span style="color: #ff0000;"> or similar if class is missing, 
            # but the user prompt implies 'bold marked' or 'correct'. 
            # Looking at file content: <li class="correct_answer"> is standard here.

            # Clean content
            $cleanOption = [System.Net.WebUtility]::HtmlDecode($liContent)
            $cleanOption = $cleanOption -replace '<[^>]+>', ''
            $cleanOption = $cleanOption.Trim()

            $options += $cleanOption

            if ($isCorrect) {
                $correctAnswerIndex = $currentIndex
            }
            $currentIndex++
        }

        # Add to list
        $obj = [PSCustomObject]@{
            id = $id
            question = $questionText
            options = $options
            correct = $correctAnswerIndex
            image_url = $imgUrl
        }
        $questionsList += $obj
    } else {
        # Check for paragraph based options (Edge cases like Q98)
        # This is trickier. If we miss 1-2 questions, it might be acceptable vs breaking the JSON.
        # But let's see if we can catch Q98 type.
        # Q98 seems to have options in <p> tags, some with class="correct_answer" or span inside.
        
        # Simple fallback: look for ANY text with correct_answer class
        if ($body -match 'correct_answer') {
             # There is a correct answer here, but parsing the structure is hard without UL.
             # We will skip adding malformed questions to avoid corrupting the dataset structure 
             # unless we are sure.
             Write-Host "Skipping complex structure at Question $id"
        }
    }
}

# Convert to JSON and Save
$jsonPayload = $questionsList | ConvertTo-Json -Depth 5
$jsonPayload | Set-Content "c:\Users\Flavio\Desktop\Site_Web_CCNA2\ccna2_exam_questions.json" -Encoding UTF8

Write-Host "Successfully extracted $($questionsList.Count) questions to ccna2_exam_questions.json"
