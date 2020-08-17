<# 
.NAME
	cripto-cert
.DESCRIPTION
    Criptografia com Certificado
.EXAMPLE
    PS C:\100SECURITY> .\cripto-cert.ps1
.NOTES
    Name: Marcos Henrique
	E-mail: marcos@100security.com.br
.LINK
    WebSite: http://www.100security.com.br
	Facebook: https://www.facebook.com/seguranca.da.informacao
	Twitter: https://twitter.com/100Security
	GitHub: https://www.github.com/100security
	Youtube: https://www.youtube.com/user/videos100security
#>
clear
''
Write-Host '+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +'
Write-Host '+                                                                                               +'
Write-Host '+                                  Criptografia com Certificado                                 +'-ForegroundColor Yellow
Write-Host '+                              www.100security.com.br/cripto-cert                               +'-ForegroundColor Yellow
Write-Host '+                                                                                               +'
Write-Host '+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +'
Write-Host '+                                                                                               +'

$certificado=Read-Host -Prompt '+  01  -  Você já possui um Certificado? (S/N)? '

If ($certificado -eq 'S')
{

Write-Host '+  02  -  Selecione o Certificado.                                                              +' 

$certificado_local=Get-Childitem Cert:\CurrentUser\My

$selecionar=$certificado_local | Where-Object hasprivatekey -eq 'true' | Select-Object -Property Issuer,Subject,HasPrivateKey | Out-GridView -Title 'Selecione o Certificado' -PassThru

Write-Host '+  03  -  Insira o caminho do arquivo que será Criptografado (ex: C:\100SECURITY\senhas.txt)    +' -ForegroundColor Yellow

$caminho=Read-Host -Prompt '+  Caminho Completo '

Write-Host '+  Aguarde! O arquivo criptografado será aberto no notepad.                                     +'
Write-Host '+                                                                                               +'-ForegroundColor Yellow
Write-Host '+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +'-ForegroundColor Yellow
''
Get-Content $caminho | Protect-CmsMessage -To $selecionar.Subject -OutFile $caminho

notepad $caminho

}

If ($certificado -eq 'N')

{

Write-Host '+  02  -  Para gerar um Certificado basta informar um nome (ex: Criptografia)                   +' -ForegroundColor Yellow

$certificado_novo=Read-Host '+  Nome do Certificado '
New-SelfSignedCertificate -DnsName $certificado_novo -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage KeyEncipherment,DataEncipherment,KeyAgreement -Type DocumentEncryptionCert
$certificado=Get-ChildItem -Path Cert:\CurrentUser\My\ | Where-Object subject -like "*$certificado_novo*"
$nome=$certificado.thumbprint
''
Write-Host '+  Certificado gerado com sucesso!                                                              +' -ForegroundColor Green
''
$senha=ConvertTo-SecureString -String (Read-Host '+  03  -  Insira uma Senha para o Certificado ') -Force -AsPlainText
''
Write-Host '+  Certificado exportado com sucesso!                                                           +' -ForegroundColor Green
Export-PfxCertificate -Cert Cert:\CurrentUser\My\$nome -FilePath $home\"cripto-cert_"$env:username".pfx" -Password $senha 

Write-Host '+  04  -  Insira o caminho do arquivo que será Criptografado (ex: C:\100SECURITY\senhas.txt)    +' -ForegroundColor Yellow
$caminho=Read-Host -Prompt '+  Caminho Completo '
Write-Host '+  Aguarde! O arquivo criptografado será aberto no notepad.                                     +'
Write-Host '+                                                                                               +'-ForegroundColor Yellow
Write-Host '+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +'-ForegroundColor Yellow
Get-Content $caminho | Protect-CmsMessage -To $certificado.Subject -OutFile $caminho

notepad $caminho

}
