# Create Certs folder
$folderPath = "C:\Certs"
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# Creates a new certificate, valid for 5 years
$cert = New-SelfSignedCertificate -Subject "Azureautomation" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -NotAfter (Get-Date).AddYears(5)

# Export the certificate
$pwd = ConvertTo-SecureString -String "yU+w}B3dh=1/-PO#81^C" -Force -AsPlainText
Export-PfxCertificate -cert "cert:\CurrentUser\my\$($cert.Thumbprint)" -FilePath "$folderPath\Azureautomation.pfx" -Password $pwd

# Export the .cer file to C:\Certs
Export-Certificate -Cert "Cert:\CurrentUser\My\$($cert.Thumbprint)" -FilePath "$folderPath\Azureautomation.cer"