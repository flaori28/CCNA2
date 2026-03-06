
$htmlContent = Get-Content -Raw "c:\Users\Flavio\Desktop\Site_Web_CCNA2\page_content.html"

# We split by <p><strong> because that marks the start of a question (and also Explications)
# The split consumes the delimiter.
$chunks = $htmlContent -split '<p><strong>'
Write-Host "Total chunks found: $($chunks.Count)"

for ($i=0; $i -lt 5; $i++) {
    Write-Host "Chunk $i Start: '$($chunks[$i].Substring(0, [math]::Min(50, $chunks[$i].Length)))'"
}

$questionsList = @()

foreach ($chunk in $chunks) {
    # Check if this chunk is a question
    # Format: "1. Question Text...</strong></p>...body..."
    # We look for a digit followed by a dot at the start.
    if ($chunk -match '^\s*(\d+)\.\s*(.*)') {
        $id = [int]$matches[1]
        
        # The text immediately following is the question text, ending at </strong></p>
        # Let's extract it.
        # The $chunk starts with "1. Question...". We matched the number. 
        # The rest of the chunk contains the text + </strong></p> + options.
        
        # More precise extraction
        # regex to find the question text ending at </strong>
    # Regex to extract question body
        # (?s) enables SingleLine mode so . matches newlines
        if ($chunk -match '(?s)^\s*\d+\.\s*(.*?)<\/strong><\/p>(.*)') {
            $rawQText = $matches[1]
            $body = $matches[2]
            
            # Decode Question
            $qText = [System.Net.WebUtility]::HtmlDecode($rawQText)
            $qText = $qText -replace '<[^>]+>', ''
            $qText = $qText.Trim()

            # Image
            $imgUrl = $null
            # Only look for image in the body part
            if ($body -match '<img[^>]+src="([^"]+)"') {
                $imgUrl = $matches[1]
            }
            
            # Options (UL/LI)
            $options = @()
            $correctIndex = -1
            
            # Regex match all LIs
            $liMatches = [regex]::Matches($body, '(?ms)<li(.*?)>(.*?)<\/li>')
            
            if ($liMatches.Count -gt 0) {
                # Process LIs
                $idx = 0
                foreach ($m in $liMatches) {
                    $attr = $m.Groups[1].Value
                    $val = $m.Groups[2].Value
                    
                    $isCorrect = $false
                    if ($attr -match 'correct_answer') { $isCorrect = $true }
                    if ($val -match 'class="correct_answer"') { $isCorrect = $true }
                    # Also check for bold/strong if class is missing, though file seems consistent
                    # if ($val -match '<strong>' -and $val -match '</strong>') { $isCorrect = $true }

                    $cleanVal = [System.Net.WebUtility]::HtmlDecode($val)
                    $cleanVal = $cleanVal -replace '<[^>]+>', ''
                    $cleanVal = $cleanVal.Trim()
                    
                    $options += $cleanVal
                    if ($isCorrect) { $correctIndex = $idx }
                    $idx++
                }
            } else {
                 # Fallback for questions like Q98 that don't use UL/LI
                 # They seem to use <p>...<span class="correct_answer">...</p>
                 # Or just <p>Option</p>. Without structure it's hard to get distractors.
                 # But we can at least try to find the correct answer text.
                 # Actually, looking at Q98:
                 # (config)# ip routing (Correct)
                 # But other options are code blocks too.
                 # If we can't parse options reliably, we explicitly set options to empty but maybe note the correct one?
                 # JSON schema requires options array.
                 # Let's skip fallback for now to keep JSON clean, or try a simple extraction of "correct_answer" spans.
                 if ($body -match 'correct_answer') {
                     # Try to extract the text of the correct answer
                     if ($body -match '<[^>]+class="correct_answer"[^>]*>(.*?)<\/[^>]+>') {
                         $correctText = $matches[1] -replace '<[^>]+>', ''
                         $options += $correctText.Trim()
                         $correctIndex = 0
                     }
                 }
            }

            if ($options.Count -gt 0) {
                $questionsList += [PSCustomObject]@{
                    id = $id
                    question = $qText
                    options = $options
                    correct = $correctIndex
                    image_url = $imgUrl
                }
            }
        }
    }
}

Write-Host "Extracted $($questionsList.Count) questions."
$questionsList | ConvertTo-Json -Depth 5 | Set-Content "c:\Users\Flavio\Desktop\Site_Web_CCNA2\ccna2_exam_questions.json" -Encoding UTF8
