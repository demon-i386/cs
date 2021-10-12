@echo off
:check_java
    java -version >nul 2>&1
    if %errorLevel% == 0 (
        goto:check_permissions
    ) else (
        echo [-] is Java installed?
        goto:eof
    )
    
:check_permissions
    echo [+] Administrative permissions required. Detecting permissions...
    set TempFile_Name=%SystemRoot%\System32\BatTestUACin_SysRt%Random%.batemp
    (echo "BAT Test UAC in Temp" >%TempFile_Name% ) 1>nul 2>nul
    if exist %TempFile_Name% (
        echo [+] Success: Administrative permissions confirmed.
    del %TempFile_Name% 1>nul 2>nul
        goto:check_certificate
    ) else (
        echo [-] Failure: Current permissions inadequate.
        goto:eof
    )

:check_certificate
    set certificate=".\cobaltstrike.store"
    if exist %certificate% (
        goto:test_arguments
    ) else (
        echo [!] Please generate the cobaltstrike.store !
        echo [!] Example: keytool -keystore ./cobaltstrike.store -storepass Mannix123456 -keypass Mannix123456 -genkey -keyalg RSA -alias cobaltstrike -dname "CN=www.qianxin.com, OU=北京奇安信科技有限公司, O=运维部, L=北京, S=北京, C=CN"
        goto:eof
    )
    
:test_arguments
    set argC=0
    for %%x in (%*) do Set /A argC+=1
    if %argC% LSS 2 (
        echo [-] teamserver ^<host^> ^<password^> [/path/to/c2.profile] [YYYY-MM-DD]
        echo     ^<host^> is the default IP address of this Cobalt Strike team server
        echo     ^<password^> is the shared password to connect to this server
        echo     [/path/to/c2.profile] is your Malleable C2 profile
        echo     [YYYY-MM-DD] is a kill date for Beacon payloads run from this server
        goto:eof
    ) else (
        goto:run_cobal
    )
:run_cobal
    java -XX:ParallelGCThreads=4 -Dcobaltstrike.server_port=54321 -Djavax.net.ssl.keyStore=./cobaltstrike.store -Djavax.net.ssl.keyStorePassword=Mannix123456 -server -XX:+AggressiveHeap -XX:+UseParallelGC -Xms512M -Xmx1024M -classpath ./cobaltstrike.jar server.TeamServer %*