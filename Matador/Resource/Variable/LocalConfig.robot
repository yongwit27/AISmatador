*** Settings ***
Documentation     การใช้งาน Local Config ต้องใส่ชื่อ Config Name ของตัวเองที่หน้า Run ใน RIDE \ --variable CONFIGNAME:Ta
...
...               EXAMPLE \ --outputdir D:/RobotFrameworkLogs/%date:~-4,4%%date:~-7,2%%date:~-10,2% --timestampoutputs --variable CONFIGNAME:Ta

*** Variables ***
${ENV}            Test
${LANG}           EN
${GENERAL_TIMEOUT}    ${30}    # Timeout สำหรับหน่วงตัวแปล ในการรอหน้า Website
${BROWSERTYPE}    ff    # Browser ที่ต้องการจะเปิด ff gc ie
${SETWINDOWSITE}    False    # กรณี ไม่ต้องการ Mizimize window สามารถ Set window size แทนได้
${JSONPATH}       D:\\BatchSendEmailByOutlook\\EmailData.json
${WINDOWHEIGHT}    1366
${WINDOWWIDTH}    768
${PRODUCTNAME}    ProdQ
${USERNAME}       QYongQ
${PATHDOWNLOADFILE}    D:\\download\\
${REGISTER_EMAIL}    teststartup22@sand.ais.co.th
${REGISTER_PASSWORD}    teststartup22
${STARTUP_PROFILE_EMAIL}    teststartup23@sand.ais.co.th
${STARTUP_PROFILE_PASSWORD}    teststartup23
${APPOINTMENT_TIME_FROM}    03:05    # เวลาที่ใช้ในการนัดหมาย
${APPOINTMENT_TIME_TO}    04:00    # เวลาที่ใช้ในการนัดหมาย
