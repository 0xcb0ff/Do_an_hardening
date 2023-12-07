# Tổng quan

Đây là công cụ kiểm tra Audit dựa trên chuẩn CIS Benchmark và hướng dẫn cấu hình Hardening!

## Cài đặt
### Linux

Tải xuống công cụ
```bash
wget https://github.com/cuongvanhg001/Do_an/releases/download/V1.0.2/Auditv1.0.2.tar.gz
```
Giải nén công cụ
```bash
tar -zxvf Auditv1.0.2.tar.gz
```
Thực thi công cụ
```bash
./audit_tool.ps1
```

### Windows
Tải xuống công cụ bằng Powershell
```bash
Invoke-WebRequest -URI https://github.com/cuongvanhg001/Do_an/releases/download/V1.0.2/Auditv1.0.2.zip -OutFile .\Auditv1.0.2.zip
```
Giải nén công cụ
```bash
Expand-Archive -Path .\Auditv1.0.2.zip -DestinationPath .\Audit_tool -Force
```
Thực thi công cụ
```bash
cd Audit_tool
.\audit_tool.ps1
```
