# MyDoctor Installer for Windows - Full Auto
Write-Host "=== MyDoctor Installer (Windows) ===" -ForegroundColor Cyan
Write-Host "Downloading gemma-4-e4b-it.Q8_0.gguf (Medical Model)..." -ForegroundColor Yellow

# Create folder
$Folder = "$env:USERPROFILE\mydoctor"
New-Item -Path $Folder -ItemType Directory -Force | Out-Null
Set-Location $Folder

# Download the GGUF model
$ModelUrl = "https://huggingface.co/lordvivaan/MyDoctor/resolve/main/gemma-4-e4b-it.Q8_0.gguf"
$ModelPath = "$Folder\gemma-4-e4b-it.Q8_0.gguf"

if (-Not (Test-Path $ModelPath)) {
    Write-Host "Downloading model (~8 GB)... This may take a while." -ForegroundColor Magenta
    Invoke-WebRequest -Uri $ModelUrl -OutFile $ModelPath -UseBasicParsing -ProgressAction Continue
    Write-Host "Download Complete!" -ForegroundColor Green
} else {
    Write-Host "Model already exists. Skipping download." -ForegroundColor Green
}

# Create Modelfile
$ModelfileContent = @'
FROM ./gemma-4-e4b-it.Q8_0.gguf
PARAMETER num_ctx 4096
PARAMETER temperature 0.7
PARAMETER num_thread 4
'@

$ModelfileContent | Out-File -FilePath "$Folder\Modelfile" -Encoding utf8

# Install Ollama
Write-Host "→ Installing Ollama..." -ForegroundColor Yellow
Invoke-Expression (irm https://ollama.com/install.ps1)

Write-Host "" 
Write-Host "✅ Installation Complete!" -ForegroundColor Green
Write-Host "Model Location: $Folder" 
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Open a new PowerShell window and run:" 
Write-Host "   cd $Folder" -ForegroundColor White
Write-Host "   ollama create mydoctor -f Modelfile" -ForegroundColor White
Write-Host "2. Then run:" 
Write-Host "   ollama run mydoctor" -ForegroundColor White
Write-Host ""
Write-Host "Note: This Q8 model needs ~10-12GB RAM to run properly." -ForegroundColor Red
Write-Host "If you have only 4-8GB RAM, it may not load. Consider using a Q4 version instead."
Write-Host ""