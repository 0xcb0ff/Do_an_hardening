
$info = "[INFO] "
$fail = "[FAILED] "
$pass = "[PASSED] "

$file_remPath = "C:\Users\Public\remediation_filename.txt"
$textContent = "REMENDIATION!!!!!!!!!!!!"
$textContent | Set-Content -Path $file_remPath -Encoding UTF8
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
-----------------------------------------------
Tác động: Tác động chính của cấu hình này là khi người dùng thay đổi mật khẩu, yêu cầu người dùng phải chọn mật khẩu mới với các giá trị duy nhất, có nguy cơ cao là người dùng sẽ viết mật khẩu xuống nơi nào đó để không quên chúng. Một nguy cơ khác là người dùng có thể tạo mật khẩu thay đổi theo cách tăng dần (ví dụ: password01, password02,...) để dễ nhớ nhưng cũng làm cho chúng dễ đoán hơn. Ngoài ra thiết lập này có thể tăng cường chi phí quản trị, vì người dùng quên mật khẩu có thể thường xuyên yêu cầu bộ phận hỗ trợ đặt lại mật khẩu.
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
-----------------------------------------------
Tác động: Nếu giá trị này quá thấp, người dùng sẽ phải thay đổi mật khẩu thường xuyên. Cấu hình như vậy có thể giảm độ an toàn trong tổ chức, vì người dùng có thể viết mật khẩu của họ ở một vị trí không an toàn hoặc mất chúng. Nếu giá trị cho thiết lập này quá cao, mức độ an toàn trong tổ chức giảm đi vì nó cho phép kẻ tấn công có thêm thời gian để tìm kiếm mật khẩu người dùng hoặc sử dụng các tài khoản bị lộ.
")
$output = '90'
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
-----------------------------------------------
Tác động: Nếu một quản trị viên đặt mật khẩu cho một người dùng nhưng muốn người đó thay đổi mật khẩu khi người đó đăng nhập lần đầu tiên, quản trị viên phải chọn mục 'User must change password at next logon', hoặc người dùng sẽ không thể thay đổi mật khẩu cho đến thời gian được cấu hình.
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
$rem1_1_4 = ("1.1.4  Cấu hình tham số 'Minimum password length'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: >= 8
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Password Policy\Minimum password length
-----------------------------------------------
Tác động: Yêu cầu mật khẩu quá dài thực tế có thể giảm độ an toàn của một tổ chức, vì người dùng có thể để thông tin đó ở một vị trí không an toàn hoặc mất nó. Nếu yêu cầu mật khẩu rất dài, việc nhập sai mật khẩu có thể gây khóa tài khoản và làm tăng số lượng cuộc gọi đến bộ phận hỗ trợ. Nếu tổ chức gặp vấn đề với việc quên mật khẩu do yêu cầu độ dài mật khẩu, hãy xem xét việc hướng dẫn người dùng về việc sử dụng 'passphrases' (cụm từ mật khẩu), chúng thường dễ nhớ hơn và, do số lượng kết hợp ký tự lớn hơn.
")
#  1.1.4 (L1) - Ensure 'Minimum password length' is set to '14 or more character(s)'
$output = '8'
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
$rem1_1_5 = ("1.1.5  Cấu hình độ phức tạp của mật khẩu 'Password must meet  complexity requirements'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Password Policy\Password must meet complexity requirements
-----------------------------------------------
Tác động: Việc sử dụng kết hợp ký tự đặc biệt có thể tăng độ phức tạp của mật khẩu. Tuy nhiên, yêu cầu mật khẩu nghiêm ngặt như vậy có thể dẫn đến sự không hài lòng của người dùng và khiến cho bộ phận hỗ trợ rất bận rộn.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var1_1_6 = "1.1.6  Cấu hình tham số 'Store passwords using reversible encryption'"
$rem1_1_6 = ("1.1.6  Cấu hình tham số 'Store passwords using reversible encryption'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Password Policy\Store passwords using reversible encryption
* Lưu ý: Cấu hình tham số sẽ là Enabled nếu sử dụng giao thức xác thực CHAP thông qua truy cập từ xa, các dịch vụ IAS hoặc Digest Authentication trong IIS
-----------------------------------------------
Tác động: Việc áp dụng cài đặt này thông qua Chính sách Nhóm trên cơ sở từng người dùng là rất nguy hiểm, vì nó đòi hỏi mở đối tượng tài khoản người dùng tương ứng trong Active Directory Users and Computers.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var1_2 = "1.2  Chính sách khóa tài khoản"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var1_2

################################################################################################
$var1_2_1 = "1.2.1  Cấu hình tham số 'Account lockout duration'"
$rem1_2_1 = ("1.2.1  Cấu hình tham số 'Account lockout duration'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: >= 15
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Account Lockout Policy\Account lockout duration
-----------------------------------------------
Tác động: Cấu hình này có thể làm tăng số lượng yêu cầu mà bộ phận hỗ trợ của tổ chức về việc mở khoá những tài khoản bị khoá một cách nhầm lẫn.
")
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
$rem1_2_2 = ("1.2.2  Cấu hình tham số 'Account lockout threshold'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: <= 5 (khác 0)
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Account Lockout Policy\Account lockout threshold
-----------------------------------------------
Tác động: Nếu cài đặt chính sách này được bật, tài khoản bị khoá sẽ không sử dụng được cho đến khi được đặt lại bởi quản trị viên hoặc cho đến khi thời gian khoá tài khoản hết hạn. Cài đặt này có thể tạo thêm cuộc gọi đến bộ phận hỗ trợ. Kẻ tấn công có thể tạo ra điều kiện từ chối dịch vụ bằng cách có chủ ý tạo ra nhiều lần đăng nhập không thành công cho nhiều người dùng, do đó cũng nên cấu hình thành một giá trị tương đối thấp. Nếu cấu hình thành 0, có khả năng rằng một cuộc tấn công mật khẩu brute force có thể không được phát hiện nếu không có một cơ chế kiểm tra dấu vết mạnh mẽ.
")
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
$rem1_2_3 = ("1.2.3  Cấu hình tham số 'Reset account lockout counter after'
Cấu hình tham số theo đường dẫn sau với giá trị khuyến nghị: >= 15 (phút)
Computer Configuration\Policies\Windows Settings\Security Settings\Account Policies\Account Lockout Policy\Reset account lockout counter after
-----------------------------------------------
Tác động: Nếu không cấu hình cài đặt chính sách này hoặc nếu giá trị được cấu hình thành một khoảng thời gian quá lâu, có thể xảy ra một cuộc tấn công từ chối dịch vụ. Một kẻ tấn công có thể cố ý thử đăng nhập vào mỗi tài khoản người dùng nhiều lần và khoá tài khoản của họ như mô tả trong các đoạn trước đó. Nếu không cấu hình cài đặt này quản trị viên sẽ phải mở khoá tất cả các tài khoản thủ công. 
")
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
$rem2_1_1 = ("2.1.1  Cấu hình chính sách 'Access Credential Manager as a trusted caller'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Access Credential Manager as a trusted caller
-----------------------------------------------
Tác động: Không có - đây là hành vi mặc định
")
secedit /export /cfg c:\secpol.cfg > $null
$output = (Get-content c:\secpol.cfg | select-string SeTrustedCredManAccessPrivilege) |  Measure-Object | % { $_.Count }
if ($output -eq "1") {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_1
	Add-Content -Path $file_remPath -Value $rem2_1_1
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_1
}
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_2 = "2.1.2  Cấu hình chính sách 'Access this computer from the network' [Chỉ MS]"
$rem2_1_2 = ("2.1.2  Cấu hình chính sách 'Access this computer from the network' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators, Authenticated Users
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Access this computer from the network
-----------------------------------------------
Tác động: Nếu xóa quyền người dùng Access this computer from the network trên Domain Controllers cho tất cả người dùng, không ai có thể đăng nhập vào miền hoặc sử dụng tài nguyên mạng. Nếu xóa quyền này trên Member Servers, người dùng sẽ không thể kết nối đến các máy chủ đó qua mạng.
")
#  2.2.3 (L1) - Ensure 'Access this computer from the network' is set to 'Administrators, Authenticated Users' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544'
$output = (Get-content c:/secpol.cfg | select-string 'SeNetworkLogonRight').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_2
	Add-Content -Path $file_remPath -Value $rem2_1_2
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_2
}
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
<#
$var2_1_2DC = "2.1.2[DC]  Cấu hình chính sách 'Access this computer from the network' [Chỉ DC]"
$rem2_1_2DC = ("2.1.2[DC]  Cấu hình chính sách 'Access this computer from the network' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators, Authenticated Users, ENTERPRISE DOMAIN CONTROLLERS
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Access this computer from the network
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false
#>

################################################################################################
$var2_1_3 = "2.1.3  Cấu hình chính sách 'Act as part of the operating system'"
$rem2_1_3 = ("2.1.3  Cấu hình chính sách 'Act as part of the operating system'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Act as part of the operating system
-----------------------------------------------
Tác động: Không có tác động lớn tới hệ thống
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#
$var2_1_4 = "2.1.4  Cấu hình chỉ định người dùng được thêm các máy trạm vào Domain [Chỉ DC]"
$rem2_1_4 = ("2.1.4  Cấu hình chỉ định người dùng được thêm các máy trạm vào Domain [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Add workstations to domain
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 
#>

################################################################################################
$var2_1_5 = "2.1.5  Cấu hình chính sách 'Adjust memory quotas for a process'"
$rem2_1_5 = ("2.1.5  Cấu hình chính sách 'Adjust memory quotas for a process'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators, LOCAL SERVICE, NETWORK SERVICE
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Adjust memory quotas for a process
-----------------------------------------------
Tác động: Không có tác động lớn tới hệ thống
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_6 = "2.1.6  Cấu hình chính sách 'Allow log on locally'"
$rem2_1_6 = ("2.1.6  Cấu hình chính sách 'Allow log on locally'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Allow log on locally
-----------------------------------------------
Tác động: Nếu cấu hình có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_7 = "2.1.7  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ MS]"
$rem2_1_7 = ("2.1.7  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, Remote Desktop Users
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Allow log on through Remote Desktop Services
-----------------------------------------------
Tác động: Nếu cấu hình có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#
$var2_1_7DC = "2.1.7[DC]  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ DC]"
$rem2_1_7DC = ("2.1.7[DC]  Cấu hình chính sách 'Allow log on through Remote Desktop Services' - [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Đối với DC: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Allow log on through Remote Desktop Services
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false
#>

################################################################################################
$var2_1_8 = "2.1.8  Cấu hình sao lưu tệp và thư mục 'Back up files and directories'"
$rem2_1_8 = ("2.1.8  Cấu hình sao lưu tệp và thư mục 'Back up files and directories'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Back up files and directories
-----------------------------------------------
Tác động: Nếu cấu hình có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_9 = "2.1.9  Cấu hình thay đổi thời gian hệ thống 'Change the system time'"
$rem2_1_9 = ("2.1.9  Cấu hình thay đổi thời gian hệ thống 'Change the system time'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, LOCAL SERVICE
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Change the system time
-----------------------------------------------
Tác động: Nếu cấu hình có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_10 = "2.1.10  Cấu hình thay đổi thời gian hệ thống 'Change the time zone'"
$rem2_1_10 = ("2.1.10  Cấu hình thay đổi thời gian hệ thống 'Change the time zone'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, LOCAL SERVICE
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Change the time zone
-----------------------------------------------
Tác động: Nếu cấu hình có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_11 = "2.1.11  Cấu hình chính sách 'Create a pagefile'"
$rem2_1_11 = ("2.1.11  Cấu hình chính sách 'Create a pagefile'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Create a pagefile
-----------------------------------------------
Tác động: Không tác động tới hệ thống.
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_12 = "2.1.12  Cấu hình chính sách 'Create a token object'"
$rem2_1_12 = ("2.1.12  Cấu hình chính sách 'Create a token object'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Create a token object
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_13 = "2.1.13  Cấu hình chính sách 'Create global objects'"
$rem2_1_13 = ("2.1.13  Cấu hình chính sách 'Create global objects'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Create global objects
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_14 = "2.1.14  Cấu hình chính sách 'Create permanent shared objects'"
$rem2_1_14 = ("2.1.14  Cấu hình chính sách 'Create permanent shared objects'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Create permanent shared objects
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_15 = "2.1.15  Cấu hình chính sách 'Create symbolic links' - [Chỉ MS]"
$rem2_1_15 = ("2.1.15  Cấu hình chính sách 'Create symbolic links' - [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Đối với MS: Administrators, NT VIRTUAL MACHINE\Virtual Machines (khi Hyper-V role được cài đặt cho máy chủ MS)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Create symbolic links
-----------------------------------------------
Tác động: Trong hầu hết các trường hợp, sẽ không có tác động vì đây là cấu hình mặc định. Tuy nhiên, trên các máy chủ Windows có cài đặt vai trò máy chủ Hyper-V, quyền người dùng này cũng nên được cấp cho nhóm đặc biệt 'Virtual Machines' - nếu không, sẽ không thể tạo máy ảo mới.
")
#  2.1.15 (L1) - Ensure 'Create symbolic links' is set to 'Administrators, NT VIRTUAL MACHINE\Virtual Machines' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-83-0'
$unique_no_hyperv = '*S-1-5-32-544'
$output = (Get-content c:\secpol.cfg | select-string 'SeCreateSymbolicLinkPrivilege').ToString().Split('=')[1].Trim()

$installDate = (Get-WindowsFeature -Name Hyper-V).InstallDate
if ([string]::IsNullOrEmpty($installDate)) {
    if ($unique_no_hyperv -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_15
		Add-Content -Path $file_remPath -Value $rem2_1_15
	}
	else 
	{
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_15
	}

} else {
    if ($unique -ne $output) {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_15
		Add-Content -Path $file_remPath -Value $rem2_1_15
	}
	else {
		Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_15
	}
}

Remove-Item -force c:\secpol.cfg -confirm:$false
<#
################################################################################################
$var2_1_15DC = "2.1.15[DC]  Cấu hình chính sách 'Create symbolic links' - [Chỉ DC]"
$rem2_1_15DC = ("2.1.15[DC]  Cấu hình chính sách 'Create symbolic links' - [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Create symbolic links
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false
#>
################################################################################################
$var2_1_16 = "2.1.16  Cấu hình chính sách 'Debug programs'"
$rem2_1_16 = ("2.1.16  Cấu hình chính sách 'Debug programs'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Debug programs
-----------------------------------------------
Tác động: Nếu thu hồi quyền người dùng này, không ai có thể gỡ lỗi chương trình.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#
$var2_1_17DC = "2.1.17[DC]  Cấu hình chính sách 'Deny access to this computer from the network' [Chỉ DC]"
$rem2_1_17DC = ("2.1.17[DC]  Cấu hình chính sách 'Deny access to this computer from the network' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Guests 
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Deny access to this computer from the network
-----------------------------------------------
Tác động: 
")
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
	Add-Content -Path $file_remPath -Value $rem2_1_17DC
}
Remove-Item -force c:\secpol.cfg -confirm:$false 
#>

################################################################################################
$var2_1_18 = "2.1.18  Cấu hình chính sách 'Deny log on as a batch job'"
$rem2_1_18 = ("2.1.18  Cấu hình chính sách 'Deny log on as a batch job'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Guests
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Deny log on as a batch job
-----------------------------------------------
Tác động: Nếu gán quyền người dùng 'Deny log on as a batch job' cho các tài khoản khác, có thể từ chối quyền đối với người dùng được gán cho các vai trò quản trị cụ thể trong khả năng thực hiện các hoạt động công việc yêu cầu của họ.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_19 = "2.1.19  Cấu hình chính sách 'Deny log on as a service'"
$rem2_1_19 = ("2.1.19  Cấu hình chính sách 'Deny log on as a service'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Guests
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Deny log on as a service
-----------------------------------------------
Tác động: Nếu gán quyền người dùng 'Deny log on as a service' cho các tài khoản cụ thể, các dịch vụ có thể không khởi động được và có thể dẫn đến tình trạng từ chối dịch vụ (DoS).
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_20 = "2.1.20  Cấu hình chính sách 'Deny log on locally'"
$rem2_1_20 = ("2.1.20  Cấu hình chính sách 'Deny log on locally'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Guests
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Deny log on locally
-----------------------------------------------
Tác động: Nếu gán quyền người dùng 'Deny log on locally' cho các tài khoản bổ sung, có thể giới hạn khả năng của người dùng được gán cho các vai trò cụ thể. 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_21 = "2.1.21  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ MS]"
$rem2_1_21 = ("2.1.21  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Guests, Local account
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Deny log on through Remote Desktop Services
-----------------------------------------------
Tác động: Nếu gắn quyền này cho tài khoản cụ thể, có thể giới hạn khả năng của người dùng được gán cho các vai trò cụ thể. 
")
#  2.1.21 (L1) - Ensure 'Deny log on through Remote Desktop Services' is set to 'Guests, Local account' (MS only)

secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-546'
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#
$var2_1_21DC = "2.1.21[DC]  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ DC]"
$rem2_1_21DC = ("2.1.21[DC]  Cấu hình chính sách 'Deny log on through Remote Desktop  Services' - [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Guests
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Deny log on through Remote Desktop Services
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 
#>

################################################################################################
$var2_1_22 = "2.1.22  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ MS]"
$rem2_1_22 = ("2.1.22  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Enable computer and user accounts to be trusted for delegation
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
<#
$var2_1_22DC = "2.1.22[DC]  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ DC]"
$rem2_1_22DC = ("2.1.22[DC]  Cấu hình chính sách 'Enable computer and user accounts to be trusted for delegation' - [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Enable computer and user accounts to be trusted for delegation
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 
#>

################################################################################################
$var2_1_23 = "2.1.23  Cấu hình chính sách 'Force shutdown from a remote system'"
$rem2_1_23 = ("2.1.23  Cấu hình chính sách 'Force shutdown from a remote system'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Force shutdown from a remote system
-----------------------------------------------
Tác động: Có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_24 = "2.1.24  Cấu hình chính sách 'Generate security audits'"
$rem2_1_24 = ("2.1.24  Cấu hình chính sách 'Generate security audits'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: LOCAL SERVICE, NETWORK SERVICE
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Generate security audits
* Lưu ý:
•	Đối với Member Server giữ vai trò Máy chủ Web (IIS) với dịch vụ Web Server Role là ngoại lệ đối với khuyến nghị này, cho phép các nhóm ứng dụng IIS được tự cấp quyền.
•	Đối với Member Server giữ vai trò Active Directory Federation Services là ngoại lệ đối với khuyến nghị này, cho phép NT SERVICE\ADFSSrv và NT SERVICE\DRSservices, cũng như tài khoản Active Directory Federation Services liên kết sẽ được tự cấp quyền.

-----------------------------------------------
Tác động: Trên hầu hết các máy tính, đây là cấu hình mặc định và sẽ không có tác động tiêu cực. Tuy nhiên, nếu đã cài đặt Web Server (IIS) với Dịch vụ Role Services, cần phải cho phép IIS application pool(s) được cấp quyền người dùng này.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_25 = "2.1.25  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ MS]"
$rem2_1_25 = ("2.1.25  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE IIS_IUSRS (Nếu cài đặt Web Server IIS Role với Web Server Role Service).
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Impersonate a client after authentication
* Lưu ý: Đối với Member Server được cài đặt Microsoft SQL Server và chứa thành phần 'Integration Services' là ngoại lệ đối với khuyến nghị này.
-----------------------------------------------
Tác động: Trong hầu hết các trường hợp, cấu hình này sẽ không có tác động. Nếu đã cài đặt Web Server (IIS) với Dịch vụ Role Services, cần phải gán quyền người dùng này cho IIS_IUSRS.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#
$var2_1_25DC = "2.1.25[DC]  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ DC]"
$rem2_1_25DC = ("2.1.25[DC]  Cấu hình chính sách 'Impersonate a client after authentication' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE.
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Impersonate a client after authentication
* Lưu ý: Đối với Member Server được cài đặt Microsoft SQL Server và chứa thành phần 'Integration Services' là ngoại lệ đối với khuyến nghị này.
-----------------------------------------------
Tác động: 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false
#>

################################################################################################
$var2_1_26 = "2.1.26  Cấu hình chính sách 'Increase scheduling priority'"
$rem2_1_26 = ("2.1.26  Cấu hình chính sách 'Increase scheduling priority'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, Window Manager\Window Manager Group
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Increase scheduling priority
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.1.26 (L1) - Ensure 'Increase scheduling priority' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-90-0'
$output = (Get-content c:\secpol.cfg | select-string 'SeIncreaseBasePriorityPrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_26
	Add-Content -Path $file_remPath -Value $rem2_1_26
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_26
}
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_27 = "2.1.27  Cấu hình chính sách 'Load and unload device drivers'"
$rem2_1_27 = ("2.1.27  Cấu hình chính sách 'Load and unload device drivers'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Load and unload device drivers
-----------------------------------------------
Tác động: Nếu cấu hình có thể giới hạn khả năng của người dùng được gán cho các vai trò quản trị cụ thể.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_28 = "2.1.28  Cấu hình chính sách 'Lock pages in memory'"
$rem2_1_28 = ("2.1.28  Cấu hình chính sách 'Lock pages in memory'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Lock pages in memory
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_29 = "2.1.29  Cấu hình chính sách 'Manage auditing and security log' [Chỉ MS]"
$rem2_1_29 = ("2.1.29  Cấu hình chính sách 'Manage auditing and security log' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Manage auditing and security log
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#	
$var2_1_29DC = "2.1.29[DC]  Cấu hình chính sách 'Manage auditing and security log' [Chỉ DC]"
$rem2_1_29DC = ("2.1.29[DC]  Cấu hình chính sách 'Manage auditing and security log' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Administrators, Exchange Servers (môi trường sử dụng Exchange)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Manage auditing and security log
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false
#>

################################################################################################
$var2_1_30 = "2.1.30  Cấu hình chính sách 'Modify an object label'"
$rem2_1_30 = ("2.1.30  Cấu hình chính sách 'Modify an object label'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Modify an object label
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_31 = "2.1.31  Cấu hình giá trị 'Modify firmware environment values'"
$rem2_1_31 = ("2.1.31  Cấu hình giá trị 'Modify firmware environment values'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Modify firmware environment values
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_32 = "2.1.32  Cấu hình chính sách 'Perform volume maintenance tasks'"
$rem2_1_32 = ("2.1.32  Cấu hình chính sách 'Perform volume maintenance tasks'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Perform volume maintenance task
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_33 = "2.1.33  Cấu hình chính sách 'Profile single process'"
$rem2_1_33 = ("2.1.33  Cấu hình chính sách 'Profile single process'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Profile single process
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_34 = "2.1.34  Cấu hình chính sách 'Profile system performance'"
$rem2_1_34 = ("2.1.34  Cấu hình chính sách 'Profile system performance'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators, NT SERVICE\WdiServiceHost
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Profile system performance
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_35 = "2.1.35  Cấu hình chính sách 'Replace a process level token'"
$rem2_1_35 = ("2.1.35  Cấu hình chính sách 'Replace a process level token'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: LOCAL SERVICE, NETWORK SERVICE
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Replace a process level token
-----------------------------------------------
Tác động: Trên hầu hết các máy tính, đây là cấu hình mặc định và sẽ không có tác động tiêu cực. Tuy nhiên, nếu đã cài đặt Web Server (IIS) với Dịch vụ Role Services, bcần phải cho phép IIS application pool(s) được cấp quyền người dùng này.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_36 = "2.1.36  Cấu hình chính sách 'Restore files and directories'"
$rem2_1_36 = ("2.1.36  Cấu hình chính sách 'Restore files and directories'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: ADMINISTRATORS, BACKUP OPERATORS
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Restore files and directories
* Lưu ý: Giới hạn quyền này đối với nhóm Quản trị viên (Administrators Group). Chỉ định thêm quyền này cho nhóm Backup Operators nếu tổ chức yêu cầu nhóm này cần có
-----------------------------------------------
Tác động: Nếu loại bỏ quyền người dùng 'Restore files and directories' khỏi nhóm Backup Operators và các tài khoản khác, có thể làm cho việc thi hành các nhiệm vụ được ủy quyền trở nên không thể thực hiện được cho người dùng.
")
#  2.1.36 (L1) - Ensure 'Restore files and directories' is set to 'Administrators'
secedit /export /cfg c:\secpol.cfg > $null
$unique = '*S-1-5-32-544,*S-1-5-32-551'
$output = (Get-content c:\secpol.cfg | select-string 'SeRestorePrivilege').ToString().Split('=')[1].Trim()
if ($unique -ne $output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_1_36
	Add-Content -Path $file_remPath -Value $rem2_1_36
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_1_36
}
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_37 = "2.1.37  Cấu hình chính sách 'Shut down the system'"
$rem2_1_37 = ("2.1.37  Cấu hình chính sách 'Shut down the system'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: ADMINISTRATORS, BACKUP OPERATORS
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Shut down the system
* Lưu ý: Giới hạn quyền này đối với nhóm Quản trị viên (Administrators Group). Chỉ định thêm quyền này cho nhóm Backup Operators nếu tổ chức yêu cầu nhóm này cần có
-----------------------------------------------
Tác động: Việc loại bỏ các nhóm mặc định này khỏi quyền người dùng 'Shutdown the system' có thể giới hạn khả năng được ủy quyền của các vai trò được gán trong môi trường của bạn.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_1_38 = "2.1.38  Cấu hình chính sách 'Synchronize directory service data' [Chỉ DC]"
$rem2_1_38 = ("2.1.38  Cấu hình chính sách 'Synchronize directory service data' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: No One
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Synchronize directory service data
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_1_39 = "2.1.39  Cấu hình chính sách 'Take ownership of files or other objects'"
$rem2_1_39 = ("2.1.39  Cấu hình chính sách 'Take ownership of files or other objects'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\User Rights Assignment\Take ownership of files or other objects
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_1_1 = "2.2.1.1  Cấu hình trạng thái tài khoản 'Administrator account status'"
$rem2_2_1_1 = ("2.2.1.1  Cấu hình trạng thái tài khoản 'Administrator account status'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Administrator account status
-----------------------------------------------
Tác động: Có thể xuất hiện vấn đề trong một số trường hợp cụ thể nếu vô hiệu hóa tài khoản Administrator. Nếu mật khẩu Administrator hiện tại không đáp ứng yêu cầu mật khẩu, sẽ không thể kích hoạt lại tài khoản Administrator sau khi nó được vô hiệu hóa. Trong tình huống này, một thành viên khác của nhóm Administrators phải đặt mật khẩu cho tài khoản Administrator bằng công cụ Local Users and Groups.
")
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
$rem2_2_1_2 = ("2.2.1.2  Cấu hình chính sách tài khoản 'Block Microsoft accounts'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Users can't add or log on with Microsoft accounts
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Block Microsoft accounts
-----------------------------------------------
Tác động: Người dùng sẽ không thể đăng nhập vào máy tính bằng tài khoản Microsoft của họ.
")

#  2.2.1.2 (L1) - Ensure 'Accounts: Block Microsoft accounts' is set to 'Users can't add or log on with Microsoft accounts'

$ErrorActionPreference = "stop"
Try {
    Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
    $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_1_3 = ("2.2.1.3  Cấu hình trạng thái tài khoản 'Guest account status' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Guest account status
-----------------------------------------------
Tác động: Nếu vô hiệu hóa tài khoản Guest và tùy chọn Network Access: Sharing and Security Model được đặt là Guest Only, các đăng nhập mạng, như những đăng nhập thực hiện bởi Dịch vụ Mạng Microsoft (SMB Service), sẽ thất bại. 
")
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
$rem2_2_1_4 = ("2.2.1.4  Cấu hình chính sách tài khoản 'Limit local account use of blank passwords to console logon only'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Limit local account use of blank passwords to console logon only
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.1.4 (L1) - Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_1_5 = ("2.2.1.5  Cấu hình thay đổi tên mặc định tài khoản quản trị 'Rename administrator account'
Cấu hình theo đường dẫn sau: thay đổi tên tài khoản quản trị mặc định được tạo ra ban đầu.
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Rename administrator account
-----------------------------------------------
Tác động: Phải thông báo cho người dùng được ủy quyền sử dụng tài khoản về tên tài khoản mới. 
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_2_1_6 = "2.2.1.6  Cấu hình thay đổi tên mặc định tài khoản Guests 'Rename guest account'"
$rem2_2_1_6 = ("2.2.1.6  Cấu hình thay đổi tên mặc định tài khoản Guests 'Rename guest account'
Cấu hình theo đường dẫn sau: thay đổi tên tài khoản Guests mặc định được tạo ra ban đầu.
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Rename guest account
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_2_2 = "2.2.2  Cấu hình kiểm toán"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_2

################################################################################################
$var2_2_2_1 = "2.2.2.1  Cấu hình chính sách 'Audit: Force audit policy subcategory settings to override audit policy category settings'"
$rem2_2_2_1 = ("2.2.2.1  Cấu hình chính sách 'Audit: Force audit policy subcategory settings to override audit policy category settings'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.2.1 (L1) - Ensure 'Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_2_2 = ("2.2.2.2  Cấu hình chính sách 'Audit: Shut down system immediately if unable to log security audits'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Audit: Shut down system immediately if unable to log security audits
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.2.2 (L1) - Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_3_1 = ("2.2.3.1  Cấu hình chính sách 'Devices: Allowed to format and eject removable media'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Administrators
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Devices: Allowed to format and eject removable media
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.3.1 (L1) - Ensure 'Devices: Allowed to format and eject removable media' is set to 'Administrators'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
 $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_3_2 = ("2.2.3.2  Cấu hình chính sách 'Devices: Prevent users from installing printer drivers'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Devices: Prevent users from installing printer drivers
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.3.2 (L1) - Ensure 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Control\Print\Providers\Lanman Print Services\Servers' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
 $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Control\Print\Providers\Lanman Print Services\Servers
-----------------------------------------------
Tác động: 
EOF
)")
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
<#
$var2_2_4 = "2.2.4  Domain Controller [Mục này chỉ dành cho DC]"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_4

################################################################################################
$var2_2_4_1 = "2.2.4.1  Cấu hình chính sách 'Domain controller: Allow server operators to schedule tasks' is set to 'Disabled'"
$rem2_2_4_1 = ("2.2.4.1  Cấu hình chính sách 'Domain controller: Allow server operators to schedule tasks' is set to 'Disabled'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain controller: Allow server operators to schedule tasks
-----------------------------------------------
Tác động: 
")
#  2.2.4.1 (L1) - Ensure 'Domain controller: Allow server operators to schedule tasks' is set to 'Disabled' (DC only)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_4_2 = ("2.2.4.2  Cấu hình chính sách 'Domain controller: Refuse machine account password changes
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain controller: Refuse machine account password changes
-----------------------------------------------
Tác động: 
")
#  2.2.4.2 (L1) - Ensure 'Domain controller: Refuse machine account password changes' is set to 'Disabled' (DC only)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
#>

################################################################################################
$var2_2_5 = "2.2.5  Domain Member"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_5

################################################################################################
$var2_2_5_1 = "2.2.5.1  Cấu hình chính sách 'Domain member: Digitally encrypt or sign secure channel data (always)'"
$rem2_2_5_1 = ("2.2.5.1  Cấu hình chính sách 'Domain member: Digitally encrypt or sign secure channel data (always)'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain member: Digitally encrypt or sign secure channel data (always)
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false 

################################################################################################
$var2_2_5_2 = "2.2.5.2  Cấu hình chính sách 'Domain member: Digitally encrypt secure channel data (when possible)'"
$rem2_2_5_2 = ("2.2.5.2  Cấu hình chính sách 'Domain member: Digitally encrypt secure channel data (when possible)'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain member: Digitally encrypt secure channel data (when possible)
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.5.2 (L1) - Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_5_3 = ("2.2.5.3  Cấu hình chính sách 'Domain member: Digitally sign secure channel data (when possible)'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain member: Digitally sign secure channel data (when possible)
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.5.3 (L1) - Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_5_4 = ("2.2.5.4  Cấu hình chính sách 'Domain member: Disable machine account password changes'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain member: Disable machine account password changes
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.5.4 (L1) - Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_5_5 = ("2.2.5.5  Cấu hình chính sách 'Domain member: Maximum machine account password age'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: <= 30 (khác 0)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain member: Maximum machine account password age
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.5.5 (L1) - Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_5_6 = ("2.2.5.6  Cấu hình chính sách 'Domain member: Require strong (Windows 2000 or later) session key
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Domain member: Require strong (Windows 2000 or later) session key
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.5.6 (L1) - Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_6_1 = ("2.2.6.1  Thiết lập 'Interactive logon: Do not display last user name'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Interactive logon: Don't display last signed-in
-----------------------------------------------
Tác động: Tên của người dùng cuối cùng đăng nhập thành công sẽ không được hiển thị trên màn hình đăng nhập Windows.
")
#  2.2.6.1 (L1) - Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_6_2 = ("2.2.6.2  Thiết lập ' CTRL+ALT+DEL'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Interactive logon: Do not require CTRL+ALT+DEL
-----------------------------------------------
Tác động: Người dùng phải nhấn CTRL+ALT+DEL trước khi đăng nhập vào Windows.
")
#  2.2.6.2 (L1) - Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_6_3 = ("2.2.6.3  Thiết lập 'Interactive logon: Machine inactivity limit'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: <= 900 (s) (khác 0)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Interactive logon: Machine inactivity limit
-----------------------------------------------
Tác động: Màn hình chờ sẽ tự động kích hoạt khi máy tính không được sử dụng trong khoảng thời gian được chỉ định.
")
#  2.2.6.3 (L1) - Ensure 'Interactive logon: Machine inactivity limit' is set to '900 or fewer second(s), but not 0'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_6_4 = ("2.2.6.4  Cấu hình 'Interactive logon: Message text for users attempting to log on'
Cấu hình tham số theo đường dẫn sau với nội dung đề xuất: Tạo ra nội dung thông báo cho người dùng (tuân theo các chính sách ATTT được ban hành của tổ chức) nhằm cảnh báo về các hành vi lạm dụng thông tin không được cho phép khi đăng nhập vào hệ thống.
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Interactive logon: Message text for users attempting to log on
-----------------------------------------------
Tác động: Người dùng sẽ phải xác nhận một hộp thoại chứa văn bản đã được cấu hình trước khi họ có thể đăng nhập vào máy tính.
")
#  2.2.6.4 (L1) - Configure 'Interactive logon: Message text for users attempting to log on'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_6_5 = ("2.2.6.5  Thiết lập 'Interactive logon: Message title for users attempting to log on'
Cấu hình tham số theo đường dẫn sau với nội dung đề xuất: Tạo ra tiêu đề thông báo cho người dùng (tuân theo các chính sách ATTT được ban hành của tổ chức) nhằm cảnh báo về các hành vi lạm dụng thông tin không được cho phép khi đăng nhập vào hệ thống.
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Interactive logon: Message title for users attempting to log on
-----------------------------------------------
Tác động: Người dùng sẽ phải xác nhận một hộp thoại chứa văn bản đã được cấu hình trước khi họ có thể đăng nhập vào máy tính.
")
#  2.2.6.5 (L1) - Configure 'Interactive logon: Message title for users attempting to log on'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_6_6 = ("2.2.6.6  Thiết lập 'Interactive logon: Prompt user to change password before expiration'
Cấu hình tham số theo đường dẫn sau với đề xuất: Thiết lập thông báo mật khẩu sắp hết hạn cho người dùng: từ 5-14 (ngày)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Interactive logon: Prompt user to change password before expiration
-----------------------------------------------
Tác động: Người dùng sẽ thấy một hộp thoại yêu cầu thay đổi mật khẩu mỗi lần họ đăng nhập vào domain khi mật khẩu của họ được cấu hình hết hạn trong n ngày.
")
#  2.2.6.6 (L1) - Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_7_1 = ("2.2.7.1  Thiết lập 'Microsoft network client: Digitally sign communications (if server agrees)'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network client: Digitally sign communications (if server agrees)
-----------------------------------------------
Tác động: Máy khách mạng Microsoft sẽ không giao tiếp với một máy chủ mạng Microsoft trừ khi máy chủ đó đồng ý thực hiện chữ ký gói SMB.
")
#  2.2.7.1 (L1) - Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is already set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" 2> $null | select-string 'EnableSecuritySignature' 2> $null |  Measure-Object | % { $_.Count })

	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" | select-string 'EnableSecuritySignature' | Foreach { "$(($_ -split '\s+',4)[3])" } ) ) {
			if ( ( $unique1 -eq '0x1' ) ) {
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
$rem2_2_7_2 = ("2.2.7.2  Thiết lập 'Microsoft network client: Send unencrypted password to third-party SMB servers'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network client: Send unencrypted password to third-party SMB servers
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.7.2 (L1) - Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" 2> $null | select-string 'EnablePlainTextPassword' 2> $null |  Measure-Object | % { $_.Count })
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" | select-string 'EnablePlainTextPassword').ToString().Split('')[12].Trim() ) {
			if ( [int]$unique1 -eq [int]'0x0' ) {
				Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_7_2
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
$rem2_2_7_3 = ("2.2.7.3.  Thiết lập 'Microsoft network client: Digitally sign communications (if server always)'Cấu hình tham số theo đường dẫn với trạng thái đề xuất: Enable
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network client: Digitally sign communications (always)
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#   2.2.7.3 (L1) Ensure 'Microsoft network client: Digitally sign communications (if server always)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
   $path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
   $unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" 2> $null | select-string 'RequireSecuritySignature' 2> $null |  Measure-Object | %{$_.Count})

if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" | select-string 'RequireSecuritySignature'| Foreach {"$(($_ -split '\s+',4)[3])"} ) ) {
	if ( ( $unique1 -eq '0x1' ) ) {
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
$rem2_2_8_1 = ("2.2.8.1  Thiết lập 'Microsoft network server: Amount of idle time required before suspending session'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: <= 15 (phút)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network server: Amount of idle time required before suspending session
-----------------------------------------------
Tác động: Sẽ có ít tác động vì các phiên SMB sẽ được tái thiết lập tự động nếu máy khách tiếp tục hoạt động.
")
#  2.2.8.1 (L1) - Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\System\Currentcontrolset\Services\Lanmanserver\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\System\Currentcontrolset\Services\Lanmanserver\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_8_2 = ("2.2.8.2  Thiết lập 'Microsoft network server: Disconnect clients when logon hours expire'Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network server: Disconnect clients when logon hours expire
-----------------------------------------------
Tác động: Máy chủ mạng Microsoft sẽ kết nối được với máy khách mạng Microsoft trừ khi máy khách đó đồng ý thực hiện SMB packet signing.
")

#  2.2.8.2 (L1) - Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_8_3 = ("2.2.8.3  Thiết lập ' Microsoft network server: Digitally sign communications (always)
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network server: Digitally sign communications (always)
-----------------------------------------------
Tác động: Máy chủ mạng Microsoft sẽ thương lượng SMB packet signing theo yêu cầu của máy khách. Điều này có nghĩa là nếu SMB packet signing đã được kích hoạt trên máy khách, thì sẽ thực hiện thương lượng SMB packet signing.
")

#   2.2.8.3 (L1) - Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_8_4 = ("2.2.8.4  Thiết lập 'Microsoft network server: Digitally sign communications (if client agrees)'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network server: Digitally sign communications (if client agrees)
-----------------------------------------------
Tác động:  Máy chủ mạng Microsoft sẽ kết nối được với máy khách mạng Microsoft trừ khi máy khách đó đồng ý thực hiện SMB packet signing.
")

#   2.2.8.4 (L1) - Ensure 'Microsoft network server: Digitally sign communications (if client agrees)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" 2> $null | select-string 'EnableSecuritySignature' 2> $null |  Measure-Object | %{$_.Count})
if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
	foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" | select-string 'EnableSecuritySignature').ToString().Split('')[12].Trim() ) {
		if ( [int]$unique1 -eq [int]'0x1' ) {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_8_4
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
$rem2_2_8_5 = ("2.2.8.5  Thiết lập 'Microsoft network server: Server SPN target name validation level' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Accept if provided by client
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Microsoft network server: Server SPN target name validation level
-----------------------------------------------
Tác động: Tất cả các hệ điều hành Windows đều hỗ trợ cả thành phần SMB phía máy khách và thành phần SMB phía máy chủ. Cài đặt này ảnh hưởng đến hành vi máy chủ SMB, và việc triển khai nên được đánh giá và kiểm thử cẩn thận để tránh gây rối trong khả năng phục vụ tệp và in.
")

#   2.2.8.5 (L1) - Ensure 'Microsoft network server: Server SPN target name validation level' is set to 'Accept if provided by client' or higher (MS only) (Scored)

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
Catch [System.Management.Automation.ItemNotFoundException] {
    Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_8_5
	Add-Content -Path $file_remPath -Value $rem2_2_8_5
}
Finally { $ErrorActionPreference = "Continue" }
################################################################################################
$var2_2_9 = "2.2.9  Thiết lập Network access"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var2_2_9

################################################################################################
$var2_2_9_1 = "2.2.9.1  Thiết lập 'Network access: Allow anonymous SID/Name translation'"
$rem2_2_9_1 = ("2.2.9.1  Thiết lập 'Network access: Allow anonymous SID/Name translation'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Allow anonymous SID/Name translation
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_2 = "2.2.9.2  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts' [Chỉ MS]"
$rem2_2_9_2 = ("2.2.9.2  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Do not allow anonymous enumeration of SAM accounts
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  2.2.9.2 (L1) - Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled' (MS only)

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_9_3 = ("2.2.9.3  Thiết lập 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Do not allow anonymous enumeration of SAM accounts and shares
* Lưu ý: Người dùng truy cập vào các máy chủ tệp và máy in dưới dạng ẩn danh sẽ không thể xem được các tài nguyên được chia sẻ trên các máy chủ đó; người dùng sẽ phải xác thực trước khi có thể xem danh sách các thư mục và máy in được chia sẻ.
-----------------------------------------------
Tác động: Không thể thiết lập mối quan hệ tin cậy với các miền dựa trên Windows NT 4.0. Ngoài ra, các máy tính khách chạy các phiên bản cũ của hệ điều hành Windows như Windows NT 3.51 và Windows 95 sẽ gặp vấn đề khi cố gắng sử dụng tài nguyên trên máy chủ.
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_4 = "2.2.9.4  Thiết lập 'Network access: Let Everyone permissions apply to anonymous users'"
$rem2_2_9_4 = ("2.2.9.4  Thiết lập 'Network access: Let Everyone permissions apply to anonymous users'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Let Everyone permissions apply to anonymous users
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  2.2.9.4 (L1) - Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_9_5 = ("2.2.9.5  Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: <blank> [i.e None], BROWSER (nếu Computer Browser service được bật).
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Named Pipes that can be accessed anonymously
* Lưu ý: Đối với Member Server giữ vai trò Remote Desktop Services với dịch vụ Remote Desktop Licensing Role là ngoại lệ đối với khuyến nghị này; cho phép sử dụng Named Pipes là HydraLSPipe và TermServLicensing.
-----------------------------------------------
Tác động: Truy cập null session qua named pipes sẽ bị vô hiệu hóa trừ khi chúng được bao gồm, và các ứng dụng phụ thuộc vào tính năng này hoặc truy cập không xác thực vào named pipes sẽ không hoạt động nữa. Named pipe BROWSER có thể cần được thêm vào danh sách này nếu dịch vụ Computer Browser cần thiết để hỗ trợ các thành phần cũ. Dịch vụ Computer Browser được tắt mặc định.
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
<#
$var2_2_9_5DC = "2.2.9.5[DC] Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ DC]"
$rem2_2_9_5DC = ("2.2.9.5[DC] Cấu hình 'Network access: Named Pipes that can be accessed anonymously' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: LSARPC, NETLOGON, SAMR, BROWSER (nếu Computer Browser service được bật).
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Named Pipes that can be accessed anonymously
* Lưu ý: Đối với Member Server giữ vai trò Remote Desktop Services với dịch vụ Remote Desktop Licensing Role là ngoại lệ đối với khuyến nghị này; cho phép sử dụng Named Pipes là HydraLSPipe và TermServLicensing.
-----------------------------------------------
Tác động: 
")

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
else {
    if ($unique -ne $output) {
        Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var2_2_9_5DC
		Add-Content -Path $file_remPath -Value $rem2_2_9_5DC
    }
    else {
        Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var2_2_9_5DC
    }
}
Remove-Item -force c:\secpol.cfg -confirm:$false
#>

################################################################################################
$var2_2_9_6 = "2.2.9.6  Cấu hình 'Network access: Remotely accessible registry paths'"
$rem2_2_9_6 = ("2.2.9.6  Cấu hình 'Network access: Remotely accessible registry paths'Cấu hình tham số theo đường dẫn sau với khuyến nghị: Software\Microsoft\Windows NT\CurrentVersion
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Remotely accessible registry paths
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_7 = "2.2.9.7  Cấu hình 'Network access: Remotely accessible registry paths and sub-paths'"
$rem2_2_9_7 = ("2.2.9.7  Cấu hình 'Network access: Remotely accessible registry paths and sub-paths'
Cấu hình tham số theo đường dẫn sau với khuyến nghị:
•	System\CurrentControlSet\Control\Print\Printers
•	System\CurrentControlSet\Services\Eventlog
•	Software\Microsoft\OLAP Server
•	Software\Microsoft\Windows NT\CurrentVersion\Print
•	Software\Microsoft\Windows NT\CurrentVersion\Windows
•	System\CurrentControlSet\Control\ContentIndex
•	System\CurrentControlSet\Control\Terminal Server
•	System\CurrentControlSet\Control\Terminal Server\UserConfig
•	System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration
•	Software\Microsoft\Windows NT\CurrentVersion\Perflib
•	System\CurrentControlSet\Services\SysmonLog
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Remotely accessible registry paths and sub-paths
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_9_8 = "2.2.9.8  Cấu hình 'Network access: Restrict anonymous access to Named Pipes and Shares'"
$rem2_2_9_8 = ("2.2.9.8  Cấu hình 'Network access: Restrict anonymous access to Named Pipes and Shares'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Restrict anonymous access to Named Pipes and Shares
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  2.2.9.8 (L1) - Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_9_9 = ("2.2.9.9  Cấu hình 'Network access: Shares that can be accessed anonymously'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: <blank> (i.e. None)
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Shares that can be accessed anonymously
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  2.2.9.9 (L1) - Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_9_10 = ("2.2.9.10  Cấu hình 'Network access: Sharing and security model for local accounts'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Classic - local users authenticate as themselves
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network access: Sharing and security model for local accounts
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  2.2.9.10 (L1) - Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_1 = ("2.2.10.1  Thiết lập 'Network security: Allow LocalSystem NULL session fallback'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Allow LocalSystem NULL session fallback
-----------------------------------------------
Tác động: Bất kỳ ứng dụng yêu cầu phiên NULL cho LocalSystem sẽ không hoạt động.
")
#  2.2.10.1 (L1) - Ensure 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_2 = ("2.2.10.2  Thiết lập 'Network Security: Allow PKU2U authentication requests to this computer to use online identities'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network Security: Allow PKU2U authentication requests to this computer to use online identities
* Lưu ý: Bất kỳ ứng dụng nào yêu cầu NULL session cho LocalSystem sẽ không hoạt động.
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.10.2 (L1) - Ensure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\pku2u -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\pku2u
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_3 = ("2.2.10.3  Thiết lập 'Network security: Configure encryption types allowed for Kerberos'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Configure encryption types allowed for Kerberos
-----------------------------------------------
Tác động: Nếu không chọn, loại mã hóa sẽ không được chấp nhận. Thiết lập này có thể ảnh hưởng đến sự tương thích với máy tính hoặc dịch vụ và ứng dụng khác nhau.
")
#  2.2.10.3 (L1) - Ensure 'Network security: Configure encryption types allowed for Kerberos' is set to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_4 = ("2.2.10.4  Thiết lập 'Network security: Do not store LAN Manager hash value on next password change'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Do not store LAN Manager hash value on next password change
* Lưu ý: Những hệ điều hành cũ hơn và một số ứng dụng của bên thứ ba có thể bị lỗi khi bật thiết lập này. Ngoài ra, lưu ý rằng mật khẩu sẽ cần được thay đổi trên tất cả các tài khoản sau khi thiết lập được bật.
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.10.4 (L1) - Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
	Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_5 = ("2.2.10.5  Thiết lập 'Network security: Force logoff when logon hours expire'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Force logoff when logon hours expire
* Lưu ý: Nếu bật chính sách này thì nên bật thêm chính sách 'Microsoft network server: Disconnect clients when logon hours expire'
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
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
Remove-Item -force c:\secpol.cfg -confirm:$false

################################################################################################
$var2_2_10_6 = "2.2.10.6  Thiết lập 'Network security: Allow Local System to use computer identity for NTLM'"
$rem2_2_10_6 = ("2.2.10.6  Thiết lập 'Network security: Allow Local System to use computer identity for NTLM'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Allow Local System to use computer identity for NTLM
-----------------------------------------------
Tác động: Các dịch vụ chạy dưới tên Local System sử dụng Negotiate khi chuyển về xác thực NTLM sẽ sử dụng danh tính máy tính. Điều này có thể gây một số yêu cầu xác thực giữa các hệ điều hành Windows thất bại và tạo một bản ghi lỗi.
")
#   2.2.10.6 (L1) - Ensure 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled' (Scored)
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_7 = ("2.2.10.7  Thiết lập 'Network security: LAN Manager authentication level'
Thiết lập này xác định giao thức xác thực challenge/response nào được sử dụng để đăng nhập mạng. Lựa chọn này ảnh hưởng đến mức độ giao thức xác thực được sử dụng bởi client, mức độ bảo mật phiên được và mức độ xác thực được chấp nhận bởi máy chủ
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Send NTLMv2 response only. Refuse LM & NTLM
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: LAN Manager authentication level
-----------------------------------------------
Tác động: Các máy khách chỉ sử dụng xác thực NTLMv2 và sử dụng bảo mật phiên NTLMv2 nếu máy chủ hỗ trợ; Bộ kiểm soát miền từ chối LM và NTLM (chấp nhận chỉ xác thực NTLMv2). Các máy khách không hỗ trợ xác thực NTLMv2 sẽ không thể xác thực trong miền và truy cập tài nguyên miền bằng cách sử dụng LM và NTLM.
")

#   2.2.10.7 (L1) - Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_8 = ("2.2.10.8  Thiết lập 'Network security: LDAP client signing requirements'
Làm cho tất cả các loại tấn công MITM trở nên cực kỳ khó khăn nếu yêu cầu chữ ký số trên tất cả các gói mạng IPsec authentication headers.
Cấu hình tham số theo đường dẫn sau với trạng thái: Negotiate signing
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: LDAP client signing requirements
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#   2.2.10.8 (L1) - Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LDAP -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LDAP
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_9 = ("2.2.10.9  Thiết lập 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients'
Cấu hình tham số theo đường dẫn sau với trạng thái: Require NTLMv2 session security, require 128-bit encryption
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Minimum session security for NTLM SSP based (including secure RPC) clients
-----------------------------------------------
Tác động: Ứng dụng khách đang áp dụng những thiết lập này sẽ không thể kết nối với các máy chủ cũ không hỗ trợ chúng.
")
#   2.2.10.9 (L1) - Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_10_10 = ("2.2.10.10  Thiết lập 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers'
Bảo vệ khỏi các cuộc tấn công MITM
Cấu hình với giá trị khuyến nghị: NTLMv2 session security, require 128-bit encryption
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Network security: Minimum session security for NTLM SSP based (including secure RPC) servers
-----------------------------------------------
Tác động: Ứng dụng khách đang áp dụng những thiết lập này sẽ không thể kết nối với các máy chủ cũ không hỗ trợ chúng.
")
#   2.2.11.10 (L1) - Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers' is set to 'Require NTLMv2 session security, Require 128-bit encryption' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_11_1 = ("2.2.11.1  Thiết lập cơ chế 'Shutdown: Allow system to be shut down  without having to log on'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Disabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\Shutdown: Allow system to be shut down without having to log on
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.11.1 (L1) - Ensure 'Shutdown: Allow system to be shut down without having to log on' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_12_1 = ("2.2.12.1  Cấu hình chính sách 'System objects: Require case insensitivity for non-Windows subsystems'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\System objects: Require case insensitivity for nonWindows subsystems
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  2.2.12.1 (L1) - Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_12_2 = ("2.2.12.2  Cấu hình chính sách 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#   2.2.12.2. Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_1 = ("2.2.13.1  Thiết lập 'User Account Control: Admin Approval Mode for the Built-in Administrator account'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Admin Approval Mode for the Built-in Administrator account
-----------------------------------------------
Tác động: Tài khoản Administrator tích hợp sử dụng Chế độ Phê duyệt Quản trị. Người dùng đăng nhập bằng tài khoản Administrator cục bộ sẽ được yêu cầu cho sự đồng thuận mỗi khi một chương trình yêu cầu tăng quyền, giống như bất kỳ người dùng nào khác.
")
#   2.2.13.1.Ensure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is set to 'Enabled' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_2 = ("2.2.13.2  Thiết lập 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Prompt for consent on the secure desktop
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode
-----------------------------------------------
Tác động: Khi một hoạt động (bao gồm việc thực thi một tệp tin Windows) yêu cầu tăng quyền, người dùng sẽ được yêu cầu trên màn hình máy tính an toàn để chọn Cho phép hoặc Từ chối. Nếu người dùng chọn Cho phép, hoạt động tiếp tục với đặc quyền cao nhất mà người dùng có.
")
#  2.2.13.2 (L1) - Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_3 = ("2.2.13.3  Thiết lập 'User Account Control: Detect application installations and prompt for elevation'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Detect application installations and prompt for elevation
-----------------------------------------------
Tác động: Khi một gói cài đặt ứng dụng được phát hiện đòi hỏi tăng quyền, người dùng sẽ được yêu cầu nhập tên người dùng và mật khẩu quản trị viên.
")
#  2.2.13.3 (L1) - Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_4 = ("2.2.13.4  Thiết lập 'User Account Control: Only elevate UIAccess applications that are installed in secure locations'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Only elevate UIAccess applications that are installed in secure locations
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.13.4 (L1) - Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_5 = ("2.2.13.5  Thiết lập 'User Account Control: Run all administrators in Admin Approval Mode'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Run all administrators in Admin Approval Mode
* Lưu ý: Nếu thay đổi cài đặt này thì phải khởi động lại máy tính
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.13.5 (L1) - Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_6 = ("2.2.13.6  Thiết lập 'User Account Control: Switch to the secure desktop when prompting for elevation'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Switch to the secure desktop when prompting for elevation
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.13.6 (L1) - Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_7 = ("2.2.13.7  Thiết lập 'User Account Control: Virtualize file and registry write failures to per-user locations
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Enabled
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Virtualize file and registry write failures to per-user locations
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  2.2.13.7 (L1) - Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem2_2_13_8 = ("2.2.13.8  Thiết lập 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'
Cài đặt này nâng cao nhận thức cho người dùng rằng chương trình yêu cầu sử dụng các hoạt động đặc quyền nâng cao và yêu cầu người dùng có thể cung cấp thông tin đăng nhập quản trị để thực hiện thao tác chạy chương trình.
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Automatically deny elevation requests
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control: Behavior of the elevation prompt for standard users
-----------------------------------------------
Tác động: Khi một hoạt động yêu cầu đặc quyền, thông báo lỗi truy cập bị từ chối được cấu hình hiển thị. Doanh nghiệp đang chạy máy tính để bàn với đặc quyền người dùng tiêu chuẩn có thể chọn cài đặt này để giảm số lượng cuộc gọi hỗ trợ.
")
#   2.2.13.8 (L1) - Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_1_1 = ("3.1.1  Thiết lập trạng thái 'Windows Firewall: Domain: Firewall state'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: On
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Firewall state
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  3.1.1 (L1) - Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_1_2 = ("3.1.2  Thiết lập trạng thái 'Windows Firewall: Domain: Inbound connections'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Block
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Inbound connections
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  3.1.2 (L1) - Ensure 'Windows Firewall: Domain: Inbound connections' is set to 'Block (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_1_3 = ("3.1.3  Thiết lập trạng thái 'Windows Firewall: Domain: Outbound connections'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Allow
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Outbound connections
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
$rem3_1_4 = ("3.1.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Domain: Logging: Name'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: %SystemRoot%\System32\logfiles\firewall\domainfw.log
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Logging Customize\Name
-----------------------------------------------
Tác động: Windows Firewall sẽ không hiển thị thông báo khi một chương trình bị chặn khỏi việc nhận kết nối đến từ bên ngoài.
")

#  3.1.4 (L1) - Ensure 'Windows Firewall: Domain: Logging: Name' is set to '%SYSTEMROOT%\System32\logfiles\firewall\domainfw.log'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_1_5 = ("3.1.5  Cấu hình kích thước giới hạn 'Windows Firewall: Domain: Logging: Size limit (KB)'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: >= 16,384 KB
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Logging Customize\Size limit (KB)
* Lưu ý: Tệp nhật ký sẽ bị giới hạn ở kích thước được chỉ định, các sự kiện cũ sẽ bị ghi đè bởi các sự kiện mới hơn khi đạt đến giới hạn
-----------------------------------------------
Tác động: Kích thước tệp nhật ký sẽ bị giới hạn đến kích thước được chỉ định, các sự kiện cũ sẽ bị ghi đè bởi các sự kiện mới khi đạt đến giới hạn.
")

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
$rem3_1_6 = ("3.1.6  Thiết lập chính sách 'Windows Firewall: Domain: Logging: Log dropped packets'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: Yes
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Logging Customize\Log dropped packets
-----------------------------------------------
Tác động: Thông tin về các gói tin bị từ chối sẽ được ghi lại trong tệp nhật ký tường lửa.
")

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
$rem3_1_7 = ("3.1.7  Thiết lập chính sách 'Windows Firewall: Domain: Logging: Log successful connections'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: Yes
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Logging Customize\Log successful connections
-----------------------------------------------
Tác động: Thông tin về các kết nối thành công sẽ được ghi lại trong tệp nhật ký tường lửa.
")

#  3.1.7 (L1) - Ensure 'Windows Firewall: Domain: Logging: Log successful connections' is set to 'Yes'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_1_8 = ("3.1.8  Thiết lập chính sách 'Windows Firewall: Domain: Settings: Display a notification'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: No
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Domain Profile\Settings Customize\Display a notification
-----------------------------------------------
Tác động: Tường lửa Windows sẽ không hiển thị thông báo khi một chương trình bị chặn từ việc nhận kết nối đến.
")

#  	3.1.8 (L1) - Ensure 'Windows Firewall: Domain: Settings: Display a notification' is set to 'No' 
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile
-----------------------------------------------
Tác động: 
EOF
)")
	$unique = (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" 2> $null | select-string 'DisableNotifications' 2> $null |  Measure-Object | %{$_.Count})
	if (( $path -eq 'True' ) -And ( $unique -eq '1' )) {
		foreach ( $unique1 in (REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" | select-string 'DisableNotifications').ToString().Split('')[12].Trim() ) {
		if ( [int]$unique1 -eq [int]'0x1' ) {
			Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var3_1_8
		} else {
			Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_8
			Add-Content -Path $file_remPath -Value $rem3_1_8
			}
		}
	}else {
		Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_8
		Add-Content -Path $file_remPath -Value $rem3_1_8
	}
}
Catch [System.Management.Automation.ItemNotFoundException]
{
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var3_1_8
	Add-Content -Path $file_remPath -Value $rem3_1_8
}
Finally { $ErrorActionPreference = "Continue" }

################################################################################################
$var3_2 = "3.2  Private Profile"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var3_2

################################################################################################
$var3_2_1 = "3.2.1  Thiết lập trạng thái 'Windows Firewall: Private: Firewall state'"
$rem3_2_1 = ("3.2.1  Thiết lập trạng thái 'Windows Firewall: Private: Firewall state'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: On
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Firewall state
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
$rem3_2_2 = ("3.2.2  Thiết lập trạng thái 'Windows Firewall: Private: Inbound connections'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Block
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Inbound connections
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
$rem3_2_3 = ("3.2.3  Thiết lập trạng thái 'Windows Firewall: Private: Outbound connections'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Allow
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Outbound connections
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
$rem3_2_4 = ("3.2.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Private: Logging: Name'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: %SystemRoot%\System32\logfiles\firewall\privatefw.log
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Logging Customize\Name
-----------------------------------------------
Tác động: File nhật ký sẽ được lưu trữ trong tệp đã chỉ định.
")

#  3.2.4 (L1) - Ensure 'Windows Firewall: Private: Logging: Name' is set to '%SYSTEMROOT%\System32\logfiles\firewall\Privatefw.log'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_2_5 = ("3.2.5  Cấu hình kích thước giới hạn 'Windows Firewall: Private: Logging: Size limit (KB)'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: >= 16,384 KB
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Logging Customize\Size limit (KB)
-----------------------------------------------
Tác động: Kích thước tệp nhật ký sẽ bị giới hạn đến kích thước được chỉ định, các sự kiện cũ sẽ bị ghi đè bởi những sự kiện mới khi đạt đến giới hạn.
")

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
$rem3_2_6 = ("3.2.6  Thiết lập chính sách 'Windows Firewall: Private: Logging: Log dropped packets'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: Yes
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Logging Customize\Log dropped packets
-----------------------------------------------
Tác động: Thông tin về các gói tin bị từ chối sẽ được ghi lại trong tệp nhật ký tường lửa.
")

#  3.2.6 (L1) - Ensure 'Windows Firewall: Private: Logging: Log dropped packets' is set to 'Yes'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_2_7 = ("3.2.7  Thiết lập chính sách 'Windows Firewall: Private: Logging: Log successful connections
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: Yes
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Logging Customize\Log successful connections
-----------------------------------------------
Tác động: Thông tin về các kết nối thành công sẽ được ghi lại trong tệp nhật ký tường lửa.
")

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
$rem3_2_8 = ("3.2.8  Thiết lập trạng thái 'Windows Firewall: Private: Settings: Display a notification'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: No
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Private Profile\Settings Customize\Display a notification
-----------------------------------------------
Tác động: Tường lửa Windows sẽ không hiển thị thông báo khi một chương trình bị chặn từ việc nhận kết nối đến.
")
#  	3.2.8 (L1) - Ensure 'Windows Firewall: Private: Settings: Display a notification' is set to 'No' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_3_1 = ("3.3.1  Thiết lập trạng thái 'Windows Firewall: Public: Firewall state'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: On
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Public Profile\Firewall state
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  3.3.1 (L1) - Ensure 'Windows Firewall: Public: Firewall state' is set to 'On (recommended)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_3_2 = ("3.3.2  Thiết lập trạng thái 'Windows Firewall: Public: Inbound connections'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Block
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Public Profile\Inbound connections
* Lưu ý: Đảm bảo chỉ mở các kết nối cần thiết, không mở theo dải IP
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  3.3.2 (L1) - Ensure 'Windows Firewall: Public: Inbound connections' is set to 'Block (default)'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_3_3 = ("3.3.3  Thiết lập trạng thái 'Windows Firewall: Public: Outbound connections'
Cấu hình tham số theo đường dẫn sau với trạng thái đề xuất: Allow
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Public Profile\Outbound connections
* Lưu ý: Đảm bảo chỉ mở các kết nối cần thiết, không mở theo dải IP
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

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
$rem3_3_4 = ("3.3.4  Cấu hình vị trí lưu trữ nhật ký 'Windows Firewall: Public: Logging: Name'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: %SystemRoot%\System32\logfiles\firewall\publicfw.log
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Public Profile\Logging Customize\Name\
-----------------------------------------------
Tác động: Log sẽ được ghi vào một tệp cụ thể
")

#  3.3.4 (L1) - Ensure 'Windows Firewall: Public: Logging: Name' is set to '%SYSTEMROOT%\System32\logfiles\firewall\Publicfw.log'

$sid = (whoami /user | select-string 'S-').ToString().Split('')[1].Trim()
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_3_5 = ("3.3.5  Cấu hình kích thước giới hạn 'Windows Firewall: Public: Logging: Size limit (KB)'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: >= 16,384 KB
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\PublicProfile\Logging Customize\Size limit (KB)
* Lưu ý: Tệp nhật ký sẽ bị giới hạn ở kích thước được chỉ định, các sự kiện cũ sẽ bị ghi đè bởi các sự kiện mới hơn khi đạt đến giới hạn.
-----------------------------------------------
Tác động: Kích thước tệp nhật ký sẽ bị giới hạn đến kích thước được chỉ định, các sự kiện cũ sẽ bị ghi đè bởi những sự kiện mới khi đạt đến giới hạn.
")

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
$rem3_3_6 = ("3.3.6  Thiết lập chính sách 'Windows Firewall: Public: Logging: Log dropped packets'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: Yes
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Public Profile\Logging Customize\Log dropped packets
-----------------------------------------------
Tác động: Thông tin về các gói tin bị từ chối sẽ được ghi lại trong tệp nhật ký tường lửa
")

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
$rem3_3_7 = ("3.3.7  Thiết lập chính sách 'Windows Firewall: Public: Logging: Log successful connections
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: Yes
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\PublicProfile\Logging Customize\Log successful connections
-----------------------------------------------
Tác động: Thông tin về các kết nối thành công sẽ được ghi lại trong tệp nhật ký tường lửa
")

#  3.3.7 (L1) - Ensure 'Windows Firewall: Public: Logging: Log successful connections' is set to 'Yes'

$sid = (whoami /user | select-string 'S-').ToString().Split('')[1].Trim()
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem3_3_8 = ("3.3.8  Thiết lập trạng thái 'Windows Firewall: Public: Settings: Display a notification'
Cấu hình tham số theo đường dẫn sau với thiết lập đề xuất: No
Computer Configuration\Policies\Windows Settings\Security Settings\Windows Firewall with Advanced Security\Windows Firewall with Advanced Security\Windows Firewall Properties\Public Profile\Settings Customize\Display a notification
-----------------------------------------------
Tác động: Tường lửa Windows sẽ không hiển thị thông báo khi một chương trình bị chặn từ việc nhận kết nối đến.
")
#  	3.3.8 (L1) - Ensure 'Windows Firewall: Public: Settings: Display a notification' is set to 'No' (Scored)

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem4_1_1 = ("4.1.1  Cấu hình chính sách 'Audit Credential Validation'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Logon\Audit Credential Validation
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa. 
")

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
$rem4_1_2 = ("4.1.2  Cấu hình chính sách 'Audit Kerberos Authentication Service' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Logon\Audit Kerberos Authentication Service
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")
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
$rem4_1_3 = ("4.1.3  Cấu hình chính sách 'Audit Kerberos Service Ticket Operations' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Logon\Audit Kerberos Service Ticket Operations
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_2_1 = ("4.2.1  Cấu hình chính sách 'Audit Application Group Management'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Management\Audit Application Group Management
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")
#  4.2.1 (L1) - Ensure 'Audit Application Group Management' is set to 'Success and Failure'

$unique = (auditpol.exe /get /category:*   | select-string "Application Group Management" | ForEach-Object { "$(($_ -split '\s+',5)[4])" })
$output = "Success and Failure"
if ([string]$unique -ne [string]$output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_2_1
	Add-Content -Path $file_remPath -Value $rem4_2_1
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_2_1
}
################################################################################################
<#
$var4_2_2 = "4.2.2  Cấu hình chính sách 'Audit Computer Account Management' [Chỉ DC]"
$rem4_2_2 = ("4.2.2  Cấu hình chính sách 'Audit Computer Account Management' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Management\Audit Computer Account Management
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")
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
$rem4_2_3 = ("4.2.3  Cấu hình chính sách 'Audit Distribution Group Management' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Management\Audit Distribution Group Management
-----------------------------------------------
Tác động: 
")
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
$rem4_2_4 = ("4.2.4  Cấu hình chính sách 'Audit Other Account Management Events' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Management\Audit Other Account Management Events
-----------------------------------------------
Tác động: 
")

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
#>
################################################################################################
$var4_2_5 = "4.2.5  Cấu hình chính sách 'Audit Security Group Management'"
$rem4_2_5 = ("4.2.5  Cấu hình chính sách 'Audit Security Group Management'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Management\Audit Security Group Management
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_2_6 = ("4.2.6  Cấu hình chính sách 'Audit User Account Management'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Account Management\Audit User Account Management
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_3_1 = ("4.3.1  Cấu hình chính sách 'Audit Process Creation'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Detailed Tracking\Audit Process Creation
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_3_2 = ("4.3.2  Cấu hình chính sách 'Audit PNP Activity'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Detailed Tracking\Audit PNP Activity
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")
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
<#
$var4_4_1 = "4.4.1  Cấu hình chính sách 'Audit Directory Service Access' [Chỉ DC]"
$rem4_4_1 = ("4.4.1  Cấu hình chính sách 'Audit Directory Service Access' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\DS Access\Audit Directory Service Access
-----------------------------------------------
Tác động: 
")

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
$rem4_4_2 = ("4.4.2  Cấu hình chính sách 'Audit Directory Service Changes' [Chỉ DC]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\DS Access\Audit Directory Service Changes
-----------------------------------------------
Tác động: 
")
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
#>

################################################################################################
$var4_5 = "4.5  Đăng nhập/Đăng xuất"
Write-Host -ForegroundColor Blue $info -NoNewline;Write-Host $var4_5

################################################################################################
$var4_5_1 = "4.5.1  Cấu hình chính sách 'Audit Account Lockout'"
$rem4_5_1 = ("4.5.1  Cấu hình chính sách 'Audit Account Lockout'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Account Lockout
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

#  4.5.1 (L1) - Ensure 'Audit Account Lockout' is set to include 'Success and Failure'

$unique = auditpol.exe /get /category:*   | select-string "Account Lockout" |  Foreach { "$(($_ -split '\s+',4)[3])" }
$output = "Failure"
if ([string]$unique -ne [string]$output) {
	Write-Host -ForegroundColor Red $fail -NoNewline;Write-Host $var4_5_1
	Add-Content -Path $file_remPath -Value $rem4_5_1
}
else {
	Write-Host -ForegroundColor Green $pass -NoNewline;Write-Host $var4_5_1
}

################################################################################################
$var4_5_2 = "4.5.2  Cấu hình chính sách 'Audit Logoff'"
$rem4_5_2 = ("4.5.2  Cấu hình chính sách 'Audit Logoff'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Logoff
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_5_3 = ("4.5.3  Cấu hình chính sách 'Audit Logon'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Logon
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_5_4 = ("4.5.4  Cấu hình chính sách 'Audit Other Logon/Logoff Events'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Other Logon/Logoff Events
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_5_5 = ("4.5.5  Cấu hình chính sách 'Audit Special Logon'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Special Logon
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_5_6 = ("4.5.6  Cấu hình chính sách 'Ensure 'Audit Group Membership'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Logon/Logoff\Audit Group Membership
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")
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
$rem4_6_1 = ("4.6.1  Cấu hình chính sách 'Audit Detailed File Share'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Object Access\Audit Detailed File Share
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_6_2 = ("4.6.2  Cấu hình chính sách 'Audit File Share'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Object Access\Audit File Share
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_6_3 = ("4.6.3  Cấu hình chính sách 'Audit Other Object Access Events'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Object Access\Audit Other Object Access Events
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_6_4 = ("4.6.4  Cấu hình chính sách 'Audit Removable Storage'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Object Access\Audit Removable Storage
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")
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
$rem4_7_1 = ("4.7.1  Cấu hình chính sách 'Audit Audit Policy Change'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Policy Change\Audit Audit Policy Change
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_7_2 = ("4.7.2  Cấu hình chính sách 'Audit Authentication Policy Change'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Policy Change\Audit Authentication Policy Change
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_7_3 = ("4.7.3  Cấu hình chính sách 'Audit Authorization Policy Change'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Policy Change\Audit Authorization Policy Change
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_7_4 = ("4.7.4  Cấu hình chính sách 'Audit MPSSVC Rule-Level Policy Change'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Policy Change\Audit MPSSVC Rule-Level Policy Change
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_7_5 = ("4.7.5  Cấu hình chính sách 'Audit Other Policy Change Events'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Policy Change\Audit Other Policy Change Events
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_8_1 = ("4.8.1  Cấu hình chính sách 'Audit Sensitive Privilege Use'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\Privilege Use\Audit Sensitive Privilege Use
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_9_1 = ("4.9.1  Cấu hình chính sách 'Audit IPsec Driver'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\System\Audit IPsec Driver
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_9_2 = ("4.9.2  Cấu hình chính sách 'Audit Other System Events'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\System\Audit Other System Events
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_9_3 = ("4.9.3  Cấu hình chính sách 'Audit Security State Change'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\System\Audit Security State Change
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_9_4 = ("4.9.4  Cấu hình chính sách 'Audit Security System Extension'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\System\Audit Security System Extension
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem4_9_5 = ("4.9.5  Cấu hình chính sách 'Audit System Integrity'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Success and Failure
Computer Configuration\Policies\Windows Settings\Security Settings\Advanced Audit Policy Configuration\Audit Policies\System\Audit System Integrity
-----------------------------------------------
Tác động: Nếu không có cấu hình cài đặt kiểm toán hoặc nếu cài đặt kiểm toán quá lỏng lẻo trên các máy tính, có thể không phát hiện được các sự kiện an ninh hoặc sẽ không có đủ bằng chứng để phân tích phục hồi mạng sau các sự cố. Tuy nhiên, nếu cài đặt kiểm toán quá nghiêm ngặt, các mục quan trọng quan trọng trong Security log có thể bị nhiễu bởi tất cả các mục không có ý nghĩa.
")

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
$rem5_1_1 = ("5.1.1  Cấu hình chính sách 'Turn off app notifications on the lock screen'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Turn off app notifications on the lock screen
-----------------------------------------------
Tác động: Không có thông báo ứng dụng nào được hiển thị trên màn hình khóa.
")

#  5.1.1 (L1) - Ensure 'Turn off app notifications on the lock screen' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_1_2 = ("5.1.2  Cấu hình chính sách 'Turn off picture password sign-in'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Turn off picture password sign-in
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm CredentialProviders.admx/adml bao gồm trong Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: Người dùng sẽ không thể thiết lập hoặc đăng nhập bằng một mật khẩu hình ảnh.
")

#  5.1.2 (L1) - Ensure 'Turn off picture password sign-in' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_1_3 = ("5.1.3  Cấu hình chính sách 'Turn on convenience PIN sign-in'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Turn on convenience PIN sign-in
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm CredentialProviders.admx/adml bao gồm trong Mẫu quản trị Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  5.1.3 (L1) - Ensure 'Turn on convenience PIN sign-in' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_1_4 = ("5.1.4  Cấu hình chính sách 'Block user from showing account details on sign-in'
Người dùng không thể chọn hiển thị chi tiết tài khoản trên màn hình đăng nhập.
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Block user from showing account details on sign-in
* Lưu ý: Đường dẫn Group Policy này có thể không tồn tại trong mặc định. Nó được cung cấp bởi Logon.admx/adml đi kèm với Microsoft Windows 10 Release 1607 & Server 2016 Administrative Templates
-----------------------------------------------
Tác động: Người dùng sẽ không thể chọn hiển thị chi tiết tài khoản trên màn hình đăng nhập.
")

#  5.2.1 (L1) - Ensure 'Require a password when a computer wakes (on battery)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_1_5 = ("5.1.5  Cấu hình chính sách 'Do not display network selection UI'
Ngăn cản người dùng trái phép có thể ngắt kết nối PC khỏi mạng hoặc có thể kết nối PC với các mạng khả dụng khác mà không cần đăng nhập vào Windows
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Do not display network selection UI
* Lưu ý: Đường dẫn Group Policy này có thể không tồn tại trong mặc định. Nó được cung cấp bởi Logon.admx/adml đi kèm với Microsoft Windows 8.1 & Server 2012 R2 Administrative Templates (or newer)
-----------------------------------------------
Tác động: Trạng thái kết nối mạng của PC không thể thay đổi mà không đăng nhập vào Windows.
")

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
#  	5.1.5 (L1) - Ensure 'Do not display network selection UI' is set to 'Enabled' (Scored)

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_1_6 = ("5.1.6  Cấu hình chính sách 'Do not enumerate connected users on domain joined computers'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Do not enumerate connected users on domain-joined computers
* Lưu ý: Đường dẫn Group Policy này có thể không tồn tại trong mặc định. Nó được cung cấp bởi Logon.admx/adml đi kèm với Microsoft Windows 8.1 & Server 2012 R2 Administrative Templates (or newer)
-----------------------------------------------
Tác động: Giao diện đăng nhập sẽ không liệt kê bất kỳ người dùng kết nối nào trên các máy tính đã tham gia vào domain.
")

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{
#  	5.1.6 (L1) - Ensure 'Do not enumerate connected users on domainjoined computers' is set to 'Enabled' (Scored)

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_1_7 = ("5.1.7  Cấu hình chính sách 'Enumerate local users on domain-joined computers' [Chỉ MS]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\System\Logon\Enumerate local users on domain-joined computers
* Lưu ý: Đường dẫn Group Policy này có thể không tồn tại trong mặc định. Nó được cung cấp bởi Logon.admx/adml đi kèm với Microsoft Windows 8.0 & Server 2012 (non R2) Administrative Templates (or newer)
Tác động: Giao diện đăng nhập sẽ không liệt kê bất kỳ người dùng kết nối nào trên các máy tính đã tham gia vào domain.
"
)
$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name version
}
Catch [System.Management.Automation.PSArgumentException]
{

#  	5.1.7 (L1) - Ensure 'Enumerate local users on domain-joined computers' is set to 'Disabled' (MS only) (Scored)

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_2_1 = ("5.2.1  Cấu hình chính sách 'Require a password when a computer wakes (on battery)'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\System\Power Management\Sleep Settings\Require a password when a computer wakes (on battery)
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm Power.admx/adml bao gồm trong Mẫu quản trị Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  5.2.1 (L1) - Ensure 'Require a password when a computer wakes (on battery)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_2_2 = ("5.2.2  Cấu hình chính sách 'Require a password when a computer wakes (plugged in)'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\System\Power Management\Sleep Settings\Require a password when a computer wakes (plugged in)
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm Power.admx/adml bao gồm trong Mẫu quản trị Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  5.2.2 (L1) - Ensure 'Require a password when a computer wakes (plugged in)' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_3_1 = ("5.3.1  Cấu hình chính sách 'Disallow Autoplay for non-volume devices'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled
Computer Configuration\Policies\Administrative Templates\Windows Components\AutoPlay Policies\Disallow Autoplay for non-volume devices
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm AutoPlay.admx/adml bao gồm trong Mẫu quản trị Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: AutoPlay sẽ không được phép cho các thiết bị MTP như máy ảnh hoặc điện thoại.
")

#  5.3.1 (L1) - Ensure 'Disallow Autoplay for non-volume devices' is set to 'Enabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_3_2 = ("5.3.2  Cấu hình chính sách 'Set the default behavior for AutoRun'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled: Do not execute any autorun commands
Computer Configuration\Policies\Administrative Templates\Windows Components\AutoPlay Policies\Set the default behavior for AutoRun
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm AutoPlay.admx/adml bao gồm trong Mẫu quản trị Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: Các lệnh AutoRun sẽ bị tắt hoàn toàn.
")

#  5.3.2 (L1) - Ensure 'Set the default behavior for AutoRun' is set to 'Enabled: Do not execute any autorun commands'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_3_3 = ("5.3.3  Cấu hình chính sách 'Turn off Autoplay'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled: All drives
Computer Configuration\Policies\Administrative Templates\Windows Components\AutoPlay Policies\Turn off Autoplay
* Lưu ý: Đường dẫn Chính sách Nhóm này có thể không tồn tại, được cung cấp bởi mẫu Chính sách Nhóm AutoPlay.admx/adml bao gồm trong Mẫu quản trị Microsoft Windows 8.0 & Server 2012 (non-R2) (hoặc các phiên bản mới hơn).
-----------------------------------------------
Tác động: Người dùng sẽ phải bắt đầu thủ công các chương trình cài đặt hoặc chạy các chương trình cài đặt từ các ổ cứng ngoài.
")

#  5.3.3 (L1) - Ensure 'Turn off Autoplay' is set to 'Enabled: All drives'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
-----------------------------------------------
Tác động: 
EOF
)")
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
$var5_4_1_1 = "5.4.1.1  Thiết lập chính sách 'Application: người dùng sẽ phải bắt đầu thủ công các chương trình cài đặt hoặc chạy các chương trình cài đặt từ phương tiện gắn ngoại  the log file reaches its maximum size'"
$rem5_4_1_1 = ("5.4.1.1  Thiết lập chính sách 'Application: Control Event Log behavior when the log file reaches its maximum size'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\Application\Control Event Log behavior when the log file reaches its maximum size
-----------------------------------------------
Tác động: Nếu các sự kiện mới không được ghi lại, có thể khó hoặc không thể xác định nguyên nhân gốc của các vấn đề hệ thống hoặc các hoạt động trái phép của người dùng độc hại.
")

#  5.4.1.1 (L1) - Ensure 'Application: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_1_2 = ("5.4.1.2  Thiết lập chính sách 'Application: Specify the maximum log file size [KB]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled: >= 32,768
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\Application\Specify the maximum log file size (KB)
* Lưu ý:
•	Để giảm thiểu rủi ro mất dữ liệu khi việc ghi nhật ký bị đầy, có thể áp dụng các chính sách (data retention) để lựa chọn lưu giữ các sự kiện cũ nào được ghi đè khi cần.
•	Hệ quả của việc cấu hình chính sách này là các sự kiện cũ hơn sẽ bị xóa khỏi nhật ký. Kẻ tấn công có thể lợi dụng để tạo ra một số lượng lớn các sự kiện không liên quan nhằm ghi đè lên các bằng chứng về cuộc tấn công.
	Tốt nhất, nên sử dụng các giải pháp giám sát cụ thể. Nếu tất cả các sự kiện được gửi đến một máy chủ giám sát sẽ hỗ trợ cho việc thu thập thông tin và các hoạt động điều tra về sau
-----------------------------------------------
Tác động: Hậu quả của cấu hình này là các sự kiện cũ sẽ bị xóa khỏi các nhật ký. Những kẻ tấn công có thể tận dụng cấu hình như vậy, vì họ có thể tạo ra một lượng lớn sự kiện không liên quan để ghi đè lên bất kỳ bằng chứng nào về cuộc tấn công của họ. Những rủi ro này có thể giảm đi một chút nếu tự động hóa việc lưu trữ dữ liệu nhật ký sự kiện.
")

#  5.4.1.2 (L1) - Ensure 'Application: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application -Name version
}
Catch [System.Management.Automation.PSArgumentException] {
	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_2_1 = ("5.4.2.1  Thiết lập chính sách 'Security: Control Event Log behavior when the log file reaches its maximum size'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\Security\Control Event Log behavior when the log file reaches its maximum size
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  5.4.2.1 (L1) - Ensure 'Security: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_2_2 = ("5.4.2.2  Thiết lập chính sách 'Security: Specify the maximum log file size [KB]
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled: >= 196,608
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\ Security\Specify the maximum log file size (KB)
* Lưu ý:
•	Để giảm thiểu rủi ro mất dữ liệu khi việc ghi nhật ký bị đầy, có thể áp dụng các chính sách (data retention) để lựa chọn lưu giữ các sự kiện cũ nào được ghi đè khi cần.
•	Hệ quả của việc cấu hình chính sách này là các sự kiện cũ hơn sẽ bị xóa khỏi nhật ký. Kẻ tấn công có thể lợi dụng để tạo ra một số lượng lớn các sự kiện không liên quan nhằm ghi đè lên các bằng chứng về cuộc tấn công.
	Tốt nhất, nên sử dụng các giải pháp giám sát cụ thể. Nếu tất cả các sự kiện được gửi đến một máy chủ giám sát sẽ hỗ trợ cho việc thu thập thông tin và các hoạt động điều tra về sau.
-----------------------------------------------
Tác động: Hậu quả của cấu hình này là các sự kiện cũ sẽ bị xóa khỏi các nhật ký. Những kẻ tấn công có thể tận dụng cấu hình như vậy, vì họ có thể tạo ra một lượng lớn sự kiện không liên quan để ghi đè lên bất kỳ bằng chứng nào về cuộc tấn công của họ. Những rủi ro này có thể giảm đi một chút nếu tự động hóa việc lưu trữ dữ liệu nhật ký sự kiện.
")

#  5.4.2.2 (L1) - Ensure 'Security: Specify the maximum log file size (KB)' is set to 'Enabled: 196,608 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_3_1 = ("5.4.3.1  Thiết lập chính sách 'Setup: Control Event Log behavior when the log file reaches its maximum size'[KB]'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\Setup\Control Event Log behavior when the log file reaches its maximum size
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")
#  5.4.3.1 (L1) - Ensure 'Setup: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_3_2 = ("5.4.3.2  Thiết lập chính sách 'Setup: Specify the maximum log file size [KB]'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled: >= 32,768
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\Setup\Specify the maximum log file size (KB)
* Lưu ý:
•	Để giảm thiểu rủi ro mất dữ liệu khi việc ghi nhật ký bị đầy, có thể áp dụng các chính sách (data retention) để lựa chọn lưu giữ các sự kiện cũ nào được ghi đè khi cần.
•	Hệ quả của việc cấu hình chính sách này là các sự kiện cũ hơn sẽ bị xóa khỏi nhật ký. Kẻ tấn công có thể lợi dụng để tạo ra một số lượng lớn các sự kiện không liên quan nhằm ghi đè lên các bằng chứng về cuộc tấn công.
	Tốt nhất, nên sử dụng các giải pháp giám sát cụ thể. Nếu tất cả các sự kiện được gửi đến một máy chủ giám sát sẽ hỗ trợ cho việc thu thập thông tin và các hoạt động điều tra về sau.
-----------------------------------------------
Tác động: Hậu quả của cấu hình này là các sự kiện cũ sẽ bị xóa khỏi các nhật ký. Những kẻ tấn công có thể tận dụng cấu hình như vậy, vì họ có thể tạo ra một lượng lớn sự kiện không liên quan để ghi đè lên bất kỳ bằng chứng nào về cuộc tấn công của họ. Những rủi ro này có thể giảm đi một chút nếu tự động hóa việc lưu trữ dữ liệu nhật ký sự kiện.
")

#  5.4.3.2 (L1) - Ensure 'Setup: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_4_1 = ("5.4.4.1  Thiết lập chính sách 'System: Control Event Log behavior when the log file reaches its maximum size'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Disabled
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\System\Control Event Log behavior when the log file reaches its maximum size
-----------------------------------------------
Tác động: Không ảnh hưởng tới hệ thống - đây là hành vi mặc định.
")

#  5.4.4.1 (L1) - Ensure 'System: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System
-----------------------------------------------
Tác động: 
EOF
)")
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
$rem5_4_4_2 = ("5.4.4.2  Thiết lập chính sách 'System: Specify the maximum log file size [KB]'
Cấu hình tham số theo đường dẫn sau với khuyến nghị: Enabled: >= 32,768
Computer Configuration\Policies\Administrative Templates\Windows Components\Event Log Service\System\Specify the maximum log file size (KB)
* Lưu ý:
•	Để giảm thiểu rủi ro mất dữ liệu khi việc ghi nhật ký bị đầy, có thể áp dụng các chính sách (data retention) để lựa chọn lưu giữ các sự kiện cũ nào được ghi đè khi cần.
•	Hệ quả của việc cấu hình chính sách này là các sự kiện cũ hơn sẽ bị xóa khỏi nhật ký. Kẻ tấn công có thể lợi dụng để tạo ra một số lượng lớn các sự kiện không liên quan nhằm ghi đè lên các bằng chứng về cuộc tấn công.
	Tốt nhất, nên sử dụng các giải pháp giám sát cụ thể. Nếu tất cả các sự kiện được gửi đến một máy chủ giám sát sẽ hỗ trợ cho việc thu thập thông tin và các hoạt động điều tra về sau.
-----------------------------------------------
Tác động: Không tác động tới hệ thống - đây là hành vi mặc định.
")

#  5.4.4.2 (L1) - Ensure 'System: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'

$ErrorActionPreference = "stop"
Try {
 Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System -Name version
}
Catch [System.Management.Automation.PSArgumentException] {

	$path = (Test-Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\System
-----------------------------------------------
Tác động: 
EOF
)")
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
		if ($defender.RealTimeProtectionEnabled -eq $true) {
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
    if($defenderSettings.ScheduledScanTime -eq ""){
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

$file_tmpPath = "C:\Users\Public\remediation_tmp.txt"
Get-Content -Path $file_remPath | Out-File -FilePath $file_tmpPath -Encoding UTF8
Remove-Item -Path $file_remPath
Get-Content -Path $file_tmpPath 
Remove-Item -Path $file_tmpPath