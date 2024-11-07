# PowerShell script to set Google Chrome as the default browser for all web content in Windows 11

# Define the ProgId for Google Chrome
$chromeProgId = "ChromeHTML"

# Define the hash map for URL Protocol associations
$protocols = @(
    "http",
    "https",
    "ftp",
    "mailto",
    "webcal"
)

# Define the hash map for File Type associations
$fileTypes = @(
    ".html",
    ".htm",
    ".shtml",
    ".xht",
    ".xhtml"
)

# Function to set default app for a given protocol
function Set-DefaultAppForProtocol {
    param (
        [string]$protocol,
        [string]$progId
    )
    $keyPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\$protocol\UserChoice"
    New-Item -Path $keyPath -Force | Out-Null
    Set-ItemProperty -Path $keyPath -Name "ProgId" -Value $progId
}

# Function to set default app for a given file type
function Set-DefaultAppForFileType {
    param (
        [string]$fileType,
        [string]$progId
    )
    $keyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$fileType\UserChoice"
    New-Item -Path $keyPath -Force | Out-Null
    Set-ItemProperty -Path $keyPath -Name "ProgId" -Value $progId
}

# Set Google Chrome as the default application for each protocol
foreach ($protocol in $protocols) {
    Set-DefaultAppForProtocol -protocol $protocol -progId $chromeProgId
}

# Set Google Chrome as the default application for each file type
foreach ($fileType in $fileTypes) {
    Set-DefaultAppForFileType -fileType $fileType -progId $chromeProgId
}

Write-Output "Google Chrome has been set as the default browser for all web content."