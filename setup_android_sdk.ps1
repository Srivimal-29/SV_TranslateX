# Android SDK Setup Script for Flutter APK Build
# Downloads command-line tools, installs SDK components

$ErrorActionPreference = "Continue"

$ANDROID_SDK = "C:\Android\Sdk"
$CMDLINE_TOOLS_URL = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$CMDLINE_TOOLS_ZIP = "$env:TEMP\cmdline-tools.zip"

# Create SDK directory
New-Item -ItemType Directory -Path "$ANDROID_SDK\cmdline-tools" -Force | Out-Null

Write-Host "Downloading Android command-line tools..."
Invoke-WebRequest -Uri $CMDLINE_TOOLS_URL -OutFile $CMDLINE_TOOLS_ZIP -UseBasicParsing
Write-Host "Download complete."

Write-Host "Extracting command-line tools..."
Expand-Archive -Path $CMDLINE_TOOLS_ZIP -DestinationPath "$ANDROID_SDK\cmdline-tools" -Force
# Rename extracted folder to 'latest' as required by sdkmanager
if (Test-Path "$ANDROID_SDK\cmdline-tools\cmdline-tools") {
    if (Test-Path "$ANDROID_SDK\cmdline-tools\latest") {
        Remove-Item "$ANDROID_SDK\cmdline-tools\latest" -Recurse -Force
    }
    Rename-Item "$ANDROID_SDK\cmdline-tools\cmdline-tools" "latest"
}
Write-Host "Extraction complete."

# Set environment variables
$env:ANDROID_SDK_ROOT = $ANDROID_SDK
$env:ANDROID_HOME = $ANDROID_SDK
$env:PATH = "$ANDROID_SDK\cmdline-tools\latest\bin;$ANDROID_SDK\platform-tools;$env:PATH"

# Accept licenses and install required components
Write-Host "Installing Android SDK components..."
$yesInput = ("y`n" * 20)
$yesInput | & "$ANDROID_SDK\cmdline-tools\latest\bin\sdkmanager.bat" --sdk_root="$ANDROID_SDK" "platform-tools" "platforms;android-34" "build-tools;34.0.0"
Write-Host "SDK components installed."

# Accept all licenses
$yesInput | & "$ANDROID_SDK\cmdline-tools\latest\bin\sdkmanager.bat" --sdk_root="$ANDROID_SDK" --licenses
Write-Host "Licenses accepted."

# Configure Flutter
$env:PATH = "C:\flutter\bin;" + $env:PATH
flutter config --android-sdk "$ANDROID_SDK"
Write-Host "Flutter configured with Android SDK."

Write-Host "Android SDK setup complete!"
