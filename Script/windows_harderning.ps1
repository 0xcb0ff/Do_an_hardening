
$info = "[INFO] "
$fail = "[FAILED] "
$pass = "[PASSED] "

$file_remPath = "C:\Users\Public\remediation_filename.txt"
Remove-Item -Path $file_remPath
New-Item -ItemType File -Path $file_remPath
$textContent = "REMENDIATION!!!!!!!!!!!!"
$textContent | Set-Content -Path $file_remPath -Encoding UTF8

################################################################################################
$var1 = "1  Chính sách tài khoản"
$var1_1  = "1.1   Chính sách mật khẩu"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var1
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var1_1

################################################################################################
$var1_1_1 = "1.1.1  Cấu hình tham số 'Enforce password history'"
$rem1_1_1 = ("1.1.1  Cấu hình tham số 'Enforce password history'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: >= 24
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Password Policy\Enforce password history
")
$output = '24'
$output1 = 'None'
$unique = (net accounts | select-string 'Length of password history maintained:').ToString().Split(':')[1].Trim()
if ($unique -eq $output1) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_1
	Add-Content -Path $file_remPath -Value $rem1_1_1	
}
elseif ([int]$output -gt [int]$unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_1
	Add-Content -Path $file_remPath -Value $rem1_1_1
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_1_1
}

################################################################################################
$var1_1_2 = "1.1.2  Cấu hình tham số 'Maximum password age'"
$rem1_1_2 = ("1.1.2  Cấu hình tham số 'Maximum password age'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: <= 90 (khác 0)
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Password Policy\Maximum password age
")
$output = '60'
$output1 = 'Unlimited'
$unique = (net accounts | select-string Maximum).ToString().Split(':')[1].Trim()
if ($output1 -eq $unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_2
	Add-Content -Path $file_remPath -Value $rem1_1_2
}
elseif ([int]$output -lt [int]$unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_2
	Add-Content -Path $file_remPath -Value $rem1_1_2
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_1_2
}

################################################################################################
$var1_1_3 = "1.1.3  Cấu hình tham số 'Minimum password age'"
$rem1_1_3 = ("1.1.3  Cấu hình tham số 'Minimum password age'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: >= 1
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Password Policy\Minimum password age
")
#  1.1.3 (L1) - Ensure 'Minimum password age' is set to '1 or more day(s)'
$output = '1'
$unique = (net accounts | select-string 'Minimum password age').ToString().Split(':')[1].Trim()
if ([int]$output -gt [int]$unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_3
	Add-Content -Path $file_remPath -Value $rem1_1_3
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_1_3
}

################################################################################################
$var1_1_4 = "1.1.4  Cấu hình tham số 'Minimum password length'"
$rem1_1_4 = ("1.1.4  Cấu hình tham số 'Minimum password length'")
#  1.1.4 (L1) - Ensure 'Minimum password length' is set to '14 or more character(s)'
$output = '14'
$unique = (net accounts | select-string 'Minimum password length').ToString().Split(':')[1].Trim()
if ([int]$output -gt [int]$unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_4
	Add-Content -Path $file_remPath -Value $rem1_1_4
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_1_4
}

################################################################################################
$var1_1_5 = "1.1.5  Cấu hình độ phức tạp của mật khẩu 'Password must meet  complexity requirements'"
$rem1_1_5 = ("1.1.5  Cấu hình độ phức tạp của mật khẩu 'Password must meet  complexity requirements'")
#  1.1.5 (L1) - Ensure 'Password must meet complexity requirements' is set to 'Enabled'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '1'
$output = (Get-content c:\secpol.cfg | select-string PasswordComplexity).ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_5
	Add-Content -Path $file_remPath -Value $rem1_1_5
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_1_5
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var1_1_6 = "1.1.6  Cấu hình tham số 'Store passwords using reversible encryption'"
$rem1_1_6 = ("1.1.6  Cấu hình tham số 'Store passwords using reversible encryption'")
#  1.1.6 (L1) - Ensure 'Store passwords using reversible encryption' is set to 'Disabled'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '0'
$output = (Get-content c:/secpol.cfg | select-string 'ClearTextPassword').ToString().Split('=')[1].Trim()
if ($output -ne $unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_1_6
	Add-Content -Path $file_remPath -Value $rem1_1_6
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_1_6
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var1_2 = "1.2  Chính sách khóa tài khoản"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var1_2

################################################################################################
$var1_2_1 = "1.2.1  Cấu hình tham số 'Account lockout duration'"
$rem1_2_1 = ("1.2.1  Cấu hình tham số 'Account lockout duration'")
$output = '15'
$output1 = 'Never'
$unique = (net accounts | select-string 'Lockout duration').ToString().Split(':')[1].Trim()
if ($output1 -eq $unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_2_1
	Add-Content -Path $file_remPath -Value $rem1_2_1
}
elseif ([int]$unique -lt [int]$output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_2_1
	Add-Content -Path $file_remPath -Value $rem1_2_1
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_2_1
}	

################################################################################################
$var1_2_2 = "1.2.2  Cấu hình tham số 'Account lockout threshold'"
$rem1_2_2 = ("1.2.2  Cấu hình tham số 'Account lockout threshold'")
#  1.2.2 (L1) - Ensure 'Account lockout threshold' is set to '10 or fewer invalid logon attempt(s), but not 0'
$output = '10'
$output1 = 'Never'
$unique = (net accounts | select-string 'Lockout threshold').ToString().Split(':')[1].Trim()
if ($output1 -eq $unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_2_2
	Add-Content -Path $file_remPath -Value $rem1_2_2
}
elseif ([int]$output -lt [int]$unique) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_2_2
	Add-Content -Path $file_remPath -Value $rem1_2_2
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_2_2
}

################################################################################################
$var1_2_3 = "1.2.3  Cấu hình tham số 'Reset account lockout counter after'"
$rem1_2_3 = ("1.2.3  Cấu hình tham số 'Reset account lockout counter after'")
#  1.2.3 (L1) - Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'
$output = '15'
$output1 = 'Never'
$unique = (net accounts | select-string 'observation').ToString().Split(':')[1].Trim()
if ($output1 -eq $unique) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_2_3
	Add-Content -Path $file_remPath -Value $rem1_2_3
}
elseif ([int]$unique -lt [int]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var1_2_3
	Add-Content -Path $file_remPath -Value $rem1_2_3
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var1_2_3
}	

################################################################################################
$var2 = "2  Chính sách cục bộ"
$var2_1 = "2.1  Quyền thực thi tác vụ hệ thống (User Rights)"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_1
################################################################################################
$var2_1_1 = "2.1.1  Cấu hình chính sách 'Access Credential Manager as a trusted caller'"
$rem2_1_1 = ("2.1.1  Cấu hình chính sách 'Access Credential Manager as a trusted caller'")
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string SeTrustedCredManAccessPrivilege) |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_1
	Add-Content -Path $file_remPath -Value $rem2_1_1
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_1
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_2 = "2.1.2  Cấu hình chính sách 'Access this computer from the network' [Chỉ MS]"
$rem2_1_2 = ("2.1.2  Cấu hình chính sách 'Access this computer from the network' [Chỉ MS]")
#  2.2.3 (L1) - Ensure 'Access this computer from the network' is set to 'Administrators, Authenticated Users' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-11,*S-1-5-32-544'
$output = (Get-content c:/secpol.cfg | select-string 'SeNetworkLogonRight').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_2
	Add-Content -Path $file_remPath -Value $rem2_1_2
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_2
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_2DC = "2.1.2[DC]  Cấu hình chính sách 'Access this computer from the network' [Chỉ DC]"
$rem2_1_2DC = ("2.1.2[DC]  Cấu hình chính sách 'Access this computer from the network' [Chỉ DC]")
#  2.2.2 (L1) - Ensure 'Access this computer from the network' is set to 'Administrators, Authenticated Users, ENTERPRISE DOMAIN CONTROLLERS' (DC only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-11,*S-1-5-32-544,*S-1-5-9'
$output = (Get-content c:/secpol.cfg | select-string 'SeNetworkLogonRight').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
    $failed = (Get-content c:/secpol.cfg | select-string 'SeNetworkLogonRight').ToString().Split('=')[1].Trim().replace('*', '')
    	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_2DC
	Add-Content -Path $file_remPath -Value $rem2_1_2DC
}
else {
    	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_2DC
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_3 = "2.1.3  Cấu hình chính sách 'Act as part of the operating system'"
$rem2_1_3 = ("2.1.3  Cấu hình chính sách 'Act as part of the operating system'")

#  2.2.3 (L1) - Ensure 'Act as part of the operating system' is set to 'No One'

secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string SeTcbPrivilege) |  Measure-Object | % { $_.Count }

if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_3
	Add-Content -Path $file_remPath -Value $rem2_1_3
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_3
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_4 = "2.1.4  Cấu hình chỉ định người dùng được thêm các máy trạm vào Domain [Chỉ DC]"
$rem2_1_4 = ("2.1.4  Cấu hình chỉ định người dùng được thêm các máy trạm vào Domain [Chỉ DC]")
#  2.2.4 (L1) - Ensure 'Add workstations to domain' is set to 'Administrators' (DC only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string "SeMachineAccountPrivilege") |  Measure-Object | % { $_.Count }

if ($output -eq 1) {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeMachineAccountPrivilege").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_4
		Add-Content -Path $file_remPath -Value $rem2_1_4
	}
 else {
				Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_4
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_4
	Add-Content -Path $file_remPath -Value $rem2_1_4
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_5 = "2.1.5  Cấu hình chính sách 'Adjust memory quotas for a process'"
$rem2_1_5 = ("2.1.5  Cấu hình chính sách 'Adjust memory quotas for a process'")
#  2.2.5 (L1) - Ensure 'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-20,*S-1-5-32-544'
$output = (Get-content c:/secpol.cfg | select-string 'SeIncreaseQuotaPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
        		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_5
		Add-Content -Path $file_remPath -Value $rem2_1_5
}
else {
        		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_5
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_6 = "2.1.6  Cấu hình chính sách 'Allow log on locally'"
$rem2_1_6 = ("2.1.6  Cấu hình chính sách 'Allow log on locally'")
#  2.2.6 (L1) - Ensure 'Allow log on locally' is set to 'Administrators'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeInteractiveLogonRight').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_6
	Add-Content -Path $file_remPath -Value $rem2_1_6
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_6
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_7 = "2.1.7  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ MS]"
$rem2_1_7 = ("2.1.7  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ MS]")
#  2.1.7 (L1) - Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators, Remote Desktop Users' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-32-555'
$output = (Get-content c:\secpol.cfg | select-string 'SeRemoteInteractiveLogonRight ').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_7
	Add-Content -Path $file_remPath -Value $rem2_1_7
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_7
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_7DC = "2.1.7[DC]  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ DC]"
$rem2_1_7DC = ("2.1.7[DC]  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ DC]")
#  2.2.7 (L1) - Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators' (DC only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeRemoteInteractiveLogonRight').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_7DC
	Add-Content -Path $file_remPath -Value $rem2_1_7DC
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_7DC
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_8 = "2.1.8  Cấu hình sao lưu tệp và thư mục 'Back up files and directories'"
$rem2_1_8 = ("2.1.8  Cấu hình sao lưu tệp và thư mục 'Back up files and directories'")
#  2.1.8 (L1) - Ensure 'Back up files and directories' is set to 'Administrators'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeBackupPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_8
	Add-Content -Path $file_remPath -Value $rem2_1_8
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_8
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_9 = "2.1.9  Cấu hình thay đổi thời gian hệ thống 'Change the system time'"
$rem2_1_9 = ("2.1.9  Cấu hình thay đổi thời gian hệ thống 'Change the system time'")
#  2.1.9 (L1) - Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeSystemtimePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_9
	Add-Content -Path $file_remPath -Value $rem2_1_9
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_9
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_10 = "2.1.10  Cấu hình thay đổi thời gian hệ thống 'Change the time zone'"
$rem2_1_10 = ("2.1.10  Cấu hình thay đổi thời gian hệ thống 'Change the time zone'")
#  2.1.10 (L1) - Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeTimeZonePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_10
	Add-Content -Path $file_remPath -Value $rem2_1_10
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_10
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_11 = "2.1.11  Cấu hình chính sách 'Create a pagefile'"
$rem2_1_11 = ("2.1.11  Cấu hình chính sách 'Create a pagefile'")

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeCreatePagefilePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) { 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_11
	Add-Content -Path $file_remPath -Value $rem2_1_11 
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_11
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_12 = "2.1.12  Cấu hình chính sách 'Create a token object'"
$rem2_1_12 = ("2.1.12  Cấu hình chính sách 'Create a token object'")
#  2.1.12 (L1) - Ensure 'Create a token object' is set to 'No One'
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string "SeCreateTokenPrivilege") |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_12
	Add-Content -Path $file_remPath -Value $rem2_1_12
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_12
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_13 = "2.1.13  Cấu hình chính sách 'Create global objects'"
$rem2_1_13 = ("2.1.13  Cấu hình chính sách 'Create global objects'")
#  2.1.13 (L1) - Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6'
$output = (Get-content c:\secpol.cfg | select-string 'SeCreateGlobalPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) { 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_13
	Add-Content -Path $file_remPath -Value $rem2_1_13
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_13
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_14 = "2.1.14  Cấu hình chính sách 'Create permanent shared objects'"
$rem2_1_14 = ("2.1.14  Cấu hình chính sách 'Create permanent shared objects'")
#  2.1.14 (L1) - Ensure 'Create permanent shared objects' is set to 'No One'
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string "SeCreatePermanentPrivilege") |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_14
	Add-Content -Path $file_remPath -Value $rem2_1_14
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_14
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_15 = "2.1.15  Cấu hình chính sách 'Create symbolic links' - [Chỉ MS]"
$rem2_1_15 = ("2.1.15  Cấu hình chính sách 'Create symbolic links' - [Chỉ MS]")
#  2.1.15 (L1) - Ensure 'Create symbolic links' is set to 'Administrators, NT VIRTUAL MACHINE\Virtual Machines' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-83-0'
$output = (Get-content c:\secpol.cfg | select-string 'SeCreateSymbolicLinkPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_15
	Add-Content -Path $file_remPath -Value $rem2_1_15
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_15
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_15DC = "2.1.15[DC]  Cấu hình chính sách 'Create symbolic links' - [Chỉ DC]"
$rem2_1_15DC = ("2.1.15[DC]  Cấu hình chính sách 'Create symbolic links' - [Chỉ DC]")
#  2.1.15 (L1) - Ensure 'Create symbolic links' is set to 'Administrators' (DC only)
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeCreateSymbolicLinkPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_15DC
	Add-Content -Path $file_remPath -Value $rem2_1_15DC}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_15DC
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_16 = "2.1.16  Cấu hình chính sách 'Debug programs'"
$rem2_1_16 = ("2.1.16  Cấu hình chính sách 'Debug programs'")
#  2.1.16 (L1) - Ensure 'Debug programs' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeDebugPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_16
	Add-Content -Path $file_remPath -Value $rem2_1_16}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_16
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_17DC = "2.1.17[DC]  Cấu hình chính sách 'Deny access to this computer from the network' [Chỉ DC]"
$rem2_1_17DC = ("2.1.17[DC]  Cấu hình chính sách 'Deny access to this computer from the network' [Chỉ DC]")
#  2.1.17 (L1) - Ensure 'Deny access to this computer from the network' is set to 'Guests' (DC only)
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-546'
$output = (Get-content c:\secpol.cfg | select-string "SeDenyNetworkLogonRight") |  Measure-Object | % { $_.Count }
if ($output -eq 1) {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeDenyNetworkLogonRight").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_17DC
	Add-Content -Path $file_remPath -Value $rem2_1_17DC	}
 else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_17DC
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_17DC
	Add-Content -Path $file_remPath -Value $rem2_1_17DC}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_18 = "2.1.18  Cấu hình chính sách 'Deny log on as a batch job'"
$rem2_1_18 = ("2.1.18  Cấu hình chính sách 'Deny log on as a batch job'")
#  2.1.18 (L1) - Ensure 'Deny log on as a batch job' to include 'Guests'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-546'
$output = (Get-content c:\secpol.cfg | select-string "SeDenyBatchLogonRight") |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeDenyBatchLogonRight").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_18
	Add-Content -Path $file_remPath -Value $rem2_1_18
}
 else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_18
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_18
	Add-Content -Path $file_remPath -Value $rem2_1_18
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_19 = "2.1.19  Cấu hình chính sách 'Deny log on as a service'"
$rem2_1_19 = ("2.1.19  Cấu hình chính sách 'Deny log on as a service'")
#  2.1.19 (L1) - Ensure 'Deny log on as a service' to include 'Guests'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-546'
$output = (Get-content c:\secpol.cfg | select-string "SeDenyServiceLogonRight") |  Measure-Object | % { $_.Count }
if ($output -ne 0) {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeDenyServiceLogonRight").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_19
	Add-Content -Path $file_remPath -Value $rem2_1_19	
}
 else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_19
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_19
	Add-Content -Path $file_remPath -Value $rem2_1_19
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_20 = "2.1.20  Cấu hình chính sách 'Deny log on locally'"
$rem2_1_20 = ("2.1.20  Cấu hình chính sách 'Deny log on locally'")
#  2.1.20 (L1) - Ensure 'Deny log on locally' to include 'Guests'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-546'
$output = (Get-content c:\secpol.cfg | select-string "SeDenyInteractiveLogonRight" | Measure-Object | % { $_.Count })
if ($output -ne 0) {
        $output1 = (Get-content c:\secpol.cfg | select-string "SeDenyInteractiveLogonRight").ToString().Split('=')[1].Trim() 2> $null
        if ([string]$output1 -ne [string]$unique) {
            			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_20
			Add-Content -Path $file_remPath -Value $rem2_1_20
        }
        else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_20
        }
}
else {
        		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_20
		Add-Content -Path $file_remPath -Value $rem2_1_20
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_21 = "2.1.21  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ MS]"
$rem2_1_21 = ("2.1.21  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ MS]")
#  2.1.21 (L1) - Ensure 'Deny log on through Remote Desktop Services' is set to 'Guests, Local account' (MS only)
#  xem xet lai nha

secedit /export /cfg c:\secpol.cfg > $null
$unique = 'S-1-5-113,*S-1-5-32-546'
$output = (Get-content c:\secpol.cfg | select-string "SeDenyRemoteInteractiveLogonRight") |  Measure-Object | % { $_.Count }
if ([int]$output -ne 0) {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeDenyRemoteInteractiveLogonRight").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
		$failed = (Get-content c:\secpol.cfg | select-string "SeDenyRemoteInteractiveLogonRight").ToString().Split('=')[1].Trim().replace('*', '')
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_21
		Add-Content -Path $file_remPath -Value $rem2_1_21
	}
 else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_21
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_21
	Add-Content -Path $file_remPath -Value $rem2_1_21
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_21DC = "2.1.21[DC]  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ DC]"
$rem2_1_21DC = ("2.1.21[DC]  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ DC]")
#  2.1.21 (L1) - Ensure 'Deny log on through Remote Desktop Services' is set to 'Guests' (DC only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-546'
$output = (Get-content c:\secpol.cfg | select-string "SeDenyRemoteInteractiveLogonRight") |  Measure-Object | % { $_.Count }

if ($output -ne 0) {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeDenyRemoteInteractiveLogonRight").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_21DC
		Add-Content -Path $file_remPath -Value $rem2_1_21
	}
 else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_21DC
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_21DC
	Add-Content -Path $file_remPath -Value $rem2_1_21
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_22 = "2.1.22  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ MS]"
$rem2_1_22 = ("2.1.22  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ MS]")
#  2.1.22 (L1) - Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'No One' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string "SeEnableDelegationPrivilege") |  Measure-Object | % { $_.Count }

if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_22
	Add-Content -Path $file_remPath -Value $rem2_1_22
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_22
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_22DC = "2.1.22[DC]  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ DC]"
$rem2_1_22DC = ("2.1.22[DC]  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ DC]")
#  2.1.22 (L1) - Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'Administrators' (DC only)
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string "SeEnableDelegationPrivilege") |  Measure-Object | % { $_.Count }
if ($output -ne 0) {
	$output1 = (Get-content c:\secpol.cfg | select-string "SeEnableDelegationPrivilege").ToString().Split('=')[1].Trim() 2> $null	
	if ([string]$output1 -ne [string]$unique) {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_22DC
	Add-Content -Path $file_remPath -Value $rem2_1_22DC
}
 else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_22DC
	}
}
else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_22DC
	Add-Content -Path $file_remPath -Value $rem2_1_22DC
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_23 = "2.1.23  Cấu hình chính sách 'Force shutdown from a remote system'"
$rem2_1_23 = ("2.1.23  Cấu hình chính sách 'Force shutdown from a remote system'")
#  2.1.23 (L1) - Ensure 'Force shutdown from a remote system' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeRemoteShutdownPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
  $failed = (Get-content c:\secpol.cfg | select-string 'SeRemoteShutdownPrivilege').ToString().Split('=')[1].Trim().replace('*', '')
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_23
	Add-Content -Path $file_remPath -Value $rem2_1_23
}
else {
    Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_23
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_24 = "2.1.24  Cấu hình chính sách 'Generate security audits'"
$rem2_1_24 = ("2.1.24  Cấu hình chính sách 'Generate security audits'")
#  2.1.24 (L1) - Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-20'
$output = (Get-content c:\secpol.cfg | select-string 'SeAuditPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) { 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_24
	Add-Content -Path $file_remPath -Value $rem2_1_24
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_24
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_25 = "2.1.25  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ MS]"
$rem2_1_25 = ("2.1.25  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ MS]")
#  2.1.25 (L1) - Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE' and (when the Web Server (IIS) Role with Web Services Role Service is installed) 'IIS_IUSRS' (MS only)
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6'
$output = (Get-content c:\secpol.cfg | select-string 'SeImpersonatePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_25
	Add-Content -Path $file_remPath -Value $rem2_1_25
}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_25
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_25DC = "2.1.25[DC]  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ DC]"
$rem2_1_25DC = ("2.1.25[DC]  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ DC]")
#  2.1.25 (L1) - Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'  (DC only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6'
$output = (Get-content c:\secpol.cfg | select-string 'SeImpersonatePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_25DC
	Add-Content -Path $file_remPath -Value $rem2_1_25DC
}
else {
        		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_25DC
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_26 = "2.1.26  Cấu hình chính sách 'Increase scheduling priority'"
$rem2_1_26 = ("2.1.26  Cấu hình chính sách 'Increase scheduling priority'")
#  2.1.26 (L1) - Ensure 'Increase scheduling priority' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeIncreaseBasePriorityPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_26
	Add-Content -Path $file_remPath -Value $rem2_1_26
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_26
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_27 = "2.1.27  Cấu hình chính sách 'Load and unload device drivers'"
$rem2_1_27 = ("2.1.27  Cấu hình chính sách 'Load and unload device drivers'")
#  2.1.27 (L1) - Ensure 'Load and unload device drivers' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string SeLoadDriverPrivilege).ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_27
	Add-Content -Path $file_remPath -Value $rem2_1_27
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_27
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_28 = "2.1.28  Cấu hình chính sách 'Lock pages in memory'"
$rem2_1_28 = ("2.1.28  Cấu hình chính sách 'Lock pages in memory'")
#  2.1.28 (L1) - Ensure 'Lock pages in memory' is set to 'No One'
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string "SeLockMemoryPrivilege") |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_28
	Add-Content -Path $file_remPath -Value $rem2_1_28
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_28
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_29 = "2.1.29  Cấu hình chính sách 'Manage auditing and security log' [Chỉ MS]"
$rem2_1_29 = ("2.1.29  Cấu hình chính sách 'Manage auditing and security log' [Chỉ MS]")
#  2.1.29 (L1) - Ensure 'Manage auditing and security log' is set to 'Administrators` and (when Exchange is running in the environment) `Exchange Servers' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeSecurityPrivilege').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_29
	Add-Content -Path $file_remPath -Value $rem2_1_29
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_29
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_29DC = "2.1.29[DC]  Cấu hình chính sách 'Manage auditing and security log' [Chỉ DC]"
$rem2_1_29DC = ("2.1.29[DC]  Cấu hình chính sách 'Manage auditing and security log' [Chỉ DC]")
#  2.1.29 (L1) - Ensure 'Manage auditing and security log' is set to 'Administrators` and (when Exchange is running in the environment) `Exchange Servers' (DC only)
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeSecurityPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_29DC
	Add-Content -Path $file_remPath -Value $rem2_1_29DC
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_29DC
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_30 = "2.1.30  Cấu hình chính sách 'Modify an object label'"
$rem2_1_30 = ("2.1.30  Cấu hình chính sách 'Modify an object label'")
#  2.1.30 (L1) - Ensure 'Modify an object label' is set to 'No One'
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string "SeRelabelPrivilege") |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_30
	Add-Content -Path $file_remPath -Value $rem2_1_30
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_30
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_31 = "2.1.31  Cấu hình giá trị 'Modify firmware environment values'"
$rem2_1_31 = ("2.1.31  Cấu hình giá trị 'Modify firmware environment values'")
#  2.1.31 (L1) - Ensure 'Modify firmware environment values' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeSystemEnvironmentPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_31
	Add-Content -Path $file_remPath -Value $rem2_1_31
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_31
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_32 = "2.1.32  Cấu hình chính sách 'Perform volume maintenance tasks'"
$rem2_1_32 = ("2.1.32  Cấu hình chính sách 'Perform volume maintenance tasks'")
#  2.1.32 (L1) - Ensure 'Perform volume maintenance tasks' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeManageVolumePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_32
	Add-Content -Path $file_remPath -Value $rem2_1_32
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_32
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_33 = "2.1.33  Cấu hình chính sách 'Profile single process'"
$rem2_1_33 = ("2.1.33  Cấu hình chính sách 'Profile single process'")
#  2.1.33 (L1) - Ensure 'Profile single process' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeProfileSingleProcessPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_33
	Add-Content -Path $file_remPath -Value $rem2_1_33
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_33
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_34 = "2.1.34  Cấu hình chính sách 'Profile system performance'"
$rem2_1_34 = ("2.1.34  Cấu hình chính sách 'Profile system performance'")
#  2.1.34 (L1) - Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420'
$output = (Get-content c:\secpol.cfg | select-string 'SeSystemProfilePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_34
	Add-Content -Path $file_remPath -Value $rem2_1_34
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_34
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_35 = "2.1.35  Cấu hình chính sách 'Replace a process level token'"
$rem2_1_35 = ("2.1.35  Cấu hình chính sách 'Replace a process level token'")
#  2.1.35 (L1) - Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-19,*S-1-5-20'
$output = (Get-content c:\secpol.cfg | select-string 'SeAssignPrimaryTokenPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_35
	Add-Content -Path $file_remPath -Value $rem2_1_35
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_35
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_36 = "2.1.36  Cấu hình chính sách 'Restore files and directories'"
$rem2_1_36 = ("2.1.36  Cấu hình chính sách 'Restore files and directories'")
#  2.1.36 (L1) - Ensure 'Restore files and directories' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-32-551'
$output = (Get-content c:\secpol.cfg | select-string 'SeRestorePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_36
	Add-Content -Path $file_remPath -Value $rem2_1_36
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $rem2_1_36
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_37 = "2.1.37  Cấu hình chính sách 'Shut down the system'"
$rem2_1_37 = ("2.1.37  Cấu hình chính sách 'Shut down the system'")
#  2.1.37 (L1) - Ensure 'Shut down the system' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-32-551'
$output = (Get-content c:\secpol.cfg | select-string 'SeShutdownPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_37
	Add-Content -Path $file_remPath -Value $rem2_1_37
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_37
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_38 = "2.1.38  Cấu hình chính sách 'Synchronize directory service data' [Chỉ DC]"
$rem2_1_38 = ("2.1.38  Cấu hình chính sách 'Synchronize directory service data' [Chỉ DC]")
#  2.1.38 (L1) - Ensure 'Synchronize directory service data' is set to 'No One' (DC only)
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string "SeSyncAgentPrivilege") |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_38
	Add-Content -Path $file_remPath -Value $rem2_1_38
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_38
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_39 = "2.1.39  Cấu hình chính sách 'Take ownership of files or other objects'"
$rem2_1_39 = ("2.1.39  Cấu hình chính sách 'Take ownership of files or other objects'")
#  2.1.39 (L1) - Ensure 'Take ownership of files or other objects' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeTakeOwnershipPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
   $failed = (Get-content c:\secpol.cfg | select-string 'SeTakeOwnershipPrivilege').ToString().Split('=')[1].Trim().replace('*', '')
      Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_39
	Add-Content -Path $file_remPath -Value $rem2_1_39
}
else {
      Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_39
}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_1_1 = "2.2.1.1  Cấu hình trạng thái tài khoản 'Administrator account status'"
$rem2_2_1_1 = ("2.2.1.1  Cấu hình trạng thái tài khoản 'Administrator account status'")
#  2.2.1.1 (L1) - Ensure 'Accounts: Administrator account status' is set to 'Disabled' (MS only)

$output = 'No'
$name = (Get-LocalUser | ForEach-Object { $_.Name + " " + $_.Description } | Select-String "Built-in account for administering the computer/domain" | Foreach { "$(($_ -split '\s+'))" } | ForEach-Object { $_.replace('Built-in account for administering the computer/domain', '') })
$unique = (invoke-expression "net user $name" | select-string 'Account active').ToString().Split(' ')[16].Trim()
if ($output -ne $unique) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_1
	Add-Content -Path $file_remPath -Value $rem2_2_1_1
}
else {
        		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_1_1
}

################################################################################################
$var2_2_1_2 = "2.2.1.2  Cấu hình chính sách tài khoản 'Block Microsoft accounts'"
$rem2_2_1_2 = ("2.2.1.2  Cấu hình chính sách tài khoản 'Block Microsoft accounts'")

#  2.2.1.2 (L1) - Ensure 'Accounts: Block Microsoft accounts' is set to 'Users can't add or log on with Microsoft accounts'

$ErrorActionPreference = "stop"
Try {
   Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
   $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
   $unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'NoConnectedUser' 2> $null |  Measure-Object | % { $_.Count })
   $output1 = '0x3'
   if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
      foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'NoConnectedUser').ToString().Split('')[12].Trim() ) {
         if ( $unique1 -eq $output1 ) {
            			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_1_2
         }
         else {
            			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_2
			Add-Content -Path $file_remPath -Value $rem2_2_1_2
         }
      }
   }
   else {
      	  Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_2
	Add-Content -Path $file_remPath -Value $rem2_2_1_2
   }

}
Catch [System.Management.Automation.ItemNotFoundException] {
      Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_2
	Add-Content -Path $file_remPath -Value $rem2_2_1_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_1_3 = "2.2.1.3  Cấu hình trạng thái tài khoản 'Guest account status' [Chỉ MS]"
$rem2_2_1_3 = ("2.2.1.3  Cấu hình trạng thái tài khoản 'Guest account status' [Chỉ MS]")
#  2.2.1.3 (L1) - Ensure 'Accounts: Guest account status' is set to 'Disabled' (MS only)

$output = 'No'
$name = (Get-LocalUser | ForEach-Object { $_.Name + " " + $_.Description } | Select-String "Built-in account for guest access to the computer/domain" | Foreach { "$(($_ -split '\s+'))" } | ForEach-Object { $_.replace('Built-in account for guest access to the computer/domain', '') })
$unique = (invoke-expression "net user $name" | select-string 'Account active').ToString().Split(' ')[16].Trim()
if ($output -ne $unique) {
        		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_3
		Add-Content -Path $file_remPath -Value $rem2_2_1_3
}
else {
        		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_1_3
}

################################################################################################
$var2_2_1_4 = "2.2.1.4  Cấu hình chính sách tài khoản 'Limit local account use of blank passwords to console logon only'"
$rem2_2_1_4 = ("2.2.1.4  Cấu hình chính sách tài khoản 'Limit local account use of blank passwords to console logon only'")
#  2.2.1.4 (L1) - Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa" 2> $null | select-string 'LimitBlankPasswordUse' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa" | select-string 'LimitBlankPasswordUse').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_1_4
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_4
				Add-Content -Path $file_remPath -Value $rem2_2_1_4
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_4
		Add-Content -Path $file_remPath -Value $rem2_2_1_4
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_4
	Add-Content -Path $file_remPath -Value $rem2_2_1_4
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_1_5 = "2.2.1.5  Cấu hình thay đổi tên mặc định tài khoản quản trị 'Rename administrator account'"
$rem2_2_1_5 = ("2.2.1.5  Cấu hình thay đổi tên mặc định tài khoản quản trị 'Rename administrator account'")
#  2.2.1.5 (L1) - Configure 'Accounts: Rename administrator account'

secedit /export /cfg c:\secpol.cfg > $null
$output = '"Administrator"'
$unique = (Get-content c:\secpol.cfg | select-string 'NewAdministratorName').ToString().Split('=')[1].Trim()
if ($output -eq $unique) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_5
	Add-Content -Path $file_remPath -Value $rem2_2_1_5
}
else { 
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_1_5
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_2_1_6 = "2.2.1.6  Cấu hình thay đổi tên mặc định tài khoản Guests 'Rename guest account'"
$rem2_2_1_6 = ("2.2.1.6  Cấu hình thay đổi tên mặc định tài khoản Guests 'Rename guest account'")
#  2.2.1.6 (L1) - Configure 'Accounts: Rename guest account'

secedit /export /cfg c:\secpol.cfg > $null
$output = "Guest"
$unique = (Get-content c:\secpol.cfg | select-string 'NewGuestName').ToString().Split('=')[1].Trim()
if ($output -ne $unique) {
	
    	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_1_6	
}
else {
	
    	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_1_6
	Add-Content -Path $file_remPath -Value $rem2_2_1_6
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_2_2 = "2.2.2  Cấu hình kiểm toán"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_2

################################################################################################
$var2_2_2_1 = "2.2.2.1  Cấu hình chính sách 'Audit: Force audit policy subcategory settings to override audit policy category settings'"
$rem2_2_2_1 = ("2.2.2.1  Cấu hình chính sách 'Audit: Force audit policy subcategory settings to override audit policy category settings'")
#  2.2.2.1 (L1) - Ensure 'Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'SCENoApplyLegacyAuditPolicy' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'SCENoApplyLegacyAuditPolicy').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_2_1
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_2_1
				Add-Content -Path $file_remPath -Value $rem2_2_2_1
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_2_1
		Add-Content -Path $file_remPath -Value $rem2_2_2_1
	}

}
Catch [System.Management.Automation.ItemNotFoundException] {
  
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_2_1
	Add-Content -Path $file_remPath -Value $rem2_2_2_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_2_2 = "2.2.2.2  Cấu hình chính sách 'Audit: Shut down system immediately if unable to log security audits'"
$rem2_2_2_2 = ("2.2.2.2  Cấu hình chính sách 'Audit: Shut down system immediately if unable to log security audits'")
#  2.2.2.2 (L1) - Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa" 2> $null | select-string 'CrashOnAuditFail' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa" | select-string 'CrashOnAuditFail').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_2_2
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_2_2
				Add-Content -Path $file_remPath -Value $rem2_2_2_2
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_2_2
		Add-Content -Path $file_remPath -Value $rem2_2_2_2
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_2_2
	Add-Content -Path $file_remPath -Value $rem2_2_2_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_3 = "2.2.3  Thiết bị"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_3

################################################################################################
$var2_2_3_1 = "2.2.3.1  Cấu hình chính sách 'Devices: Allowed to format and eject removable media'"
$rem2_2_3_1 = ("2.2.3.1  Cấu hình chính sách 'Devices: Allowed to format and eject removable media'")
#  2.2.3.1 (L1) - Ensure 'Devices: Allowed to format and eject removable media' is set to 'Administrators'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
 $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon")
 $unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" 2> $null | select-string 'AllocateDASD' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | select-string 'AllocateDASD').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_3_1
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_3_1
	Add-Content -Path $file_remPath -Value $rem2_2_3_1
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_3_1
	Add-Content -Path $file_remPath -Value $rem2_2_3_1
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_3_1
	Add-Content -Path $file_remPath -Value $rem2_2_3_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_3_2 = "2.2.3.2  Cấu hình chính sách 'Devices: Prevent users from installing printer drivers'"
$rem2_2_3_2 = ("2.2.3.2  Cấu hình chính sách 'Devices: Prevent users from installing printer drivers'")
#  2.2.3.2 (L1) - Ensure 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Control\Print\Providers\Lanman Print Services\Servers' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
 $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Print\Providers\Lanman Print Services\Servers")
 $unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Print\Providers\Lanman Print Services\Servers" 2> $null | select-string 'AddPrinterDrivers' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Print\Providers\Lanman Print Services\Servers" | select-string 'AddPrinterDrivers').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
				Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_3_2
			}
			else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_3_2
				Add-Content -Path $file_remPath -Value $rem2_2_3_2
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_3_2
		Add-Content -Path $file_remPath -Value $rem2_2_3_2
	}

}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_3_2
	Add-Content -Path $file_remPath -Value $rem2_2_3_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_4 = "2.2.4  Domain Controller [Mục này chỉ dành cho DC]"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_4

################################################################################################
$var2_2_4_1 = "2.2.4.1  Cấu hình chính sách 'Domain controller: Allow server operators to schedule tasks' is set to 'Disabled'"
$rem2_2_4_1 = ("2.2.4.1  Cấu hình chính sách 'Domain controller: Allow server operators to schedule tasks' is set to 'Disabled'")
#  2.2.4.1 (L1) - Ensure 'Domain controller: Allow server operators to schedule tasks' is set to 'Disabled' (DC only)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'SubmitControl' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'SubmitControl').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
				Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_4_1
			}
			else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_4_1
				Add-Content -Path $file_remPath -Value $rem2_2_4_1
			}
		}
	}
	else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_4_1
		Add-Content -Path $file_remPath -Value $rem2_2_4_1
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_4_1
	Add-Content -Path $file_remPath -Value $rem2_2_4_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_4_2 = "2.2.4.2  Cấu hình chính sách 'Domain controller: Refuse machine account password changes"
$rem2_2_4_2 = ("2.2.4.2  Cấu hình chính sách 'Domain controller: Refuse machine account password changes")
#  2.2.4.2 (L1) - Ensure 'Domain controller: Refuse machine account password changes' is set to 'Disabled' (DC only)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" 2> $null | select-string 'RefusePasswordChange' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" | select-string 'RefusePasswordChange').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
				Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_4_2
			}
			else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_4_2
				Add-Content -Path $file_remPath -Value $rem2_2_4_2
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_4_2
	Add-Content -Path $file_remPath -Value $rem2_2_4_2
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_4_2
	Add-Content -Path $file_remPath -Value $rem2_2_4_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_5 = "2.2.5  Domain Member"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_5

################################################################################################
$var2_2_5_1 = "2.2.5.1  Cấu hình chính sách 'Domain member: Digitally encrypt or sign secure channel data (always)'"
$rem2_2_5_1 = ("2.2.5.1  Cấu hình chính sách 'Domain member: Digitally encrypt or sign secure channel data (always)'")
#  2.2.5.1 (L1) - Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '4,1'
$output = (Get-content c:\secpol.cfg | select-string 'RequireSignOrSeal').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_1
	Add-Content -Path $file_remPath -Value $rem2_2_5_1
}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_5_1
}
rm -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_2_5_2 = "2.2.5.2  Cấu hình chính sách 'Domain member: Digitally encrypt secure channel data (when possible)'"
$rem2_2_5_2 = ("2.2.5.2  Cấu hình chính sách 'Domain member: Digitally encrypt secure channel data (when possible)'")
#  2.2.5.2 (L1) - Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" 2> $null | select-string 'SealSecureChannel' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | select-string 'SealSecureChannel').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_5_2
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_2
				Add-Content -Path $file_remPath -Value $rem2_2_5_2
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_2
		Add-Content -Path $file_remPath -Value $rem2_2_5_2
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_2
	Add-Content -Path $file_remPath -Value $rem2_2_5_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_5_3 = "2.2.5.3  Cấu hình chính sách 'Domain member: Digitally sign secure channel data (when possible)'"
$rem2_2_5_3 = ("2.2.5.3  Cấu hình chính sách 'Domain member: Digitally sign secure channel data (when possible)'")
#  2.2.5.3 (L1) - Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" 2> $null | select-string 'SignSecureChannel' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | select-string 'SignSecureChannel').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_5_3
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_3
				Add-Content -Path $file_remPath -Value $rem2_2_5_3
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_3
		Add-Content -Path $file_remPath -Value $rem2_2_5_3
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_3
	Add-Content -Path $file_remPath -Value $rem2_2_5_3
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_5_4 = "2.2.5.4  Cấu hình chính sách 'Domain member: Disable machine account password changes'"
$rem2_2_5_4 = ("2.2.5.4  Cấu hình chính sách 'Domain member: Disable machine account password changes'")
#  2.2.5.4 (L1) - Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" 2> $null | select-string 'DisablePasswordChange' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | select-string 'DisablePasswordChange').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_5_4
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_4
				Add-Content -Path $file_remPath -Value $rem2_2_5_4
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_4
		Add-Content -Path $file_remPath -Value $rem2_2_5_4
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_4
	Add-Content -Path $file_remPath -Value $rem2_2_5_4
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_5_5 = "2.2.5.5  Cấu hình chính sách 'Domain member: Maximum machine account password age'"
$rem2_2_5_5 = ("2.2.5.5  Cấu hình chính sách 'Domain member: Maximum machine account password age'")
#  2.2.5.5 (L1) - Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" 2> $null | select-string 'MaximumPasswordAge' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | select-string 'MaximumPasswordAge').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1e' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_5_5
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_5
				Add-Content -Path $file_remPath -Value $rem2_2_5_5
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_5
		Add-Content -Path $file_remPath -Value $rem2_2_5_5
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_5
	Add-Content -Path $file_remPath -Value $rem2_2_5_5
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_5_6 = "2.2.5.6  Cấu hình chính sách 'Domain member: Require strong (Windows 2000 or later) session key"
$rem2_2_5_6 = ("2.2.5.6  Cấu hình chính sách 'Domain member: Require strong (Windows 2000 or later) session key")
#  2.2.5.6 (L1) - Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" 2> $null | select-string 'RequireStrongKey' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters" | select-string 'RequireStrongKey').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_5_6
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_6
	Add-Content -Path $file_remPath -Value $rem2_2_5_6
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_6
	Add-Content -Path $file_remPath -Value $rem2_2_5_6
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_5_6
	Add-Content -Path $file_remPath -Value $rem2_2_5_6
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_6 = "2.2.6  Thiết lập Interactive Logon"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_6

################################################################################################
$var2_2_6_1 = "2.2.6.1  Thiết lập 'Interactive logon: Do not display last user name'"
$rem2_2_6_1 = ("2.2.6.1  Thiết lập 'Interactive logon: Do not display last user name'")
#  2.2.6.1 (L1) - Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'DontDisplayLastUserName' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'DontDisplayLastUserName').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_6_1
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_1
				Add-Content -Path $file_remPath -Value $rem2_2_6_1
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_1
		Add-Content -Path $file_remPath -Value $rem2_2_6_1
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_1
	Add-Content -Path $file_remPath -Value $rem2_2_6_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_6_2 = "2.2.6.2  Thiết lập ' CTRL+ALT+DEL'"
$rem2_2_6_2 = "2.2.6.2  Thiết lập ' CTRL+ALT+DEL'"
#  2.2.6.2 (L1) - Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'DisableCAD' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'DisableCAD').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_6_2
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_2
				Add-Content -Path $file_remPath -Value $rem2_2_6_2
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_2
		Add-Content -Path $file_remPath -Value $rem2_2_6_2
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_2
	Add-Content -Path $file_remPath -Value $rem2_2_6_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_6_3 = "2.2.6.3  Thiết lập 'Interactive logon: Machine inactivity limit'"
$rem2_2_6_3 = "2.2.6.3  Thiết lập 'Interactive logon: Machine inactivity limit'"
#  2.2.6.3 (L1) - Ensure 'Interactive logon: Machine inactivity limit' is set to '900 or fewer second(s), but not 0'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'InactivityTimeoutSecs' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'InactivityTimeoutSecs').ToString().Split('')[12].Trim() ) {
			if (  ( [int]$unique1 -le [int]'0x384' ) -And ( [int]$unique1 -ne [int]'0x0' ) ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_6_3
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_3
				Add-Content -Path $file_remPath -Value $rem2_2_6_3
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_3
		Add-Content -Path $file_remPath -Value $rem2_2_6_3
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_3
	Add-Content -Path $file_remPath -Value $rem2_2_6_3
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_6_4 = "2.2.6.4  Cấu hình 'Interactive logon: Message text for users attempting to log on'"
$rem2_2_6_4 = "2.2.6.4  Cấu hình 'Interactive logon: Message text for users attempting to log on'"
#  2.2.6.4 (L1) - Configure 'Interactive logon: Message text for users attempting to log on'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
                 
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'LegalNoticeText' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ($unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'LegalNoticeText' | Foreach { "$(($_ -split '\s+',4)[3])" } | select-string -pattern "[A-z][a-z]" | Measure-Object | % { $_.Count })) {
			if (  ( $unique1 -eq '1' ) ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_6_4
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_4
	Add-Content -Path $file_remPath -Value $rem2_2_6_4
			}
		}
	}
 else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_4
	Add-Content -Path $file_remPath -Value $rem2_2_6_4
	}

}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_4
	Add-Content -Path $file_remPath -Value $rem2_2_6_4
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_6_5 = "2.2.6.5  Thiết lập 'Interactive logon: Message title for users attempting to log on'"
$rem2_2_6_5 = "2.2.6.5  Thiết lập 'Interactive logon: Message title for users attempting to log on'"
#  2.2.6.5 (L1) - Configure 'Interactive logon: Message title for users attempting to log on'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'LegalNoticeCaption' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'LegalNoticeCaption' | Foreach { "$(($_ -split '\s+',4)[3])" } | select-string -pattern "[A-z][a-z]" | Measure-Object | % { $_.Count })) {
			if ( $unique1 -eq '1' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_6_5
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_5
				Add-Content -Path $file_remPath -Value $rem2_2_6_5
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_5
		Add-Content -Path $file_remPath -Value $rem2_2_6_5
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_5
	Add-Content -Path $file_remPath -Value $rem2_2_6_5
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_6_6 = "2.2.6.6  Thiết lập 'Interactive logon: Prompt user to change password before expiration'"
$rem2_2_6_6 = "2.2.6.6  Thiết lập 'Interactive logon: Prompt user to change password before expiration'"
#  2.2.6.6 (L1) - Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" 2> $null | select-string 'PasswordExpiryWarning' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | select-string 'PasswordExpiryWarning').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x5' -and [int]$unique1 -le [int]'0x14' ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_6_6
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_6
				Add-Content -Path $file_remPath -Value $rem2_2_6_6
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_6
		Add-Content -Path $file_remPath -Value $rem2_2_6_6
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_6_6
	Add-Content -Path $file_remPath -Value $rem2_2_6_6
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_7 = "2.2.7  Thiết lập Microsoft network client"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_7

################################################################################################
$var2_2_7_1 = "2.2.7.1  Thiết lập 'Microsoft network client: Digitally sign communications (if server agrees)'"
$rem2_2_7_1 = "2.2.7.1  Thiết lập 'Microsoft network client: Digitally sign communications (if server agrees)'"
#  2.2.7.1 (L1) - Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is already set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" 2> $null | select-string 'EnableSecuritySignature' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" | select-string 'EnableSecuritySignature' | Foreach { "$(($_ -split '\s+',4)[3])" } ) ) {
			if (  ( $unique1 -eq '0x1' ) ) {
								Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_7_1
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_1
				Add-Content -Path $file_remPath -Value $rem2_2_7_1
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_1
		Add-Content -Path $file_remPath -Value $rem2_2_7_1
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_1
	Add-Content -Path $file_remPath -Value $rem2_2_7_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_7_2 = "2.2.7.2  Thiết lập 'Microsoft network client: Send unencrypted password to third-party SMB servers'"
$rem2_2_7_2 = "2.2.7.2  Thiết lập 'Microsoft network client: Send unencrypted password to third-party SMB servers'"
#  2.2.7.2 (L1) - Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" 2> $null | select-string 'EnablePlainTextPassword' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" | select-string 'EnablePlainTextPassword').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_2
			}
			else {
								Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_2
				Add-Content -Path $file_remPath -Value $rem2_2_7_2
			}
		}
	}
	else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_2
		Add-Content -Path $file_remPath -Value $rem2_2_7_2
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_2
	Add-Content -Path $file_remPath -Value $rem2_2_7_2
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_7_3 = "2.2.7.3.  Thiết lập 'Microsoft network client: Digitally sign communications (if server always)'"
$rem2_2_7_3 = ("2.2.7.3.  Thiết lập 'Microsoft network client: Digitally sign communications (if server always)'")

#   2.2.7.3 (L1) Ensure 'Microsoft network client: Digitally sign communications (if server always)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
   $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters")
   $unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" 2> $null | select-string 'RequireSecuritySignature' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" | select-string 'RequireSecuritySignature'| Foreach {"$(($_ -split '\s+',4)[3])"} ) ) {
	if (  ( $unique1 -eq '0x1' ) ) {
				Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_7_3
	} else {
				Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_3
	Add-Content -Path $file_remPath -Value $rem2_2_7_3
		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_3
	Add-Content -Path $file_remPath -Value $rem2_2_7_3
}

}
Catch [System.Management.Automation.ItemNotFoundException]
{
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_7_3
	Add-Content -Path $file_remPath -Value $rem2_2_7_3
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_8 = "2.2.8  Thiết lập Microsoft network server"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_8

################################################################################################
$var2_2_8_1 = "2.2.8.1  Thiết lập 'Microsoft network server: Amount of idle time required before suspending session'"
$rem2_2_8_1 = ("2.2.8.1  Thiết lập 'Microsoft network server: Amount of idle time required before suspending session'")
#  2.2.8.1 (L1) - Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Services\Lanmanserver\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Services\Lanmanserver\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Services\Lanmanserver\Parameters" 2> $null | select-string 'AutoDisconnect' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\Currentcontrolset\Services\Lanmanserver\Parameters" | select-string 'AutoDisconnect').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0xf' ) {
				                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_8_1
			}
			else {
				                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_1
	Add-Content -Path $file_remPath -Value $rem2_2_8_1
			}
		}
	}
	else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_1
	Add-Content -Path $file_remPath -Value $rem2_2_8_1
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_1
	Add-Content -Path $file_remPath -Value $rem2_2_8_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_8_2 = "2.2.8.2  Thiết lập 'Microsoft network server: Disconnect clients when logon hours expire'"
$rem2_2_8_2 = ("2.2.8.2  Thiết lập 'Microsoft network server: Disconnect clients when logon hours expire'")

#  2.2.8.2 (L1) - Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'enableforcedlogoff' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'enableforcedlogoff').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
				                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_8_2
			}
			else {
				                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_2
	Add-Content -Path $file_remPath -Value $rem2_2_8_2
			}
		}
	}
	else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_2
	Add-Content -Path $file_remPath -Value $rem2_2_8_2
	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_2
	Add-Content -Path $file_remPath -Value $rem2_2_8_2
}
Finally { $ErrorActionPreference = "Continue" } 

################################################################################################
$var2_2_8_3 = "2.2.8.3  Thiết lập ' Microsoft network server: Digitally sign communications (always)"
$rem2_2_8_3 = ("2.2.8.3  Thiết lập ' Microsoft network server: Digitally sign communications (always)")

#   2.2.8.3 (L1) - Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'RequireSecuritySignature' 2> $null |  Measure-Object | %{$_.Count})
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'RequireSecuritySignature').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' ) {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_8_3
	} else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_3
	Add-Content -Path $file_remPath -Value $rem2_2_8_3
		}
	}
}else {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_3
	Add-Content -Path $file_remPath -Value $rem2_2_8_3
}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_3
	Add-Content -Path $file_remPath -Value $rem2_2_8_3
 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_8_4 = "2.2.8.4  Thiết lập 'Microsoft network server: Digitally sign communications (if client agrees)'"
$rem2_2_8_4 = ("2.2.8.4  Thiết lập 'Microsoft network server: Digitally sign communications (if client agrees)'")

#   2.2.8.4 (L1) - Ensure 'Microsoft network server: Digitally sign communications (if client agrees)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'EnableSecuritySignature' 2> $null |  Measure-Object | %{$_.Count})
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'EnableSecuritySignature').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' ) {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_4
	} else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_4
	Add-Content -Path $file_remPath -Value $rem2_2_8_4
		}
	}
}else {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_4
	Add-Content -Path $file_remPath -Value $rem2_2_8_4
}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_4
	Add-Content -Path $file_remPath -Value $rem2_2_8_4
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_8_5 = "2.2.8.5  Thiết lập 'Microsoft network server: Server SPN target name validation level' [Chỉ MS]"
$rem2_2_8_5 = ("2.2.8.5  Thiết lập 'Microsoft network server: Server SPN target name validation level' [Chỉ MS]")

#   2.2.8.5 (L1) - Ensure 'Microsoft network server: Server SPN target name validation level' is set to 'Accept if provided by client' or higher (MS only) (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'SMBServerNameHardeningLevel' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'SMBServerNameHardeningLevel').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -ge [int]'0x1' ) {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_8_5
	} else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_5
	Add-Content -Path $file_remPath -Value $rem2_2_8_5
		}
	}
}else {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_5
	Add-Content -Path $file_remPath -Value $rem2_2_8_5
}

}
Catch [System.Management.Automation.ItemNotFoundException]
{
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_5
	Add-Content -Path $file_remPath -Value $rem2_2_8_5
 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_9 = "2.2.9  Thiết lập Network access"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_9

################################################################################################
$var2_2_9_1 = "2.2.9.1  Thiết lập 'Network access: Allow anonymous SID/Name translation'"
$rem2_2_9_1 = ("2.2.9.1  Thiết lập 'Network access: Allow anonymous SID/Name translation'")

#  2.2.9.1 (L1) - Ensure 'Network access: Allow anonymous SID/Name translation' is set to 'Disabled'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '0'
$output = (Get-content c:\secpol.cfg | select-string 'LSAAnonymousNameLookup').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_1
	Add-Content -Path $file_remPath -Value $rem2_2_9_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_1

}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_2 = "2.2.9.2  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts' [Chỉ MS]"
$rem2_2_9_2 = ("2.2.9.2  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts' [Chỉ MS]")

#  2.2.9.2 (L1) - Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled' (MS only)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'RestrictAnonymousSAM' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'RestrictAnonymousSAM').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_2
	Add-Content -Path $file_remPath -Value $rem2_2_9_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_2
	Add-Content -Path $file_remPath -Value $rem2_2_9_2

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_2
	Add-Content -Path $file_remPath -Value $rem2_2_9_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_9_3 = "2.2.9.3  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' [Chỉ MS]"
$rem2_2_9_3 = ("2.2.9.3  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' [Chỉ MS]")

#  2.2.9.3 (L1) - Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' is set to 'Enabled' (MS only)

secedit /export /cfg c:\secpol.cfg  > $null
$unique = '4,1'
$output = (Get-content c:\secpol.cfg | Select-String 'RestrictAnonymous=').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_3
	Add-Content -Path $file_remPath -Value $rem2_2_9_3

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_3

}
rm -force c:\secpol.cfg -confirm:$false

secedit /export /cfg c:\secpol.cfg  > $null
$unique = '4,1'
$output = (Get-content c:\secpol.cfg | Select-String 'RestrictAnonymous=').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_3
	Add-Content -Path $file_remPath -Value $rem2_2_9_3

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_3

}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_4 = "2.2.9.4  Thiết lập 'Network access: Let Everyone permissions apply to anonymous users'"
$rem2_2_9_4 = ("2.2.9.4  Thiết lập 'Network access: Let Everyone permissions apply to anonymous users'")

#  2.2.9.4 (L1) - Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'EveryoneIncludesAnonymous' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'EveryoneIncludesAnonymous').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_4
	Add-Content -Path $file_remPath -Value $rem2_2_9_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_4
	Add-Content -Path $file_remPath -Value $rem2_2_9_4

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_4
	Add-Content -Path $file_remPath -Value $rem2_2_9_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_9_5 = "2.2.9.5  Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ MS]"
$rem2_2_9_5 = ("2.2.9.5  Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ MS]")

#  2.2.9.5 (L1) - Configure 'Network access: Named Pipes that can be accessed anonymously' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = 'MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionPipes=7,BROWSER'
$output = Get-content c:\secpol.cfg | Select-String NullSessionPipes

if ($unique -ne $output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_5
	Add-Content -Path $file_remPath -Value $rem2_2_9_5

}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_5

}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_5DC = "2.2.9.5[DC] Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ DC]"
$rem2_2_9_5DC = ("2.2.9.5[DC] Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ DC]")

#  2.2.9.5 (L1) - Configure 'Network access: Named Pipes that can be accessed anonymously' (DC only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = 'MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionPipes=7,LSARPC,NETLOGON,SAMR,BROWSER'
$unique_notbr = 'MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionPipes=7,LSARPC,NETLOGON,SAMR,'
$output = Get-content c:\secpol.cfg | Select-String NullSessionPipes

$resbr = (Get-Service -name Browser).Status
$res_status = "Stopped"

if ($resbr -clike $res_status) {
        if ($unique_notbr -ne $output) {
                                  Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_5DC
	Add-Content -Path $file_remPath -Value $rem2_2_9_5DC
}
        else {
                                  Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_5DC
}

}
else 
{
        if ($unique -ne $output) {
                                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_5DC
	Add-Content -Path $file_remPath -Value $rem2_2_9_5DC
        }
        else {
                                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_5DC
        }
        
}

rm -force c:\secpol.cfg -confirm:$false
################################################################################################
$var2_2_9_6 = "2.2.9.6  Cấu hình 'Network access: Remotely accessible registry paths'"
$rem2_2_9_6 = ("2.2.9.6  Cấu hình 'Network access: Remotely accessible registry paths'")

#  2.2.9.6 (L1) - Configure 'Network access: Remotely accessible registry paths'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '7,System\CurrentControlSet\Control\ProductOptions,System\CurrentControlSet\Control\Server Applications,Software\Microsoft\Windows NT\CurrentVersion'
$output = (Get-content c:/secpol.cfg | select-string 'Winreg.*AllowedExactPaths.*Machine').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_6
	Add-Content -Path $file_remPath -Value $rem2_2_9_6

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_6

}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_7 = "2.2.9.7  Cấu hình 'Network access: Remotely accessible registry paths and sub-paths'"
$rem2_2_9_7 = ("2.2.9.7  Cấu hình 'Network access: Remotely accessible registry paths and sub-paths'")

#  2.2.9.7 (L1) - Configure 'Network access: Remotely accessible registry paths and sub-paths'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '7,System\CurrentControlSet\Control\Print\Printers,System\CurrentControlSet\Services\Eventlog,Software\Microsoft\OLAP Server,Software\Microsoft\Windows NT\CurrentVersion\Print,Software\Microsoft\Windows NT\CurrentVersion\Windows,System\CurrentControlSet\Control\ContentIndex,System\CurrentControlSet\Control\Terminal Server,System\CurrentControlSet\Control\Terminal Server\UserConfig,System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration,Software\Microsoft\Windows NT\CurrentVersion\Perflib,System\CurrentControlSet\Services\SysmonLog'
$output = (Get-content c:\secpol.cfg | Select-String 'AllowedPaths.*Machine').ToString().Split('=')[1].Trim()

if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_7
	Add-Content -Path $file_remPath -Value $rem2_2_9_7

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_7

}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_8 = "2.2.9.8  Cấu hình 'Network access: Restrict anonymous access to Named Pipes and Shares'"
$rem2_2_9_8 = ("2.2.9.8  Cấu hình 'Network access: Restrict anonymous access to Named Pipes and Shares'")

#  2.2.9.8 (L1) - Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'RestrictNullSessAccess' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'RestrictNullSessAccess').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_8

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_8
	Add-Content -Path $file_remPath -Value $rem2_2_9_8

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_8
	Add-Content -Path $file_remPath -Value $rem2_2_9_8

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_8
	Add-Content -Path $file_remPath -Value $rem2_2_9_8

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_9_9 = "2.2.9.9  Cấu hình 'Network access: Shares that can be accessed anonymously'"
$rem2_2_9_9 = ("2.2.9.9  Cấu hình 'Network access: Shares that can be accessed anonymously'")

#  2.2.9.9 (L1) - Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'NullSessionShares' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'NullSessionShares' | Foreach { "$(($_ -split '\s+',4)[3])" } | select-string -pattern "[0-9]" | Measure-Object | % { $_.Count } ) ) {
			foreach ( $unique2 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'NullSessionShares' | Foreach { "$(($_ -split '\s+',4)[3])" } | select-string -pattern "[A-Z][a-z]" | Measure-Object | % { $_.Count }) ) {
				if ( ( $unique1 -ne '1' ) -And ($unique2 -ne '1' ) ) {
						Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_9

				}
				else {
						Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_9
	Add-Content -Path $file_remPath -Value $rem2_2_9_9

				}
			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_9
	Add-Content -Path $file_remPath -Value $rem2_2_9_9

	}

}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_9
	Add-Content -Path $file_remPath -Value $rem2_2_9_9

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_9_10 = "2.2.9.10  Cấu hình 'Network access: Sharing and security model for local accounts'"
$rem2_2_9_10 = ("2.2.9.10  Cấu hình 'Network access: Sharing and security model for local accounts'")

#  2.2.9.10 (L1) - Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'ForceGuest' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'ForceGuest').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_10

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_10
	Add-Content -Path $file_remPath -Value $rem2_2_9_10

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_10
	Add-Content -Path $file_remPath -Value $rem2_2_9_10

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_10
	Add-Content -Path $file_remPath -Value $rem2_2_9_10

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10 = "2.2.10  Thiết lập Network security"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_10
################################################################################################
$var2_2_10_1 = "2.2.10.1  Thiết lập 'Network security: Allow LocalSystem NULL session fallback'"
$rem2_2_10_1 = ("2.2.10.1  Thiết lập 'Network security: Allow LocalSystem NULL session fallback'")
#  2.2.10.1 (L1) - Ensure 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" 2> $null | select-string 'AllowNullSessionFallback' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" | select-string 'AllowNullSessionFallback').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_1
	Add-Content -Path $file_remPath -Value $rem2_2_10_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_1
	Add-Content -Path $file_remPath -Value $rem2_2_10_1

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_1
	Add-Content -Path $file_remPath -Value $rem2_2_10_1

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_2 = "2.2.10.2  Thiết lập 'Network Security: Allow PKU2U authentication requests to this computer to use online identities'"
$rem2_2_10_2 = ("2.2.10.2  Thiết lập 'Network Security: Allow PKU2U authentication requests to this computer to use online identities'")
#  2.2.10.2 (L1) - Ensure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\pku2u -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\pku2u")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\pku2u" 2> $null | select-string 'AllowOnlineID' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\pku2u" | select-string 'AllowOnlineID').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_2
	Add-Content -Path $file_remPath -Value $rem2_2_10_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_2
	Add-Content -Path $file_remPath -Value $rem2_2_10_2

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_2
	Add-Content -Path $file_remPath -Value $rem2_2_10_2
}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_3 = "2.2.10.3  Thiết lập 'Network security: Configure encryption types allowed for Kerberos'"
$rem2_2_10_3 = ("2.2.10.3  Thiết lập 'Network security: Configure encryption types allowed for Kerberos'")
#  2.2.10.3 (L1) - Ensure 'Network security: Configure encryption types allowed for Kerberos' is set to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" 2> $null | select-string 'SupportedEncryptionTypes' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" | select-string 'SupportedEncryptionTypes').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x7ffffff8' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_3
	Add-Content -Path $file_remPath -Value $rem2_2_10_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_3
	Add-Content -Path $file_remPath -Value $rem2_2_10_3

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_3
	Add-Content -Path $file_remPath -Value $rem2_2_10_3

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_4 = "2.2.10.4  Thiết lập 'Network security: Do not store LAN Manager hash value on next password change'"
$rem2_2_10_4 = ("2.2.10.4  Thiết lập 'Network security: Do not store LAN Manager hash value on next password change'")
#  2.2.10.4 (L1) - Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'NoLMHash' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'NoLMHash').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_4
	Add-Content -Path $file_remPath -Value $rem2_2_10_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_4
	Add-Content -Path $file_remPath -Value $rem2_2_10_4

	}

}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_4
	Add-Content -Path $file_remPath -Value $rem2_2_10_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_10_5 = "2.2.10.5  Thiết lập 'Network security: Force logoff when logon hours expire'"
$rem2_2_10_5 = ("2.2.10.5  Thiết lập 'Network security: Force logoff when logon hours expire'")
#  2.2.10.5 (L1) - Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'

secedit /export /cfg c:\secpol.cfg > $null
$unique = '1'
$output = (Get-content c:\secpol.cfg | Select-String 'ForceLogoffWhenHourExpire').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_5
	Add-Content -Path $file_remPath -Value $rem2_2_10_5

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_5

}
rm -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_10_6 = "2.2.10.6  Thiết lập 'Network security: Allow Local System to use computer identity for NTLM'"
$rem2_2_10_6 = ("2.2.10.6  Thiết lập 'Network security: Allow Local System to use computer identity for NTLM'")
#   2.2.10.6 (L1) - Ensure 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled' (Scored)
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
   $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
   $unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'UseMachineId' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'UseMachineId').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' )  {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_6

	} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_6
	Add-Content -Path $file_remPath -Value $rem2_2_10_6
		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_6
	Add-Content -Path $file_remPath -Value $rem2_2_10_6
}

}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_6
	Add-Content -Path $file_remPath -Value $rem2_2_10_6

 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_7 = "2.2.10.7  Thiết lập 'Network security: LAN Manager authentication level'"
$rem2_2_10_7 = ("2.2.10.7  Thiết lập 'Network security: LAN Manager authentication level'")

#   2.2.10.7 (L1) - Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" 2> $null | select-string 'LmCompatibilityLevel' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | select-string 'LmCompatibilityLevel').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x5' )  {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_7

	} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_7
	Add-Content -Path $file_remPath -Value $rem2_2_10_7

		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_7
	Add-Content -Path $file_remPath -Value $rem2_2_10_7

}

}
Catch [System.Management.Automation.ItemNotFoundException]
{
 
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_7
	Add-Content -Path $file_remPath -Value $rem2_2_10_7

 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_8 = "2.2.10.8  Thiết lập 'Network security: LDAP client signing requirements'"
$rem2_2_10_8 = ("2.2.10.8  Thiết lập 'Network security: LDAP client signing requirements'")
#   2.2.10.8 (L1) - Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LDAP -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
   $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LDAP")
   $unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LDAP" 2> $null | select-string 'LDAPClientIntegrity' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LDAP" | select-string 'LDAPClientIntegrity').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' )  {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_8

	} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_8
	Add-Content -Path $file_remPath -Value $rem2_2_10_8

		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_8
	Add-Content -Path $file_remPath -Value $rem2_2_10_8

}

}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_8
	Add-Content -Path $file_remPath -Value $rem2_2_10_8

 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_9 = "2.2.10.9  Thiết lập 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients'"
$rem2_2_10_9 = ("2.2.10.9  Thiết lập 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients'")
#   2.2.10.9 (L1) - Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" 2> $null | select-string 'NTLMMinClientSec' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" | select-string 'NTLMMinClientSec').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x20080000' )  {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_9

	} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_9
	Add-Content -Path $file_remPath -Value $rem2_2_10_9

		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_9
	Add-Content -Path $file_remPath -Value $rem2_2_10_9
}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_9
	Add-Content -Path $file_remPath -Value $rem2_2_10_9

 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_10_10 = "2.2.10.10  Thiết lập 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers'"
$rem2_2_10_10 = ("2.2.10.10  Thiết lập 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers'")
#   2.2.11.10 (L1) - Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers' is set to 'Require NTLMv2 session security, Require 128-bit encryption' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" 2> $null | select-string 'NTLMMinServerSec' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" | select-string 'NTLMMinServerSec').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x20080000' )  {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_10_10

	} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_10
	Add-Content -Path $file_remPath -Value $rem2_2_10_10

		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_10
	Add-Content -Path $file_remPath -Value $rem2_2_10_10

}

}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_10_10
	Add-Content -Path $file_remPath -Value $rem2_2_10_10

 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_11 = "2.2.11  Thiết lập cơ chế Shutdown"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_11

################################################################################################
$var2_2_11_1 = "2.2.11.1  Thiết lập cơ chế 'Shutdown: Allow system to be shut down  without having to log on'"
$rem2_2_11_1 = ("2.2.11.1  Thiết lập cơ chế 'Shutdown: Allow system to be shut down  without having to log on'")
#  2.2.11.1 (L1) - Ensure 'Shutdown: Allow system to be shut down without having to log on' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'ShutdownWithoutLogon' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'ShutdownWithoutLogon').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_11_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_11_1
	Add-Content -Path $file_remPath -Value $rem2_2_11_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_11_1
	Add-Content -Path $file_remPath -Value $rem2_2_11_1

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_11_1
	Add-Content -Path $file_remPath -Value $rem2_2_11_1

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_12 = "2.2.12   Cấu hình System objects"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_12

################################################################################################
$var2_2_12_1 = "2.2.12.1  Cấu hình chính sách 'System objects: Require case insensitivity for non-Windows subsystems'"
$rem2_2_12_1 = ("2.2.12.1  Cấu hình chính sách 'System objects: Require case insensitivity for non-Windows subsystems'")

#  2.2.12.1 (L1) - Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" 2> $null | select-string 'ObCaseInsensitive' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" | select-string 'ObCaseInsensitive').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_12_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_12_1
	Add-Content -Path $file_remPath -Value $rem2_2_12_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_12_1
	Add-Content -Path $file_remPath -Value $rem2_2_12_1

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_12_1
	Add-Content -Path $file_remPath -Value $rem2_2_12_1

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_12_2 = "2.2.12.2  Cấu hình chính sách 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)'"
$rem2_2_12_2 = ("2.2.12.2  Cấu hình chính sách 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)'")
#   2.2.12.2. Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" 2> $null | select-string 'ProtectionMode' 2> $null |  Measure-Object | %{$_.Count})
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" | select-string 'ProtectionMode').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' ) {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_12_2

	} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_12_2
	Add-Content -Path $file_remPath -Value $rem2_2_12_2

		}
	}
}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_12_2
	Add-Content -Path $file_remPath -Value $rem2_2_12_2

}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_12_2
	Add-Content -Path $file_remPath -Value $rem2_2_12_2

 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_13 = "2.2.13  Thiết lập kiểm soát User Account Control"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_13
################################################################################################
$var2_2_13_1 = "2.2.13.1  Thiết lập 'User Account Control: Admin Approval Mode for the Built-in Administrator account'"
$rem2_2_13_1 = ("2.2.13.1  Thiết lập 'User Account Control: Admin Approval Mode for the Built-in Administrator account'")
#   2.2.13.1.Ensure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'FilterAdministratorToken' 2> $null |  Measure-Object | %{$_.Count})
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'FilterAdministratorToken').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_1

			} else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_1
	Add-Content -Path $file_remPath -Value $rem2_2_13_1

				}
							}
	}else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_1
	Add-Content -Path $file_remPath -Value $rem2_2_13_1

	}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_1
	Add-Content -Path $file_remPath -Value $rem2_2_13_1

 }
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_13_2 = "2.2.13.2  Thiết lập 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode'"
$rem2_2_13_2 = ("2.2.13.2  Thiết lập 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode'")
#  2.2.13.2 (L1) - Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'ConsentPromptBehaviorAdmin' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'ConsentPromptBehaviorAdmin').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x2' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_2
	Add-Content -Path $file_remPath -Value $rem2_2_13_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_2
	Add-Content -Path $file_remPath -Value $rem2_2_13_2

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_2
	Add-Content -Path $file_remPath -Value $rem2_2_13_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_13_3 = "2.2.13.3  Thiết lập 'User Account Control: Detect application installations and prompt for elevation'"
$rem2_2_13_3 = ("2.2.13.3  Thiết lập 'User Account Control: Detect application installations and prompt for elevation'")
#  2.2.13.3 (L1) - Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'EnableInstallerDetection' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'EnableInstallerDetection').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_3
	Add-Content -Path $file_remPath -Value $rem2_2_13_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_3
	Add-Content -Path $file_remPath -Value $rem2_2_13_3

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_3
	Add-Content -Path $file_remPath -Value $rem2_2_13_3

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_13_4 = "2.2.13.4  Thiết lập 'User Account Control: Only elevate UIAccess applications that are installed in secure locations'"
$rem2_2_13_4 = ("2.2.13.4  Thiết lập 'User Account Control: Only elevate UIAccess applications that are installed in secure locations'")
#  2.2.13.4 (L1) - Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'EnableSecureUIAPaths' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'EnableSecureUIAPaths').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_4
	Add-Content -Path $file_remPath -Value $rem2_2_13_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_4
	Add-Content -Path $file_remPath -Value $rem2_2_13_4

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_4
	Add-Content -Path $file_remPath -Value $rem2_2_13_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_13_5 = "2.2.13.5  Thiết lập 'User Account Control: Run all administrators in Admin Approval Mode'"
$rem2_2_13_5 = ("2.2.13.5  Thiết lập 'User Account Control: Run all administrators in Admin Approval Mode'")
#  2.2.13.5 (L1) - Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'EnableLUA' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'EnableLUA').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_5

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_5
	Add-Content -Path $file_remPath -Value $rem2_2_13_5

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_5
	Add-Content -Path $file_remPath -Value $rem2_2_13_5

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_5
	Add-Content -Path $file_remPath -Value $rem2_2_13_5

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var2_2_13_6 = "2.2.13.6  Thiết lập 'User Account Control: Switch to the secure desktop when prompting for elevation'"
$rem2_2_13_6 = "2.2.13.6  Thiết lập 'User Account Control: Switch to the secure desktop when prompting for elevation'"
#  2.2.13.6 (L1) - Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'PromptOnSecureDesktop' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'PromptOnSecureDesktop').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_6

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_6
	Add-Content -Path $file_remPath -Value $rem2_2_13_6

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_6
	Add-Content -Path $file_remPath -Value $rem2_2_13_6

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_6
	Add-Content -Path $file_remPath -Value $rem2_2_13_6

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_13_7 = "2.2.13.7  Thiết lập 'User Account Control: Virtualize file and registry write failures to per-user locations"
$rem2_2_13_7 = ("2.2.13.7  Thiết lập 'User Account Control: Virtualize file and registry write failures to per-user locations")
#  2.2.13.7 (L1) - Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'EnableVirtualization' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'EnableVirtualization').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_7

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_7
	Add-Content -Path $file_remPath -Value $rem2_2_13_7

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_7
	Add-Content -Path $file_remPath -Value $rem2_2_13_7

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_7
	Add-Content -Path $file_remPath -Value $rem2_2_13_7

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_13_8 = "2.2.13.8  Thiết lập 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'"
$rem2_2_13_8 = ("2.2.13.8  Thiết lập 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'")
#   2.2.13.8 (L1) - Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" 2> $null | select-string 'ConsentPromptBehaviorUser' 2> $null |  Measure-Object | %{$_.Count})
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | select-string 'ConsentPromptBehaviorUser').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_13_8

			} else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_8
	Add-Content -Path $file_remPath -Value $rem2_2_13_8

				}
							}
	}else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_8
	Add-Content -Path $file_remPath -Value $rem2_2_13_8

	}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_13_8
	Add-Content -Path $file_remPath -Value $rem2_2_13_8

 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3 = "3  Cấu hình an ninh Windows Firewall (Advanced)"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var3

################################################################################################
$var3_1 = "3.1  Domain Profile"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var3_1

################################################################################################
$var3_1_1 = "3.1.1  Thiết lập trạng thái 'Windows Firewall: Domain: Firewall state'"
$rem3_1_1 = ("3.1.1  Thiết lập trạng thái 'Windows Firewall: Domain: Firewall state'")

#  3.1.1 (L1) - Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" 2> $null | select-string 'EnableFirewall' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" | select-string 'EnableFirewall').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_1
	Add-Content -Path $file_remPath -Value $rem3_1_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_1
	Add-Content -Path $file_remPath -Value $rem3_1_1

	}	
	
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_1
	Add-Content -Path $file_remPath -Value $rem3_1_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_2 = "3.1.2  Thiết lập trạng thái 'Windows Firewall: Domain: Inbound connections'"
$rem3_1_2 = ("3.1.2  Thiết lập trạng thái 'Windows Firewall: Domain: Inbound connections'")

#  3.1.2 (L1) - Ensure 'Windows Firewall: Domain: Inbound connections' is set to 'Block (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" 2> $null | select-string 'DefaultInboundAction' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" | select-string 'DefaultInboundAction').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_2
	Add-Content -Path $file_remPath -Value $rem3_1_2

			}
		}
	}
	else { 
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_2
	Add-Content -Path $file_remPath -Value $rem3_1_2

	}	
	
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_2
	Add-Content -Path $file_remPath -Value $rem3_1_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_3 = "3.1.3  Thiết lập trạng thái 'Windows Firewall: Domain: Outbound connections'"
$rem3_1_3 = ("3.1.3  Thiết lập trạng thái 'Windows Firewall: Domain: Outbound connections'")

#  3.1.3 (L1) - Ensure 'Windows Firewall: Domain: Outbound connections' is set to 'Allow (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" 2> $null | select-string 'DefaultOutboundAction' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" | select-string 'DefaultOutboundAction').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_3
	Add-Content -Path $file_remPath -Value $rem3_1_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_3
	Add-Content -Path $file_remPath -Value $rem3_1_3

	}
	
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_3
	Add-Content -Path $file_remPath -Value $rem3_1_3

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_4 = "3.1.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Domain: Logging: Name'"
$rem3_1_4 = ("3.1.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Domain: Logging: Name'")

#  3.1.4 (L1) - Ensure 'Windows Firewall: Domain: Logging: Name' is set to '%SYSTEMROOT%\System32\logfiles\firewall\domainfw.log'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" 2> $null | select-string ' LogFilePath' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" | select-string ' LogFilePath').ToString().Split('')[12].Trim() ) {
			if ( [string]$unique1 -eq [string]'%SYSTEMROOT%\System32\logfiles\firewall\domainfw.log' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_4
	Add-Content -Path $file_remPath -Value $rem3_1_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_4
	Add-Content -Path $file_remPath -Value $rem3_1_4

	}	
	
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_4
	Add-Content -Path $file_remPath -Value $rem3_1_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_5 = "3.1.5  Cấu hình kích thước giới hạn 'Windows Firewall: Domain: Logging: Size limit (KB)'"
$rem3_1_5 = ("3.1.5  Cấu hình kích thước giới hạn 'Windows Firewall: Domain: Logging: Size limit (KB)'")

#  3.1.5 (L1) - Ensure 'Windows Firewall: Domain: Logging: Size limit (KB)' is set to '16,384 KB or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" 2> $null | select-string ' LogFileSize' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" | select-string ' LogFileSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x4000' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_5

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_5
	Add-Content -Path $file_remPath -Value $rem3_1_5

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_5
	Add-Content -Path $file_remPath -Value $rem3_1_5

	}	
	
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_5
	Add-Content -Path $file_remPath -Value $rem3_1_5

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_6 = "3.1.6  Thiết lập chính sách 'Windows Firewall: Domain: Logging: Log dropped packets'"
$rem3_1_6 = ("3.1.6  Thiết lập chính sách 'Windows Firewall: Domain: Logging: Log dropped packets'")

#  3.1.6 (L1) - Ensure 'Windows Firewall: Domain: Logging: Log dropped packets' is set to 'Yes'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" 2> $null | select-string ' LogDroppedPackets' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" | select-string ' LogDroppedPackets').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_6

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_6
	Add-Content -Path $file_remPath -Value $rem3_1_6

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_6
	Add-Content -Path $file_remPath -Value $rem3_1_6

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_6
	Add-Content -Path $file_remPath -Value $rem3_1_6

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_7 = "3.1.7  Thiết lập chính sách 'Windows Firewall: Domain: Logging: Log successful connections'"
$rem3_1_7 = ("3.1.7  Thiết lập chính sách 'Windows Firewall: Domain: Logging: Log successful connections'")

#  3.1.7 (L1) - Ensure 'Windows Firewall: Domain: Logging: Log successful connections' is set to 'Yes'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" 2> $null | select-string 'LogSuccessfulConnections' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" | select-string 'LogSuccessfulConnections').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_7

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_7
	Add-Content -Path $file_remPath -Value $rem3_1_7

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_7
	Add-Content -Path $file_remPath -Value $rem3_1_7

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_7
	Add-Content -Path $file_remPath -Value $rem3_1_7

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_1_8 = "3.1.8  Thiết lập chính sách 'Windows Firewall: Domain: Settings: Display a notification'"
$rem3_1_8 = ("3.1.8  Thiết lập chính sách 'Windows Firewall: Domain: Settings: Display a notification'")

#  	3.1.8 (L1) - Ensure 'Windows Firewall: Domain: Settings: Display a notification' is set to 'No' 
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" 2> $null | select-string 'DisableNotifications' 2> $null |  Measure-Object | %{$_.Count})
	
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" | select-string 'DisableNotifications').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' ) {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_7
	} else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_7
	Add-Content -Path $file_remPath -Value $rem3_1_8
		}
	}
}else {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_7
	Add-Content -Path $file_remPath -Value $rem3_1_8
     }	
	
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_7
	Add-Content -Path $file_remPath -Value $rem3_1_8
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2 = "3.2  Private Profile"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var3_2

################################################################################################
$var3_2_1 = "3.2.1  Thiết lập trạng thái 'Windows Firewall: Private: Firewall state'"
$rem3_2_1 = ("3.2.1  Thiết lập trạng thái 'Windows Firewall: Private: Firewall state'")

#  3.2.1 (L1) - Ensure 'Windows Firewall: Private: Firewall state' is set to 'On (recommended)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" 2> $null | select-string 'EnableFirewall' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" | select-string 'EnableFirewall').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_1
	Add-Content -Path $file_remPath -Value $rem3_2_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_1
	Add-Content -Path $file_remPath -Value $rem3_2_1

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_1
	Add-Content -Path $file_remPath -Value $rem3_2_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_2 = "3.2.2  Thiết lập trạng thái 'Windows Firewall: Private: Inbound connections'"
$rem3_2_2 = ("3.2.2  Thiết lập trạng thái 'Windows Firewall: Private: Inbound connections'")

#  3.2.2 (L1) - Ensure 'Windows Firewall: Private: Inbound connections' is set to 'Block (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" 2> $null | select-string 'DefaultInboundAction' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" | select-string 'DefaultInboundAction').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_2
	Add-Content -Path $file_remPath -Value $rem3_2_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_2
	Add-Content -Path $file_remPath -Value $rem3_2_2

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_2
	Add-Content -Path $file_remPath -Value $rem3_2_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_3 = "3.2.3  Thiết lập trạng thái 'Windows Firewall: Private: Outbound connections'"
$rem3_2_3 = ("3.2.3  Thiết lập trạng thái 'Windows Firewall: Private: Outbound connections'")

#  3.2.3 (L1) - Ensure 'Windows Firewall: Private: Outbound connections' is set to 'Allow (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" 2> $null | select-string 'DefaultOutboundAction' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" | select-string 'DefaultOutboundAction').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_3
	Add-Content -Path $file_remPath -Value $rem3_2_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_3
	Add-Content -Path $file_remPath -Value $rem3_2_3

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_3
	Add-Content -Path $file_remPath -Value $rem3_2_3

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_4 = "3.2.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Private: Logging: Name'"
$rem3_2_4 = ("3.2.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Private: Logging: Name'")

#  3.2.4 (L1) - Ensure 'Windows Firewall: Private: Logging: Name' is set to '%SYSTEMROOT%\System32\logfiles\firewall\Privatefw.log'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" 2> $null | select-string ' LogFilePath' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" | select-string ' LogFilePath').ToString().Split('')[12].Trim() ) {
			if ( [string]$unique1 -eq [string]'%SYSTEMROOT%\System32\logfiles\firewall\Privatefw.log' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_4
	Add-Content -Path $file_remPath -Value $rem3_2_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_4
	Add-Content -Path $file_remPath -Value $rem3_2_4

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_4
	Add-Content -Path $file_remPath -Value $rem3_2_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_5 = "3.2.5  Cấu hình kích thước giới hạn 'Windows Firewall: Private: Logging: Size limit (KB)'"
$rem3_2_5 = ("3.2.5  Cấu hình kích thước giới hạn 'Windows Firewall: Private: Logging: Size limit (KB)'")

#  3.2.5 (L1) - Ensure 'Windows Firewall: Private: Logging: Size limit (KB)' is set to '16,384 KB or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" 2> $null | select-string ' LogFileSize' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" | select-string ' LogFileSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x4000' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_5

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_5
	Add-Content -Path $file_remPath -Value $rem3_2_5

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_5
	Add-Content -Path $file_remPath -Value $rem3_2_5

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_5
	Add-Content -Path $file_remPath -Value $rem3_2_5

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_6 = "3.2.6  Thiết lập chính sách 'Windows Firewall: Private: Logging: Log dropped packets'"
$rem3_2_6 = ("3.2.6  Thiết lập chính sách 'Windows Firewall: Private: Logging: Log dropped packets'")

#  3.2.6 (L1) - Ensure 'Windows Firewall: Private: Logging: Log dropped packets' is set to 'Yes'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" 2> $null | select-string ' LogDroppedPackets' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" | select-string ' LogDroppedPackets').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_6

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_6
	Add-Content -Path $file_remPath -Value $rem3_2_6

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_6
	Add-Content -Path $file_remPath -Value $rem3_2_6

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_6
	Add-Content -Path $file_remPath -Value $rem3_2_6

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_7 = "3.2.7  Thiết lập chính sách 'Windows Firewall: Private: Logging: Log successful connections"
$rem3_2_7 = ("3.2.7  Thiết lập chính sách 'Windows Firewall: Private: Logging: Log successful connections")

#  3.2.7 (L1) - Ensure 'Windows Firewall: Private: Logging: Log successful connections' is set to 'Yes'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" 2> $null | select-string 'LogSuccessfulConnections' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" | select-string 'LogSuccessfulConnections').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_7

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_7
	Add-Content -Path $file_remPath -Value $rem3_2_7

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_7
	Add-Content -Path $file_remPath -Value $rem3_2_7

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_7
	Add-Content -Path $file_remPath -Value $rem3_2_7

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2_8 = "3.2.8  Thiết lập trạng thái 'Windows Firewall: Private: Settings: Display a notification'"
$rem3_2_8 = ("3.2.8  Thiết lập trạng thái 'Windows Firewall: Private: Settings: Display a notification'")
#  	3.2.8 (L1) - Ensure 'Windows Firewall: Private: Settings: Display a notification' is set to 'No' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" 2> $null | select-string 'DisableNotifications' 2> $null |  Measure-Object | %{$_.Count})
	
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" | select-string 'DisableNotifications').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' ) {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_2_8
	} else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_8
	Add-Content -Path $file_remPath -Value $rem3_2_8
		}
	}
}else {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_8
	Add-Content -Path $file_remPath -Value $rem3_2_8
      }
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_2_8
	Add-Content -Path $file_remPath -Value $rem3_2_8
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3 = "3.3  Public Profile"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var3_3

################################################################################################
$var3_3_1 = "3.3.1  Thiết lập trạng thái 'Windows Firewall: Public: Firewall state'"
$rem3_3_1 = ("3.3.1  Thiết lập trạng thái 'Windows Firewall: Public: Firewall state'")

#  3.3.1 (L1) - Ensure 'Windows Firewall: Public: Firewall state' is set to 'On (recommended)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" 2> $null | select-string 'EnableFirewall' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" | select-string 'EnableFirewall').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_1
	Add-Content -Path $file_remPath -Value $rem3_3_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_1
	Add-Content -Path $file_remPath -Value $rem3_3_1

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_1
	Add-Content -Path $file_remPath -Value $rem3_3_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3_2 = "3.3.2  Thiết lập trạng thái 'Windows Firewall: Public: Inbound connections'"
$rem3_3_2 = ("3.3.2  Thiết lập trạng thái 'Windows Firewall: Public: Inbound connections'")

#  3.3.2 (L1) - Ensure 'Windows Firewall: Public: Inbound connections' is set to 'Block (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" 2> $null | select-string 'DefaultInboundAction' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" | select-string 'DefaultInboundAction').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_2
	Add-Content -Path $file_remPath -Value $rem3_3_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_2
	Add-Content -Path $file_remPath -Value $rem3_3_2

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_2
	Add-Content -Path $file_remPath -Value $rem3_3_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3_3 = "3.3.3  Thiết lập trạng thái 'Windows Firewall: Public: Outbound connections'"
$rem3_3_3 = ("3.3.3  Thiết lập trạng thái 'Windows Firewall: Public: Outbound connections'")

#  3.3.3 (L1) - Ensure 'Windows Firewall: Public: Outbound connections' is set to 'Allow (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" 2> $null | select-string 'DefaultOutboundAction' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" | select-string 'DefaultOutboundAction').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_3
	Add-Content -Path $file_remPath -Value $rem3_3_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_3
	Add-Content -Path $file_remPath -Value $rem3_3_3

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_3
	Add-Content -Path $file_remPath -Value $rem3_3_3

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3_4 = "3.3.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Public: Logging: Name'"
$rem3_3_4 = ("3.3.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Public: Logging: Name'")

#  3.3.4 (L1) - Ensure 'Windows Firewall: Public: Logging: Name' is set to '%SYSTEMROOT%\System32\logfiles\firewall\Publicfw.log'

$sid = (whoami /user | select-string 'S-').ToString().Split('')[1].Trim()
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" 2> $null | select-string ' LogFilePath' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" | select-string ' LogFilePath').ToString().Split('')[12].Trim() ) {
			if ( [string]$unique1 -eq [string]'%SYSTEMROOT%\System32\logfiles\firewall\Publicfw.log' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_4
	Add-Content -Path $file_remPath -Value $rem3_3_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_4
	Add-Content -Path $file_remPath -Value $rem3_3_4

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_4
	Add-Content -Path $file_remPath -Value $rem3_3_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3_5 = "3.3.5  Cấu hình kích thước giới hạn 'Windows Firewall: Public: Logging: Size limit (KB)'"
$rem3_3_5 = ("3.3.5  Cấu hình kích thước giới hạn 'Windows Firewall: Public: Logging: Size limit (KB)'")

#  3.3.5 (L1) - Ensure 'Windows Firewall: Public: Logging: Size limit (KB)' is set to '16,384 KB or greater'

$sid = (whoami /user | select-string 'S-').ToString().Split('')[1].Trim()
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" 2> $null | select-string ' LogFileSize' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" | select-string ' LogFileSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x4000' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_5

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_5
	Add-Content -Path $file_remPath -Value $rem3_3_5

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_5
	Add-Content -Path $file_remPath -Value $rem3_3_5

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_5
	Add-Content -Path $file_remPath -Value $rem3_3_5

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3_6 = "3.3.6  Thiết lập chính sách 'Windows Firewall: Public: Logging: Log dropped packets'"
$rem3_3_6 = ("3.3.6  Thiết lập chính sách 'Windows Firewall: Public: Logging: Log dropped packets'")

#  3.3.6 (L1) - Ensure 'Windows Firewall: Public: Logging: Log dropped packets' is set to 'Yes'

$sid = (whoami /user | select-string 'S-').ToString().Split('')[1].Trim()
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging")	
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" 2> $null | select-string ' LogDroppedPackets' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" | select-string ' LogDroppedPackets').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_6

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_6
	Add-Content -Path $file_remPath -Value $rem3_3_6

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_6
	Add-Content -Path $file_remPath -Value $rem3_3_6

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_6
	Add-Content -Path $file_remPath -Value $rem3_3_6

}
Finally { $ErrorActionPreference = "Continue" }
	
################################################################################################
$var3_3_7 = "3.3.7  Thiết lập chính sách 'Windows Firewall: Public: Logging: Log successful connections"
$rem3_3_7 = ("3.3.7  Thiết lập chính sách 'Windows Firewall: Public: Logging: Log successful connections")

#  3.3.7 (L1) - Ensure 'Windows Firewall: Public: Logging: Log successful connections' is set to 'Yes'

$sid = (whoami /user | select-string 'S-').ToString().Split('')[1].Trim()
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" 2> $null | select-string 'LogSuccessfulConnections' 2> $null |  Measure-Object | % { $_.Count })
	
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" | select-string 'LogSuccessfulConnections').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_7

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_7
	Add-Content -Path $file_remPath -Value $rem3_3_7

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_7
	Add-Content -Path $file_remPath -Value $rem3_3_7

	}
}
Catch [System.Management.Automation.ItemNotFoundException] {
 	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_7
	Add-Content -Path $file_remPath -Value $rem3_3_7

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_3_8 = "3.3.8  Thiết lập trạng thái 'Windows Firewall: Public: Settings: Display a notification'"
$rem3_3_8 = ("3.3.8  Thiết lập trạng thái 'Windows Firewall: Public: Settings: Display a notification'")
#  	3.3.8 (L1) - Ensure 'Windows Firewall: Public: Settings: Display a notification' is set to 'No' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" 2> $null | select-string 'DisableNotifications' 2> $null |  Measure-Object | %{$_.Count})
	
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" | select-string 'DisableNotifications').ToString().Split('')[12].Trim() ) {
	if ( [int]$unique1 -eq [int]'0x1' ) {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_3_8
	} else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_8
	Add-Content -Path $file_remPath -Value $rem3_3_8
		}
	}
}else {
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_8
	Add-Content -Path $file_remPath -Value $rem3_3_8
      }
}
Catch [System.Management.Automation.ItemNotFoundException]
{
  Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_3_8
	Add-Content -Path $file_remPath -Value $rem3_3_8
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var4 = "4  Cấu hình chính sách kiểm toán (Advanced)"
$var4_1 = "4.1  Tài khoản đăng nhập"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_1

################################################################################################
$var4_1_1 = "4.1.1  Cấu hình chính sách 'Audit Credential Validation'"
$rem4_1_1 = ("4.1.1  Cấu hình chính sách 'Audit Credential Validation'")

#  4.1.1 (L1) - Ensure 'Audit Credential Validation' is set to 'Success and Failure'

$unique = (auditpol /get /category:*   | select-string "Credential Validation" | Foreach { "$(($_ -split '\s+',4)[3])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
    	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_1_1
	Add-Content -Path $file_remPath -Value $rem4_1_1

}
else {
    	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_1_1

}

################################################################################################
$var4_1_2 = "4.1.2  Cấu hình chính sách 'Audit Kerberos Authentication Service' [Chỉ DC]"
$rem4_1_2 = ("4.1.2  Cấu hình chính sách 'Audit Kerberos Authentication Service' [Chỉ DC]")
#  4.1.2 (L1) - Ensure 'Audit Kerberos Authentication Service' is set to 'Success and Failure' (DC Only)
 
$unique = (auditpol.exe /get /category:*   | select-string "Kerberos Authentication Service" | Foreach { "$(($_ -split '\s+',5)[4])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_1_2
	Add-Content -Path $file_remPath -Value $rem4_1_2

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_1_2

}

################################################################################################
$var4_1_3 = "4.1.3  Cấu hình chính sách 'Audit Kerberos Service Ticket Operations' [Chỉ DC]"
$rem4_1_3 = ("4.1.3  Cấu hình chính sách 'Audit Kerberos Service Ticket Operations' [Chỉ DC]")

#  4.1.3 (L1) - Ensure 'Audit Kerberos Service Ticket Operations' is set to 'Success and Failure' (DC Only)

$unique = (auditpol.exe /get /category:*   | select-string "Kerberos Service Ticket Operations" | Foreach { "$(($_ -split '\s+',6)[5])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_1_3
	Add-Content -Path $file_remPath -Value $rem4_1_3

}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_1_3

}

################################################################################################
$var4_2 = "4.2  Quản lý tài khoản"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_2

################################################################################################
$var4_2_1 = "4.2.1  Cấu hình chính sách 'Audit Application Group Management'"
$rem4_2_1 = ("4.2.1  Cấu hình chính sách 'Audit Application Group Management'")
#  4.2.1 (L1) - Ensure 'Audit Application Group Management' is set to 'Success and Failure'

$unique = (auditpol.exe /get /category:*   | select-string "Application Group Management" | Foreach { "$(($_ -split '\s+',5)[4])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_1
	Add-Content -Path $file_remPath -Value $rem4_2_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_1

}
	
################################################################################################
$var4_2_2 = "4.2.2  Cấu hình chính sách 'Audit Computer Account Management' [Chỉ DC]"
$rem4_2_2 = ("4.2.2  Cấu hình chính sách 'Audit Computer Account Management' [Chỉ DC]")
#  4.2.2 (L1) - Ensure 'Audit Computer Account Management' is set to include 'Success' (DC only)

$unique = (auditpol.exe /get /category:*   | select-string "Computer Account Management" | Foreach { "$(($_ -split '\s+',5)[4])" })
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_2
	Add-Content -Path $file_remPath -Value $rem4_2_2

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_2

}

################################################################################################
$var4_2_3 = "4.2.3  Cấu hình chính sách 'Audit Distribution Group Management' [Chỉ DC]"
$rem4_2_3 = ("4.2.3  Cấu hình chính sách 'Audit Distribution Group Management' [Chỉ DC]")
#  4.2.3 (L1) - Ensure 'Audit Distribution Group Management' is set to include 'Success' (DC only)

$unique = auditpol.exe /get /category:*   | select-string "Distribution Group Management" | Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_3
	Add-Content -Path $file_remPath -Value $rem4_2_3

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_3

}

################################################################################################
$var4_2_4 = "4.2.4  Cấu hình chính sách 'Audit Other Account Management Events' [Chỉ DC]"
$rem4_2_4 = ("4.2.4  Cấu hình chính sách 'Audit Other Account Management Events' [Chỉ DC]")

#  4.2.4 (L1) - Ensure 'Audit Other Account Management Events' is set to include 'Success' (DC only)

$unique = auditpol.exe /get /category:*   | select-string "Other Account Management Events" | Foreach { "$(($_ -split '\s+',6)[5])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_4
	Add-Content -Path $file_remPath -Value $rem4_2_4

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_4

}

################################################################################################
$var4_2_5 = "4.2.5  Cấu hình chính sách 'Audit Security Group Management'"
$rem4_2_5 = ("4.2.5  Cấu hình chính sách 'Audit Security Group Management'")

#  4.2.5 (L1) - Ensure 'Audit Security Group Management' is set to include 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Security Group Management" | Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_5
	Add-Content -Path $file_remPath -Value $rem4_2_5

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_5

}

################################################################################################
$var4_2_6 = "4.2.6  Cấu hình chính sách 'Audit User Account Management'"
$rem4_2_6 = ("4.2.6  Cấu hình chính sách 'Audit User Account Management'")

#  4.2.6 (L1) - Ensure 'Audit User Account Management' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "User Account Management" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_6
	Add-Content -Path $file_remPath -Value $rem4_2_6

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_6

}

################################################################################################
$var4_3 = "4.3  Theo dõi chi tiết"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_3

################################################################################################
$var4_3_1 = "4.3.1  Cấu hình chính sách 'Audit Process Creation'"
$rem4_3_1 = ("4.3.1  Cấu hình chính sách 'Audit Process Creation'")

#  4.3.1 (L1) - Ensure 'Audit Process Creation' is set to include 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Process Creation" |  Foreach { "$(($_ -split '\s+',4)[3])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_3_1
	Add-Content -Path $file_remPath -Value $rem4_3_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_3_1

}

################################################################################################
$var4_3_2 = "4.3.2  Cấu hình chính sách 'Audit PNP Activity'"
$rem4_3_2 = ("4.3.2  Cấu hình chính sách 'Audit PNP Activity'")
# 4.3.2 - (L1) Ensure 'Audit PNP Activity' is set to include 'Success' (Scored)

$unique =  auditpol.exe /get /category:*   | select-string "Plug and Play Events" |  Foreach {"$(($_ -split '\s+',6)[5])"}
$output = "Success"
if ([string]$unique -ne [string]$output) {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_3_2
	Add-Content -Path $file_remPath -Value $rem4_3_2
	} else {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_3_2
	}

################################################################################################
$var4_4 = "4.4  Truy cập thư mục dịch vụ"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_4

################################################################################################
$var4_4_1 = "4.4.1  Cấu hình chính sách 'Audit Directory Service Access' [Chỉ DC]"
$rem4_4_1 = ("4.4.1  Cấu hình chính sách 'Audit Directory Service Access' [Chỉ DC]")

#  4.4.1 (L1) - Ensure 'Audit Directory Service Access' is set to include 'Failure' (DC only)

$unique = auditpol.exe /get /category:*   | select-string "Directory Service Access" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_4_1
	Add-Content -Path $file_remPath -Value $rem4_4_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_4_1

}

################################################################################################
$var4_4_2 = "4.4.2  Cấu hình chính sách 'Audit Directory Service Changes' [Chỉ DC]"
$rem4_4_2 = ("4.4.2  Cấu hình chính sách 'Audit Directory Service Changes' [Chỉ DC]")
#  4.4.2 (L1) - Ensure 'Audit Directory Service Changes' is set to include 'Failure' (DC only)
 
$unique = auditpol.exe /get /category:*   | select-string "Directory Service Changes" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_4_2
	Add-Content -Path $file_remPath -Value $rem4_4_2

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_4_2

}

################################################################################################
$var4_5 = "4.5  Đăng nhập/Đăng xuất"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_5

################################################################################################
$var4_5_1 = "4.5.1  Cấu hình chính sách 'Audit Account Lockout'"
$rem4_5_1 = ("4.5.1  Cấu hình chính sách 'Audit Account Lockout'")

#  4.5.1 (L1) - Ensure 'Audit Account Lockout' is set to include 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "Account Lockout" |  Foreach { "$(($_ -split '\s+',4)[3])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_1
	Add-Content -Path $file_remPath -Value $rem4_5_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_1

}

################################################################################################
$var4_5_2 = "4.5.2  Cấu hình chính sách 'Audit Logoff'"
$rem4_5_2 = ("4.5.2  Cấu hình chính sách 'Audit Logoff'")

#  4.5.2 (L1) - Ensure 'Audit Logoff' is set to include 'Success'

$unique = auditpol.exe /get /category:*   | select-string "  Logoff   "   | Foreach { "$(($_ -split '\s+',3)[2])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_2
	Add-Content -Path $file_remPath -Value $rem4_5_2

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_2

}

################################################################################################
$var4_5_3 = "4.5.3  Cấu hình chính sách 'Audit Logon'"
$rem4_5_3 = ("4.5.3  Cấu hình chính sách 'Audit Logon'")

#  4.5.3 (L1) - Ensure 'Audit Logon' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "  Logon   "   | Foreach { "$(($_ -split '\s+',3)[2])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_3
	Add-Content -Path $file_remPath -Value $rem4_5_3

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_3

}

################################################################################################
$var4_5_4 = "4.5.4  Cấu hình chính sách 'Audit Other Logon/Logoff Events'"
$rem4_5_4 = ("4.5.4  Cấu hình chính sách 'Audit Other Logon/Logoff Events'")

#  4.5.4 (L1) - Ensure 'Audit Other Logon/Logoff Events' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "Other Logon/Logoff Events" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_4
	Add-Content -Path $file_remPath -Value $rem4_5_4

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_4

}

################################################################################################
$var4_5_5 = "4.5.5  Cấu hình chính sách 'Audit Special Logon'"
$rem4_5_5 = ("4.5.5  Cấu hình chính sách 'Audit Special Logon'")

#  4.5.5. - Ensure 'Audit Special Logon' is set to include 'Success' (Scored)

$unique = auditpol.exe /get /category:*   | select-string "Special Logon" |  Foreach {"$(($_ -split '\s+',4)[3])"}
$output = "Success"
if ([string]$unique -ne [string]$output) {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_5
	Add-Content -Path $file_remPath -Value $rem4_5_5

	} else {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_5

	}

################################################################################################
$var4_5_6 = "4.5.6  Cấu hình chính sách 'Ensure 'Audit Group Membership'"
$rem4_5_6 = ("4.5.6  Cấu hình chính sách 'Ensure 'Audit Group Membership'")
# 4.5.6 - (L1) Ensure 'Audit Group Membership' is set to include 'Success' (Scored)

$unique = auditpol.exe /get /category:*   | select-string "Group Membership" |  Foreach {"$(($_ -split '\s+',4)[3])"}
$output = "Success"
if ([string]$unique -ne [string]$output) {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_6
	Add-Content -Path $file_remPath -Value $rem4_5_6
	} else {
		        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_6
	}
################################################################################################
$var4_6 = "4.6  Quyền truy cập đối tượng"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_6

################################################################################################
$var4_6_1 = "4.6.1  Cấu hình chính sách 'Audit Detailed File Share'"
$rem4_6_1 = ("4.6.1  Cấu hình chính sách 'Audit Detailed File Share'")

#  4.6.1 (L1) - Ensure 'Audit Detailed File Share' is set to include 'Failure'

$unique = (auditpol.exe /get /category:*   | select-string "Detailed File Share" | Foreach { "$(($_ -split '\s+',5)[4])" })
$output = "Failure"
if ([string]$unique -ne [string]$output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_6_1
	Add-Content -Path $file_remPath -Value $rem4_6_1

}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_6_1

}

################################################################################################
$var4_6_2 = "4.6.2  Cấu hình chính sách 'Audit File Share'"
$rem4_6_2 = ("4.6.2  Cấu hình chính sách 'Audit File Share'")

#  4.6.2 (L1) - Ensure 'Audit File Share' is set to 'Success and Failure'

$unique = (auditpol.exe /get /category:*   | select-string "  File Share" | Foreach { "$(($_ -split '\s+',4)[3])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_6_2
	Add-Content -Path $file_remPath -Value $rem4_6_2

}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_6_2

}

################################################################################################
$var4_6_3 = "4.6.3  Cấu hình chính sách 'Audit Other Object Access Events'"
$rem4_6_3 = ("4.6.3  Cấu hình chính sách 'Audit Other Object Access Events'")

#  4.6.3 (L1) - Ensure 'Audit Other Object Access Events' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "Other Object Access Events" |  Foreach { "$(($_ -split '\s+',6)[5])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_6_3
	Add-Content -Path $file_remPath -Value $rem4_6_3

}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_6_3

}

################################################################################################
$var4_6_4 = "4.6.4  Cấu hình chính sách 'Audit Removable Storage'"
$rem4_6_4 = ("4.6.4  Cấu hình chính sách 'Audit Removable Storage'")
#  4.6.4 (L1) - Ensure 'Audit Removable Storage' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "Removable Storage" |  Foreach { "$(($_ -split '\s+',4)[3])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_6_4
	Add-Content -Path $file_remPath -Value $rem4_6_4

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_6_4

}

################################################################################################
$var4_7 = "4.7  Thay đổi chính sách"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_7

################################################################################################
$var4_7_1 = "4.7.1  Cấu hình chính sách 'Audit Audit Policy Change'"
$rem4_7_1 = ("4.7.1  Cấu hình chính sách 'Audit Audit Policy Change'")

#  4.7.1 (L1) - Ensure 'Audit Audit Policy Change' is set to include 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Audit Policy Change" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_7_1
	Add-Content -Path $file_remPath -Value $rem4_7_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_7_1

}

################################################################################################
$var4_7_2 = "4.7.2  Cấu hình chính sách 'Audit Authentication Policy Change'"
$rem4_7_2 = ("4.7.2  Cấu hình chính sách 'Audit Authentication Policy Change'")

#  4.7.2 (L1) - Ensure 'Audit Authentication Policy Change' is set to 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Authentication Policy Change" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_7_2
	Add-Content -Path $file_remPath -Value $rem4_7_2

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_7_2

}

################################################################################################
$var4_7_3 = "4.7.3  Cấu hình chính sách 'Audit Authorization Policy Change'"
$rem4_7_3 = ("4.7.3  Cấu hình chính sách 'Audit Authorization Policy Change'")

#  4.7.3 (L1) - Ensure 'Audit Authorization Policy Change' is set to 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Authorization Policy Change" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_7_3
	Add-Content -Path $file_remPath -Value $rem4_7_3

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_7_3

}

################################################################################################
$var4_7_4 = "4.7.4  Cấu hình chính sách 'Audit MPSSVC Rule-Level Policy Change'"
$rem4_7_4 = ("4.7.4  Cấu hình chính sách 'Audit MPSSVC Rule-Level Policy Change'")

#  4.7.4 (L1) - Ensure 'Audit MPSSVC Rule-Level Policy Change' is set to 'Success and Failure'

$unique = (auditpol.exe /get /category:*   | select-string "MPSSVC Rule-Level Policy Change" | Foreach { "$(($_ -split '\s+',6)[5])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
        	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_7_4
	Add-Content -Path $file_remPath -Value $rem4_7_4

}
else {
        	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_7_4

}

################################################################################################
$var4_7_5 = "4.7.5  Cấu hình chính sách 'Audit Other Policy Change Events'"
$rem4_7_5 = ("4.7.5  Cấu hình chính sách 'Audit Other Policy Change Events'")

#  4.7.5 (L1) - Ensure 'Audit Other Policy Change Events' is set to include 'Failure'

$unique = auditpol.exe /get /category:*   | select-string "Other Policy Change Events" |  Foreach { "$(($_ -split '\s+',6)[5])" }
$output = "Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_7_5
	Add-Content -Path $file_remPath -Value $rem4_7_5

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_7_5

}

################################################################################################
$var4_8 = "4.8  Sử dụng đặc quyền"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_8

################################################################################################
$var4_8_1 = "4.8.1  Cấu hình chính sách 'Audit Sensitive Privilege Use'"
$rem4_8_1 = ("4.8.1  Cấu hình chính sách 'Audit Sensitive Privilege Use'")

#  4.8.1 (L1) - Ensure 'Audit Sensitive Privilege Use' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "  Sensitive Privilege Use  "  |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_8_1
	Add-Content -Path $file_remPath -Value $rem4_8_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_8_1

}

################################################################################################
$var4_9 = "4.9  Chính sách kiểm toán hệ thống"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_9

################################################################################################
$var4_9_1 = "4.9.1  Cấu hình chính sách 'Audit IPsec Driver'"
$rem4_9_1 = ("4.9.1  Cấu hình chính sách 'Audit IPsec Driver'")

#  4.9.1 (L1) - Ensure 'Audit IPsec Driver' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "IPsec Driver" |  Foreach { "$(($_ -split '\s+',4)[3])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_9_1
	Add-Content -Path $file_remPath -Value $rem4_9_1

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_9_1

}

################################################################################################
$var4_9_2 = "4.9.2  Cấu hình chính sách 'Audit Other System Events'"
$rem4_9_2 = ("4.9.2  Cấu hình chính sách 'Audit Other System Events'")

#  4.9.2 (L1) - Ensure 'Audit Other System Events' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "Other System Events" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_9_2
	Add-Content -Path $file_remPath -Value $rem4_9_2

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_9_2

}

################################################################################################
$var4_9_3 = "4.9.3  Cấu hình chính sách 'Audit Security State Change'"
$rem4_9_3 = ("4.9.3  Cấu hình chính sách 'Audit Security State Change'")

#  4.9.3 (L1) - Ensure 'Audit Security State Change' is set to include 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Security State Change" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_9_3
	Add-Content -Path $file_remPath -Value $rem4_9_3

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_9_3

}

################################################################################################
$var4_9_4 = "4.9.4  Cấu hình chính sách 'Audit Security System Extension'"
$rem4_9_4 = ("4.9.4  Cấu hình chính sách 'Audit Security System Extension'")

#  4.9.4 (L1) - Ensure 'Audit Security System Extension' is set to include 'Success'

$unique = auditpol.exe /get /category:*   | select-string "Security System Extension" |  Foreach { "$(($_ -split '\s+',5)[4])" }
$output = "Success"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_9_4
	Add-Content -Path $file_remPath -Value $rem4_9_4

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_9_4

}

################################################################################################
$var4_9_5 = "4.9.5  Cấu hình chính sách 'Audit System Integrity'"
$rem4_9_5 = ("4.9.5  Cấu hình chính sách 'Audit System Integrity'")

#  4.9.5 (L1) - Ensure 'Audit System Integrity' is set to 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "System Integrity" |  Foreach { "$(($_ -split '\s+',4)[3])" }
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_9_5
	Add-Content -Path $file_remPath -Value $rem4_9_5

}
else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_9_5

}

################################################################################################
$var5 = "5  Tệp mẫu quản trị chính sách nhóm"
$var5_1 = "5.1  Cấu hình Logon"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_1

################################################################################################
$var5_1_1 = "5.1.1  Cấu hình chính sách 'Turn off app notifications on the lock screen'"
$rem5_1_1 = ("5.1.1  Cấu hình chính sách 'Turn off app notifications on the lock screen'")

#  5.1.1 (L1) - Ensure 'Turn off app notifications on the lock screen' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" 2> $null | select-string 'DisableLockScreenAppNotifications' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" | select-string 'DisableLockScreenAppNotifications').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_1
	Add-Content -Path $file_remPath -Value $rem5_1_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_1
	Add-Content -Path $file_remPath -Value $rem5_1_1

	}
}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_1
	Add-Content -Path $file_remPath -Value $rem5_1_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_1_2 = "5.1.2  Cấu hình chính sách 'Turn off picture password sign-in'"
$rem5_1_2 = ("5.1.2  Cấu hình chính sách 'Turn off picture password sign-in'")

#  5.1.2 (L1) - Ensure 'Turn off picture password sign-in' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" 2> $null | select-string 'BlockDomainPicturePassword' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" | select-string 'BlockDomainPicturePassword').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_2
	Add-Content -Path $file_remPath -Value $rem5_1_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_2
	Add-Content -Path $file_remPath -Value $rem5_1_2

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_2
	Add-Content -Path $file_remPath -Value $rem5_1_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_1_3 = "5.1.3  Cấu hình chính sách 'Turn on convenience PIN sign-in'"
$rem5_1_3 = ("5.1.3  Cấu hình chính sách 'Turn on convenience PIN sign-in'")

#  5.1.3 (L1) - Ensure 'Turn on convenience PIN sign-in' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" 2> $null | select-string 'AllowDomainPINLogon' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" | select-string 'AllowDomainPINLogon').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_3
	Add-Content -Path $file_remPath -Value $rem5_1_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_3
	Add-Content -Path $file_remPath -Value $rem5_1_3

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_3
	Add-Content -Path $file_remPath -Value $rem5_1_3

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_1_4 = "5.1.4  Cấu hình chính sách 'Block user from showing account details on sign-in'"
$rem5_1_4 = ("5.1.4  Cấu hình chính sách 'Block user from showing account details on sign-in'")

#  5.2.1 (L1) - Ensure 'Require a password when a computer wakes (on battery)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51" 2> $null | select-string 'DCSettingIndex' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51" | select-string 'DCSettingIndex').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_4

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_4
	Add-Content -Path $file_remPath -Value $rem5_1_4

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_4
	Add-Content -Path $file_remPath -Value $rem5_1_4

	}
}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_4
	Add-Content -Path $file_remPath -Value $rem5_1_4

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_1_5 = "5.1.5  Cấu hình chính sách 'Do not display network selection UI'"
$rem5_1_5 = ("5.1.5  Cấu hình chính sách 'Do not display network selection UI'")

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
#  	5.1.5 (L1) - Ensure 'Do not display network selection UI' is set to 'Enabled' (Scored)

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" 2> $null | select-string 'DontDisplayNetworkSelectionUI' 2> $null |  Measure-Object | %{$_.Count})
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" | select-string 'DontDisplayNetworkSelectionUI').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
				                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_5
			} else {
				                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_5
	Add-Content -Path $file_remPath -Value $rem5_1_5
				}
							}
	}else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_5
	Add-Content -Path $file_remPath -Value $rem5_1_5
	}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
 
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_5
	Add-Content -Path $file_remPath -Value $rem5_1_5
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_1_6 = "5.1.6  Cấu hình chính sách 'Do not enumerate connected users on domain joined computers'"
$rem5_1_6 = ("5.1.6  Cấu hình chính sách 'Do not enumerate connected users on domain joined computers'")

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
#  	5.1.6 (L1) - Ensure 'Do not enumerate connected users on domainjoined computers' is set to 'Enabled' (Scored)

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" 2> $null | select-string 'DontEnumerateConnectedUsers' 2> $null |  Measure-Object | %{$_.Count})
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" | select-string 'DontEnumerateConnectedUsers').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
				                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_6
			} else {
				                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_6
	Add-Content -Path $file_remPath -Value $rem5_1_6
				}
							}
	}else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_6
	Add-Content -Path $file_remPath -Value $rem5_1_6
	}

}

Catch [System.Management.Automation.ItemNotFoundException]
{
 
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_6
	Add-Content -Path $file_remPath -Value $rem5_1_6
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_1_7 = "5.1.7  Cấu hình chính sách 'Enumerate local users on domain-joined computers' [Chỉ MS]"
$rem5_1_7 = "5.1.7  Cấu hình chính sách 'Enumerate local users on domain-joined computers' [Chỉ MS]"

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

#  	5.1.7 (L1) - Ensure 'Enumerate local users on domain-joined computers' is set to 'Disabled' (MS only) (Scored)

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" 2> $null | select-string 'EnumerateLocalUsers' 2> $null |  Measure-Object | %{$_.Count})
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" | select-string 'EnumerateLocalUsers').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
				                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_1_7
			} else {
				                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_7
	Add-Content -Path $file_remPath -Value $rem5_1_7
				}
							}
	}else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_7
	Add-Content -Path $file_remPath -Value $rem5_1_7
	}
}

Catch [System.Management.Automation.ItemNotFoundException]
{
 
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_1_7
	Add-Content -Path $file_remPath -Value $rem5_1_7
 }
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_2 = "5.2  Cấu hình Power Management"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_2

################################################################################################
$var5_2_1 = "5.2.1  Cấu hình chính sách 'Require a password when a computer wakes (on battery)'"
$rem5_2_1 = ("5.2.1  Cấu hình chính sách 'Require a password when a computer wakes (on battery)'")

#  5.2.1 (L1) - Ensure 'Require a password when a computer wakes (on battery)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51" 2> $null | select-string 'DCSettingIndex' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51" | select-string 'DCSettingIndex').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
				                Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_2_1
			}
			else {
				                Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_2_1
	Add-Content -Path $file_remPath -Value $rem5_2_1
			}
		}
	}
	else {
		        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_2_1
	Add-Content -Path $file_remPath -Value $rem5_2_1
	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
	    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_2_1
	Add-Content -Path $file_remPath -Value $rem5_2_1
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_2_2 = "5.2.2  Cấu hình chính sách 'Require a password when a computer wakes (plugged in)'"
$rem5_2_2 = ("5.2.2  Cấu hình chính sách 'Require a password when a computer wakes (plugged in)'")

#  5.2.2 (L1) - Ensure 'Require a password when a computer wakes (plugged in)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51" 2> $null | select-string 'ACSettingIndex' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51" | select-string 'ACSettingIndex').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_2_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_2_2
	Add-Content -Path $file_remPath -Value $rem5_2_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_2_2
	Add-Content -Path $file_remPath -Value $rem5_2_2

	}
}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_2_2
	Add-Content -Path $file_remPath -Value $rem5_2_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_3 = "5.3  Cấu hình chính sách AutoPlay"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_3

################################################################################################
$var5_3_1 = "5.3.1  Cấu hình chính sách 'Disallow Autoplay for non-volume devices'"
$rem5_3_1 = ("5.3.1  Cấu hình chính sách 'Disallow Autoplay for non-volume devices'")

#  5.3.1 (L1) - Ensure 'Disallow Autoplay for non-volume devices' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" 2> $null | select-string 'NoAutoplayfornonVolume' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" | select-string 'NoAutoplayfornonVolume').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_3_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_1
	Add-Content -Path $file_remPath -Value $rem5_3_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_1
	Add-Content -Path $file_remPath -Value $rem5_3_1

	}
}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_1
	Add-Content -Path $file_remPath -Value $rem5_3_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_3_2 = "5.3.2  Cấu hình chính sách 'Set the default behavior for AutoRun'"
$rem5_3_2 = ("5.3.2  Cấu hình chính sách 'Set the default behavior for AutoRun'")

#  5.3.2 (L1) - Ensure 'Set the default behavior for AutoRun' is set to 'Enabled: Do not execute any autorun commands'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" 2> $null | select-string 'NoAutorun' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | select-string 'NoAutorun').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x1' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_3_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_2
	Add-Content -Path $file_remPath -Value $rem5_3_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_2
	Add-Content -Path $file_remPath -Value $rem5_3_2

	}
}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_2
	Add-Content -Path $file_remPath -Value $rem5_3_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_3_3 = "5.3.3  Cấu hình chính sách 'Turn off Autoplay'"
$rem5_3_3 = ("5.3.3  Cấu hình chính sách 'Turn off Autoplay'")

#  5.3.3 (L1) - Ensure 'Turn off Autoplay' is set to 'Enabled: All drives'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" 2> $null | select-string 'NoDriveTypeAutoRun' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | select-string 'NoDriveTypeAutoRun').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0xff' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_3_3

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_3
	Add-Content -Path $file_remPath -Value $rem5_3_3

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_3
	Add-Content -Path $file_remPath -Value $rem5_3_3

	}
}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_3_3
	Add-Content -Path $file_remPath -Value $rem5_3_3

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4 = "5.4  Thiết lập kích thước và sao lưu file log"
$var5_4_1 = "5.4.1  Application"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_4
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_4_1

################################################################################################
$var5_4_1_1 = "5.4.1.1  Thiết lập chính sách 'Application: Control Event Log behavior when the log file reaches its maximum size'"
$rem5_4_1_1 = ("5.4.1.1  Thiết lập chính sách 'Application: Control Event Log behavior when the log file reaches its maximum size'")

#  5.4.1.1 (L1) - Ensure 'Application: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" 2> $null | select-string 'Retention' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" | select-string 'Retention').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_1_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_1_1
	Add-Content -Path $file_remPath -Value $rem5_4_1_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_1_1
	Add-Content -Path $file_remPath -Value $rem5_4_1_1

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_1_1
	Add-Content -Path $file_remPath -Value $rem5_4_1_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_1_2 = "5.4.1.2  Thiết lập chính sách 'Application: Specify the maximum log file size [KB]"
$rem5_4_1_2 = ("5.4.1.2  Thiết lập chính sách 'Application: Specify the maximum log file size [KB]")

#  5.4.1.2 (L1) - Ensure 'Application: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" 2> $null | select-string 'MaxSize' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" | select-string 'MaxSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x8000') {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_1_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_1_2
	Add-Content -Path $file_remPath -Value $rem5_4_1_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_1_2
	Add-Content -Path $file_remPath -Value $rem5_4_1_2

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_1_2
	Add-Content -Path $file_remPath -Value $rem5_4_1_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_2 = "5.4.2  Security"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_4_2

################################################################################################
$var5_4_2_1 = "5.4.2.1  Thiết lập chính sách 'Security: Control Event Log behavior when the log file reaches its maximum size'"
$rem5_4_2_1 = ("5.4.2.1  Thiết lập chính sách 'Security: Control Event Log behavior when the log file reaches its maximum size'")

#  5.4.2.1 (L1) - Ensure 'Security: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security" 2> $null | select-string 'Retention' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security" | select-string 'Retention').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_2_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_2_1
	Add-Content -Path $file_remPath -Value $rem5_4_2_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_2_1
	Add-Content -Path $file_remPath -Value $rem5_4_2_1

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_2_1
	Add-Content -Path $file_remPath -Value $rem5_4_2_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_2_2 = "5.4.2.2  Thiết lập chính sách 'Security: Specify the maximum log file size [KB]"
$rem5_4_2_2 = ("5.4.2.2  Thiết lập chính sách 'Security: Specify the maximum log file size [KB]")

#  5.4.2.2 (L1) - Ensure 'Security: Specify the maximum log file size (KB)' is set to 'Enabled: 196,608 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security" 2> $null | select-string 'MaxSize' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security" | select-string 'MaxSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x30000' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_2_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_2_2
	Add-Content -Path $file_remPath -Value $rem5_4_2_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_2_2
	Add-Content -Path $file_remPath -Value $rem5_4_2_2

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_2_2
	Add-Content -Path $file_remPath -Value $rem5_4_2_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_3 = "5.4.3  Setup"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_4_3

################################################################################################
$var5_4_3_1 = "5.4.3.1  Thiết lập chính sách 'Setup: Control Event Log behavior when the log file reaches its maximum size'[KB]'"
$rem5_4_3_1 = ("5.4.3.1  Thiết lập chính sách 'Setup: Control Event Log behavior when the log file reaches its maximum size'[KB]'")
#  5.4.3.1 (L1) - Ensure 'Setup: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup" 2> $null | select-string 'Retention' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup" | select-string 'Retention').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_3_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_3_1
	Add-Content -Path $file_remPath -Value $rem5_4_3_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_3_1
	Add-Content -Path $file_remPath -Value $rem5_4_3_1

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_3_1
	Add-Content -Path $file_remPath -Value $rem5_4_3_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_3_2 = "5.4.3.2  Thiết lập chính sách 'Setup: Specify the maximum log file size [KB]'"
$rem5_4_3_2 = ("5.4.3.2  Thiết lập chính sách 'Setup: Specify the maximum log file size [KB]'")

#  5.4.3.2 (L1) - Ensure 'Setup: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup" 2> $null | select-string 'MaxSize' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup" | select-string 'MaxSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x8000' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_3_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_3_2
	Add-Content -Path $file_remPath -Value $rem5_4_3_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_3_2
	Add-Content -Path $file_remPath -Value $rem5_4_3_2

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_3_2
	Add-Content -Path $file_remPath -Value $rem5_4_3_2

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_4 = "5.4.4  System"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var5_4_4

################################################################################################
$var5_4_4_1 = "5.4.4.1  Thiết lập chính sách 'System: Control Event Log behavior when the log file reaches its maximum size'"
$rem5_4_4_1 = ("5.4.4.1  Thiết lập chính sách 'System: Control Event Log behavior when the log file reaches its maximum size'")

#  5.4.4.1 (L1) - Ensure 'System: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System" 2> $null | select-string 'Retention' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System" | select-string 'Retention').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_4_1

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_4_1
	Add-Content -Path $file_remPath -Value $rem5_4_4_1

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_4_1
	Add-Content -Path $file_remPath -Value $rem5_4_4_1

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_4_1
	Add-Content -Path $file_remPath -Value $rem5_4_4_1

}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var5_4_4_2 = "5.4.4.2  Thiết lập chính sách 'System: Specify the maximum log file size [KB]'"
$rem5_4_4_2 = ("5.4.4.2  Thiết lập chính sách 'System: Specify the maximum log file size [KB]'")

#  5.4.4.2 (L1) - Ensure 'System: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System" 2> $null | select-string 'MaxSize' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System" | select-string 'MaxSize').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -ge [int]'0x8000' ) {
					Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var5_4_4_2

			}
			else {
					Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_4_2
	Add-Content -Path $file_remPath -Value $rem5_4_4_2

			}
		}
	}
	else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_4_2
	Add-Content -Path $file_remPath -Value $rem5_4_4_2

	}

}

Catch [System.Management.Automation.ItemNotFoundException] {
 
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var5_4_4_2
	Add-Content -Path $file_remPath -Value $rem5_4_4_2

}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var6 = "6  Cài đặt và cập nhật các bản vá bảo mật"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var6

################################################################################################
# encoding: utf-8
$var6_1 = "6.1  Cài đặt và cập nhật các bản vá bảo mật"
Write-Host -ForegroundColor Blue "Log: " -NoNewline;Write-Host $var6_1
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1

################################################################################################
$var7 = "7  Kiểm tra cài đặt phần mềm Anti-virus"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var7

################################################################################################
$var7_1 = "7.1  Kiểm tra trạng thái phần mềm"
$var7_2 = "7.2  Kiểm tra tính năng tự động cập nhật của phần mềm"
$var7_3 = "7.3  Thực hiện lịch quét định kỳ máy chủ"
################################################################################################
# encoding: utf-8
    # Nếu không tìm thấy lớp chứa từ khóa "Antivirus", kiểm tra xem Windows Defender có được cài đặt hay không
    if (Get-WindowsFeature -Name Windows-Defender | Where-Object {$_.InstallState -eq 'Installed'}) {
                $defender = Get-MpComputerStatus
if ($defender.AntivirusEnabled -eq $true) {
    # Nếu Windows Defender được kích hoạt, kiểm tra trạng thái Protect On và Update
    $defenderSettings = Get-MpPreference
    if ($defenderSettings.RealTimeProtectionEnabled -eq $true) {
        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var7_1
    }
    else {
        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var7_1
    }
    
    if ($defenderSettings.SignatureUpdateInterval -eq "0") {
        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var7_2
    }
    else {
        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var7_2
    }

    $defenderPref = Get-MpPreference
        if($defenderPref.ScheduledScanTime -eq ""){
            Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var7_3
            
        }else{
            Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var7_3
        }
}
else {
    Write-Host "Windows Defender is not installed on this computer."
}
    } else {
        Write-Host "Windows Defender is not installed on this computer"
    }

