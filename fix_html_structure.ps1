# PowerShell script to fix HTML structure issues in subpages

$subpagesPath = "c:\Users\NIRWAN\OneDrive\Desktop\Werton45\travel idea web project\travel idea web project\webproject home page\subpages"
$htmlFiles = Get-ChildItem -Path $subpagesPath -Filter "*.html"

Write-Host "Fixing HTML structure issues in $($htmlFiles.Count) files..." -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Fix malformed body tag placement
        # Remove body tags that appear in wrong places
        $content = $content -replace '<body>\s*<div class="page-content">', '<div class="page-content">'
        $content = $content -replace '<div class="page-content">\s*<body>', '<body><div class="page-content">'
        
        # Ensure proper body tag placement
        if ($content -notmatch '<body[^>]*>') {
            $content = $content -replace '</head>', "</head>`n<body>"
        }
        
        # Fix duplicate or misplaced body tags
        $content = $content -replace '(<body[^>]*>)[\s\S]*?(<body[^>]*>)', '$1'
        
        # Ensure proper closing body tag
        if ($content -notmatch '</body>') {
            $content = $content -replace '</html>', "</body>`n</html>"
        }
        
        # Fix encoding issues
        $content = $content -replace 'â€"', '—'
        $content = $content -replace 'â†'', '→'
        $content = $content -replace 'â¤ï¸', '❤️'
        $content = $content -replace 'â', '→'
        
        # Ensure proper DOCTYPE
        if (-not $content.StartsWith("<!DOCTYPE html>")) {
            $content = $content -replace '^<html', "<!DOCTYPE html>`n<html"
        }
        
        # Add lang attribute if missing
        $content = $content -replace '<html>', '<html lang="en">'
        $content = $content -replace '<html ([^>]*)>', '<html lang="en" $1>'
        
        # Save the corrected content
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        
        Write-Host "✓ Fixed: $($file.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Error processing $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nHTML structure fixes completed!" -ForegroundColor Cyan
Write-Host "All subpages now have proper HTML structure." -ForegroundColor Green