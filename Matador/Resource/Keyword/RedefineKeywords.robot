*** Settings ***
Library           Selenium2Library
Library           Collections
Library           String
Library           BuiltIn
Library           DateTime
Library           OperatingSystem
Library           DatabaseLibrary
Library           HttpLibrary.HTTP
Library           ArchiveLibrary
Library           Process
Library           CustomExcelXlsLibrary
Library           XML
Library           AutoItLibrary

*** Keywords ***
Check Exist Database
    [Arguments]    ${SQL}
    [Documentation]    This keyword check data from database by SQL query
    ...
    ...    If data exists in database keyword return result "PASS"
    ...    when data not exists in database keyword return result "FAIL"
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Check Exists Database | SQL Query
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    database='${AISTHESTARTUP_NAME_DB}', user='${AISTHESTARTUP_USERNAME_DB}', password='${AISTHESTARTUP_PASSWORD_DB}', host='${AISTHESTARTUP_HOST_DB}', port=${AISTHESTARTUP_PORT_DB}
    DatabaseLibrary.Check If Exists In Database    ${SQL}
    [Teardown]    Wait Until Keyword Succeeds    5x    1s    DatabaseLibrary.Disconnect From Database

Check Not Exist Database
    [Arguments]    ${SQL}
    [Documentation]    This keyword check data from database by SQL query
    ...
    ...    If data exists in database keyword return result "FAIL"
    ...    when data not exists in database keyword return result "PASS"
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Check Not Exists Database | SQL Query
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    database='${AISTHESTARTUP_NAME_DB}', user='${AISTHESTARTUP_USERNAME_DB}', password='${AISTHESTARTUP_PASSWORD_DB}', host='${AISTHESTARTUP_HOST_DB}', port=${AISTHESTARTUP_PORT_DB}
    DatabaseLibrary.Check If Not Exists In Database    ${SQL}
    [Teardown]    Wait Until Keyword Succeeds    5x    1s    DatabaseLibrary.Disconnect From Database

Click Web Element
    [Arguments]    ${Locator}    ${Index}=None    ${Timeout}=${General_TimeOut}
    [Documentation]    Click element identified by locator.
    ...
    ...    Step in keyword
    ...
    ...    Line 1 : Run keyword "Wait Web Until Page Contains Element" and return status in parameter ${Result}
    ...    Line 2 : Run keyword "Wait Until Element Is Visible" If ${Result}=False
    ...    Line 3 :
    ...    Line 4 : Wait Until Keyword "Click Element" Runs the specified keyword and retries 10 time in 1 second if it fails.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Click Web Element | ${Locator} | ${Index}=None | ${Timeout}=${General_TimeOut}
    ${Locator}    Run Keyword If    '${Index}' != 'None'    Get Locator From Position    ${Locator}    ${Index}
    ...    ELSE    BuiltIn.Set Variable    ${Locator}
    ${Result}    BuiltIn.Run Keyword And Return Status    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    ${Result}==${True}    Web Element Should Be Visible    ${Locator}    ${Timeout}
    Set Focus To Element    ${Locator}
    Comment    Web Scroll Element Into View    ${Locator}
    ${Result_Click}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Click Element    ${Locator}
    BuiltIn.Run Keyword If    ${Result_Click}==${False}    Selenium2Library.Click Element    ${Locator}

Close Web Browser
    [Documentation]    Close browser.
    ...    (Only open browser by robot framework)
    Selenium2Library.Close Browser

Common Input Web Element
    [Arguments]    ${Field}    ${Locator}    ${Text}
    [Documentation]    *"Common Input Web Element"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Input Web Element* | ${Field} | ${Locator} | ${Text}
    ...
    ...    *Example*
    ...
    ...    | *Common Input Web Element* | ${Field} | ${Xpath} | ${Text} |
    ${UpperCase}    String.Convert To Uppercase    ${Field}
    @{Type}    Get Regexp Matches    ${UpperCase}    ^(LIST|CHKBOX|FIELD|RADIO)
    ${Type}    Set Variable    @{Type}[0]
    ${Flag}    BuiltIn.Run Keyword If    '${Type}' == 'CHKBOX' or '${Type}' == 'RADIO'    Convert To Uppercase    ${Text}
    #Wait Loading not visible
    Wait Until Keyword Succeeds    5x    1s    Web Element Should Be Not Visible    //div[@id='loading'] | //div[@id='loading-bar']
    BuiltIn.Run Keyword If    '${Type}' == 'FIELD'    Input Web Text    ${Locator}    ${Text}
    ...    ELSE IF    ('${Type}' == 'CHKBOX' or '${Type}' == 'RADIO') and '${Flag}' == 'TRUE'    Web Select Checkbox    ${Locator}
    ...    ELSE IF    ('${Type}' == 'CHKBOX' or '${Type}' == 'RADIO') and '${Flag}' == 'FALSE'    Web Unselect CheckBox    ${Locator}
    ...    ELSE IF    '${Type}' == 'LIST'    Select From Web List By Label    ${Locator}    ${Text}
    ...    ELSE    BuiltIn.Fail    Format is wrong.

Common Split Field And Index
    [Arguments]    ${Field}
    [Documentation]    *"Common Split Field And Index"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Split Field And Index* | ${Field}
    ...
    ...    ${FieldNoIndex} | ${Index} | *Common Split Field And Index* | ${Field}
    ...
    ...    *Example*
    ...
    ...    | ${Field} | ${Index} | *Common Split Field And Index* | ${Field} |
    ${FieldWithIndex} =    BuiltIn.Evaluate    re.search(r"\\[","${Field}")    re
    ${Index}    Run Keyword If    '${FieldWithIndex}' != 'None'    String.Remove String Using Regexp    ${Field}    \\\D
    ${FieldNoIndex}    String.Remove String Using Regexp    ${Field}    \\\[\\\d*]$
    ${FieldNoIndex}    String.Convert To Uppercase    ${FieldNoIndex}
    [Return]    ${FieldNoIndex}    ${Index}

Common Verify Error Message
    [Arguments]    ${Field}    ${Xpath}    ${Key}    ${Visible}=True
    [Documentation]    *"Common Verify Error Message"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Verify Error Message* | ${Field} | ${Xpath} | ${Key} | ${Visible}=True
    ...
    ...    ${Field} | ${Key} | ${ActualText} | *Common Verify Error Message* | ${Field} | ${Xpath} | ${Key} | ${Visible}=True
    ...
    ...    *Example*
    ...
    ...    ${Field} | ${Key} | ${ActualText} | *Common Verify Error Message* | ${Field} | ${Xpath} | ${Key} | ${Visible}=True
    ${Visible}    String.Convert To Uppercase    ${Visible}
    ${Field}    String.Convert To Uppercase    ${Field}
    ${Key}    String.Convert To Uppercase    ${Key}
    BuiltIn.Run Keyword And Return If    '${Visible}' == 'FALSE'    Web Element Should Be Not Visible    ${Xpath}
    ${ActualText}    BuiltIn.Run Keyword If    '${Visible}' == 'TRUE'    Get Web Text    ${Xpath}
    [Return]    ${Field}    ${Key}    ${ActualText}

Common Verify Field
    [Arguments]    ${Xpath}    @{Text}
    [Documentation]    *"Common Verify Field"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Verify Field* | ${Xpath} | @{Text}
    ...
    ...    *Example*
    ...
    ...    | *Common Verify Field* | ${Locator} | ${AppInfo} |
    @{ListText}    Split String    @{Text}    =    1
    ${Verify}    Set Variable    @{ListText}[0]
    ${Value}    Set Variable    @{ListText}[1]
    ${StringUpperCase}    String.Convert To Uppercase    ${Verify}
    BuiltIn.Run Keyword If    '${StringUpperCase}' == 'TEXT'    Verify Text    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'LENGTH'    Verify Length    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'PLACEHOLDER'    Verify Placeholder    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'ENABLE'    Verify Enable    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'ALLITEM'    Verify DropdownList    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'SELECTEDLIST'    List Selection Should Be    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'VISIBLE'    Verify Visible    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'CHECK'    Verify CheckBox    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'RADIO'    Verify Radio    ${Xpath}    ${Value}
    ...    ELSE    BuiltIn.Fail    ${Verify} is wrong format.

Count Element
    [Arguments]    ${Locator}    ${Expected}
    [Documentation]    This keyword returns number of elements matching by locator and compare number of actual with expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Count Elemeny | ${Locator} | ${Expected}
    Run Keyword And Return Status    Selenium2Library.Wait Until Page Contains Element    ${Locator}    5sec
    ${Actual}    Get Matching Xpath Count    ${Locator}
    BuiltIn.Should Be Equal As Strings    ${Actual}    ${Expected}

Delete All Directory
    [Arguments]    ${Path}
    [Documentation]    Keyword will delete the directory Only
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Delete All Directory | ${Path}
    ...
    ...    Example Path
    ...    Path = D:\\FileDevPortal
    ${Count}    OperatingSystem.Count Directories In Directory    ${Path}
    @{FileList}=    OperatingSystem.List Directories In Directory    ${Path}
    : FOR    ${i}    INRANGE    0    ${Count}
    \    Exit For Loop If    '${Count}' == '0'
    \    log    ${Path}@{FileList}[${i}]
    \    Remove Directory    ${Path}@{FileList}[${i}]    recursive=True
    Log    Delete All File From ${Path} Suscess

Delete All File
    [Arguments]    ${Path}
    [Documentation]    Keyword will delete all the File Only
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Delete All File | ${Path}
    ...
    ...    Example Path
    ...    Path = D:\\FileDevPortal
    ${Count}    OperatingSystem.Count Files In Directory    ${Path}
    @{FileList}=    OperatingSystem.List Files In Directory    ${Path}
    : FOR    ${i}    INRANGE    0    ${Count}
    \    Exit For Loop If    '${Count}' == '0'
    \    log    ${Path}@{FileList}[${i}]
    \    Wait Until Keyword Succeeds    5x    1s    Remove File    ${Path}@{FileList}[${i}]
    \    Remove File    ${Path}@{FileList}[${i}]
    Log    Delete All File From ${Path} Suscess

Delete File In Directory
    [Arguments]    ${FileName}
    [Documentation]    Keyword will delete the file Only
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Delete File In Directory | ${FileName}
    ${StatusFile}    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${PathDownloadFile}${FileName}
    Run Keyword If    '${StatusFile}' == 'True'    BuiltIn.Wait Until Keyword Succeeds    5x    2s    BuiltIn.Run Keywords    OperatingSystem.Remove File
    ...    ${PathDownloadFile}${FileName}*
    ...    AND    OperatingSystem.Wait Until Removed    ${PathDownloadFile}${FileName}
    ${Result}=    BuiltIn.Run Keyword And Return Status    OperatingSystem.File Should Not Exist    ${PathDownloadFile}${FileName}
    BuiltIn.Should Be Equal    ${Result}    ${True}

Double Click Web Element
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Double click element identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Double Click Web Element | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Selenium2Library.Double Click Element    ${Locator}

Download File
    [Arguments]    ${Locator}    ${FileName}=None
    [Documentation]    This keyword click download file from locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Download File | ${Locator} | ${FileName}=None
    ${FileName}    BuiltIn.Run Keyword If    '${FileName}'=='None'    Get Web Text    ${Locator}
    ...    ELSE    BuiltIn.Set Variable    ${FileName}
    Delete File In Directory    ${FileName}
    Click Web Element    ${Locator}
    ${FullFile}    BuiltIn.Catenate    SEPARATOR=    ${PATHDOWNLOADFILE}    ${FileName}
    BuiltIn.log    ${FullFile}
    OperatingSystem.Wait Until Created    ${FullFile}    5s

Find Xpath
    [Arguments]    ${NameXpath}
    [Documentation]    Find Xpath Keyword is called in other keywords in case there are multiple xpaths on web
    ...
    ...    This keyword will return Xpath which is visible on web firstly
    ...
    ...    *Remark*: ${NameXpath} is defined in PageRepository Page.
    ...
    ...    Format ${NameXpath} = Xpath1 | Xpath2 | ... | XpathN which
    @{ListXpath}    Split String    ${NameXpath}    |    -1
    ${Length}    Get Length    ${ListXpath}
    : FOR    ${i}    IN RANGE    0    ${Length}
    \    ${Xpath}    Set Variable    @{ListXpath}[${i}]
    \    ${Result}    Run Keyword And Return Status    Web Element Should Be Visible    ${Xpath}    1
    \    Exit For Loop If    '${Result}' == 'True'
    log    ${Xpath}
    [Return]    ${Xpath}

Get All Data From Database
    [Arguments]    ${SQL}
    [Documentation]    The Keyword Require selectStatement and keyword return queryResult or rowcount from selectStatement
    ...
    ...    **Example**
    ...    ${queryResults} \ \ \ Get Row and Column from database SELECT * FROM SDK_PLATFORM
    ...
    ...    *Use Variable*
    ...
    ...    ${queryResults[row][column]}
    ...    ${queryResults[0][0]}
    ...    ${queryResults[1][0]}
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    database='${AISTHESTARTUP_NAME_DB}', user='${AISTHESTARTUP_USERNAME_DB}', password='${AISTHESTARTUP_PASSWORD_DB}', host='${AISTHESTARTUP_HOST_DB}', port=${AISTHESTARTUP_PORT_DB},charset='utf8mb4'
    ${QueryData}    DatabaseLibrary.Query    ${SQL}
    Comment    ${Status}    Run Keyword And Return Status    Decode Bytes To String    ${QueryData}    iso-8859-11    #Decode Thai
    Comment    ${QueryData}    Run Keyword If    "${Status}" == "True"    Decode Bytes To String    ${QueryData}    iso-8859-11
    ...    ELSE    Set Variable    ${QueryData}
    [Teardown]    Wait Until Keyword Succeeds    15x    1s    DatabaseLibrary.Disconnect From Database
    [Return]    ${QueryData}

Get Data From Database
    [Arguments]    @{input}
    [Documentation]    input = selectStatement, row
    ...
    ...    selectStatement : Required. \ Uses the input `selectStatement` to query for the values
    ...
    ...    row : Optional. Default = 1
    ...
    ...    *Example*
    ...
    ...    input = select APPLICATION_NAME from APPLICATION
    ...
    ...    query data in database which row=1
    ...
    ...    input = select APPLICATION_NAME from APPLICATION, 5
    ...
    ...    query data in database which row=5
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    database='${AISTHESTARTUP_NAME_DB}', user='${AISTHESTARTUP_USERNAME_DB}', password='${AISTHESTARTUP_PASSWORD_DB}', host='${AISTHESTARTUP_HOST_DB}', port=${AISTHESTARTUP_PORT_DB}, charset='utf8mb4'
    ${queryResults}    DatabaseLibrary.Query    @{input}[0]
    ${ValueInDB}    Set Variable    ${queryResults[0][0]}
    ${Type}    Evaluate    type($ValueInDB)
    log    ${Type}
    ${lengthList} =    BuiltIn.Get Length    ${input}
    log    @{input}[0]
    @{resultQuery} =    DatabaseLibrary.Query    @{input}[0]
    Log Many    @{resultQuery}[0]
    ${row} =    BuiltIn.Run Keyword If    ${lengthList} == 2    Evaluate    @{input}[1] - 1
    @{result} =    BuiltIn.Set Variable If    ${lengthList} == 2    @{resultQuery}[${row}]    @{resultQuery}[0]
    Log    @{result}[0]
    ${ValueInDB}    Set Variable    @{result}[0]
    ${Type}    Evaluate    type($ValueInDB)
    ${ValueInDB}    Run Keyword And Ignore Error    Run Keyword If    "${Type}" == "<type 'str'>"    Evaluate    ord("${ValueInDB}")
    ...    ELSE IF    "${Type}" == "<type 'unicode'>"    Set Variable    ${ValueInDB}
    ...    ELSE    Set Variable    ${ValueInDB}
    ${ValueInDB} =    BuiltIn.Set Variable If    '@{ValueInDB}[0]' == 'FAIL'    0    @{ValueInDB}[1]
    ${ValueInDB} =    Convert To String    ${ValueInDB}
    ### EXAMPLE ## \    ### select DBMS_LOB.substr(application_draft_obj, 4000,1) FROM APPLICATION_DRAFT WHERE PARTNER_ID = '35006' ORDER BY MODIFY_DATE DESC
    [Teardown]    Wait Until Keyword Succeeds    5x    1s    DatabaseLibrary.Disconnect From Database
    [Return]    ${ValueInDB}

Get Data From Excel By Name
    [Arguments]    ${FileName}    ${SheetName}    ${CellName}
    [Documentation]    Get Data From Excel By Name
    ...
    ...    Require
    ...
    ...    ${FileName} \ \ \ \ abc.xls
    ...    ${SheetName} \ \ \ Sheet1
    ...    ${CellName} \ \ \ A01
    ...
    ...    Example
    ...    Get Data From Excel By Name \ abc.xls \ Sheet1 \ A01
    BuiltIn.Wait Until Keyword Succeeds    5X    1s    CustomExcelXlsLibrary.Open Excel    ${PathDownloadFile}${FileName}
    ${Value}    CustomExcelXlsLibrary.Read Cell Data By Name    ${SheetName}    ${CellName}
    CustomExcelXlsLibrary.Close Excel
    [Return]    ${Value}

Get Full Xpath
    [Arguments]    ${Xpathnum}    @{Value}
    [Documentation]    Get Full Xpath will replace #numN# in *Xpathnum* to *value* which you specifies.
    ...
    ...    N is integer.
    ${LenIndex}    BuiltIn.Get Length    ${Value}
    ${Xpath}    Set Variable    ${Xpathnum}
    : FOR    ${i}    IN RANGE    0    ${LenIndex}
    \    ${Index}    Evaluate    ${i}+1
    \    ${Index}    Set Variable    \#num${Index}#
    \    Log    ${i}
    \    Log    ${Index}
    \    Log    ${Xpath}
    \    log    @{Value}
    \    Log    @{Value}[${i}]
    \    ${Xpath}    Replace String Using Regexp    ${Xpath}    ${Index}    @{Value}[${i}]
    [Return]    ${Xpath}

Get Locator From Position
    [Arguments]    ${Locator}    ${Position}=1
    [Documentation]    The Keyword Require two arg ${Locator} | ${Position}=1
    ...
    ...    and keyword return element from expect position
    ${StringMatch}    Run Keyword And Return Status    Should Match Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ${RegexpLocator}    Run Keyword If    ${StringMatch} == ${True}    Remove String Using Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ...    ELSE    Set Variable    ${Locator}
    ${ReturnLocator}    Set Variable    xpath=(${RegexpLocator})[position()='${Position}']
    Log many    ${ReturnLocator}
    [Return]    ${ReturnLocator}

Get Row Count From Database
    [Arguments]    ${Query}
    [Documentation]    Get count value from database by sql query command
    ...
    ...    *Format keyword*
    ...
    ...    ${CountRow} | Get Row Count From Database | ${QueryCommand}
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    database='${AISTHESTARTUP_NAME_DB}', user='${AISTHESTARTUP_USERNAME_DB}', password='${AISTHESTARTUP_PASSWORD_DB}', host='${AISTHESTARTUP_HOST_DB}', port=${AISTHESTARTUP_PORT_DB},charset='utf8mb4'
    Log Many    ${Query}
    ${CountRow}    DatabaseLibrary.Row Count    ${Query}
    ${CountRow}    Convert To String    ${CountRow}
    [Teardown]    DatabaseLibrary.Disconnect From Database
    [Return]    ${CountRow}

Get Web Text
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Get text by returns the text value of element.
    ...
    ...    *Format keyword*
    ...
    ...    Get Web Text | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Comment    ${Text}    Selenium2Library.Get Text    ${Locator}
    ${Text}    Wait Until Keyword Succeeds    5    1    Selenium2Library.Get Text    ${Locator}
    [Return]    ${Text}

Get Web Value
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Get value by returns the value of element.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Get Web Value | ${Locator} | ${Timeout}=${General_TimeOut}
    Comment    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Comment    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    ${result}    BuiltIn.Run Keyword And Return Status    Wait Until Element Is Not Visible    xpath=//div[@id='loading']    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Run Keywords    Wait Until Keyword Succeeds    5x    1s    Selenium2Library.Wait Until Element Is Visible
    ...    ${Locator}
    ...    AND    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    #sleep for value visible
    Sleep    1
    ${valueActual}    Selenium2Library.Get Value    ${Locator}
    [Return]    ${valueActual}

Input Web Text
    [Arguments]    ${Locator}    ${Text}    ${Timeout}=${General_TimeOut}
    [Documentation]    input text into text field identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Input Web Text | ${Locator} | ${Text} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Comment    Selenium2Library.Input Text    ${Locator}    ${Text}
    Wait Until Keyword Succeeds    5x    1s    Selenium2Library.Input Text    ${Locator}    ${Text}

Open Firefox Profile Browser
    [Arguments]    ${URL}    # | ${FirefoxProfilePath}
    [Documentation]    Open Firefox Profile Browser
    ...    Keyword Require profile firefox url
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Open Firefox Profile Browser | ${Url}
    ${IndexOfFolderList}=    Convert To Integer    2
    ${fileType}=    Create List    "application/msword"    #.doc_Microsoft Word 1997-2003
    Append To List    ${fileType}    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"    #.docx_Microsoft Word 2007
    Append To List    ${fileType}    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"    #.xlsx_Microsoft Excel 2007
    Append To List    ${fileType}    "application/vnd.ms-excel"    #.xls_Microsoft Excel < 2007
    Append To List    ${fileType}    "application/vnd.ms-powerpoint"    #.ppt_Microsoft PowerPoint < 2007
    Append To List    ${fileType}    "application/vnd.openxmlformats-officedocument.presentationml.presentation"    #.pptx_Microsoft PowerPoint 2007
    Append To List    ${fileType}    "application/vnd.visio"    #.vsd_Microsoft Visio
    Append To List    ${fileType}    "application/pdf"    #pdf
    Append To List    ${fileType}    "image/jpeg"    #jpeg JPEG images
    Append To List    ${fileType}    "image/png"    #png Portable Network Graphics
    Append To List    ${fileType}    "text/plain"    #txt
    Append To List    ${fileType}    "application/x-7z-compressed"    #.7zip \    7-zip archive
    Append To List    ${fileType}    "application/zip"    #.zip
    Append To List    ${fileType}    "application/octet-stream"    #.zip,.rar
    Append To List    ${fileType}    "application/json"    # JSON Type
    Append To List    ${fileType}    "application/force-download"
    ${types}=    Evaluate    ', '.join(${fileType})
    log    ${types}
    #
    ${firefoxProfile}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxProfile()    sys
    Call Method    ${firefoxProfile}    set_preference    browser.helperApps.alwaysAsk.force    ${False}
    Call Method    ${firefoxProfile}    set_preference    browser.download.manager.showWhenStarting    ${False}
    Call Method    ${firefoxProfile}    set_preference    browser.download.folderList    ${IndexOfFolderList}
    # Comment For wait download
    Comment    Call Method    ${firefoxProfile}    set_preference    browser.download.dir    ${Repository_Path}${Downloads_Folder}    #C:\\CreateProfileByPython
    Call Method    ${firefoxProfile}    set_preference    browser.helperApps.neverAsk.saveToDisk    ${types}
    Call Method    ${firefoxProfile}    set_preference    browser.download.manager.showWhenStarting    ${False}
    Call Method    ${firefoxProfile}    set_preference    pdfjs.disabled    ${True}
    Call Method    ${firefoxProfile}    set_preference    plugin.scan.plid.all    ${False}
    Call Method    ${firefoxProfile}    set_preference    plugin.scan.Acrobat    99.0
    # Set proxy
    Call Method    ${firefoxProfile}    set_preference    network.proxy.type    ${1}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.http    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.http_port    ${2520}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.socks    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.socks_port    ${2520}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ssl    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ssl_port    ${2520}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ftp    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ftp_port    ${2520}
    Comment    Call Method    ${firefoxProfile}    set_preference    browser.link.open_newwindow    ${0}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.no_proxies_on    localhost,test-ebill.ais.co.th,test-procurementws.ais.co.th,test-ehrportal.ais.co.th,test-procurement.ais.co.th,10.137.16.41,stg-ikmengine.intra.ais
    Call Method    ${firefoxProfile}    set_preference    layout.css.devPixelsPerPx    1
    ####
    Create Webdriver    Firefox    firefox_profile=${firefoxProfile}
    Go To    ${URL}
    ${SETWINDOWSITE}    BuiltIn.Get Variable Value    ${SETWINDOWSITE}    FALSE
    ${SETWINDOWSITE}    Convert To Uppercase    ${SETWINDOWSITE}
    BuiltIn.Run Keyword If    '${SETWINDOWSITE}' == 'True'    Selenium2Library.Set Window Size    ${WINDOWWIDTH}    ${WINDOWHEIGHT}
    ...    ELSE    Selenium2Library.Maximize Browser Window

Open Web Browser
    [Arguments]    ${Url}    ${Browser}    # ${browser} Example ff , gc , ie
    [Documentation]    Open browser to URL
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Open Web Browser | ${Url} | ${Browser}
    Run Keyword If    '${Browser}' == 'ff'    Selenium2Library.Open Browser    ${Url}    ${Browser}
    ...    ELSE IF    '${Browser}' == 'ie'    Selenium2Library.Open Browser    ${Url}    ${Browser}
    ...    ELSE IF    '${Browser}' == 'gc'    Selenium2Library.Open Browser    ${Url}    ${Browser}
    BuiltIn.Run Keyword If    '${SETWINDOWSITE}' == 'True'    Set Web Window Size    ${WINDOWHEIGHT}    ${WINDOWWIDTH}
    ...    ELSE    Selenium2Library.Maximize Browser Window

Select From Web List
    [Arguments]    ${Locator}    ${Text}    ${Timeout}=${General_TimeOut}
    [Documentation]    Select items from dropdownlist identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Select From Web List | ${Locator} | ${Text} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Select From List    ${Locator}    ${Text}

Select From Web List By Index
    [Arguments]    ${Locator}    ${Index}    ${Timeout}=${General_TimeOut}
    Web Element Should Be Visible    ${Locator}    ${Timeout}
    Wait Until Keyword Succeeds    5    1    Selenium2Library.Select From List By Index    ${Locator}    ${Index}

Select From Web List By Label
    [Arguments]    ${Locator}    ${Label}    ${Timeout}=${General_TimeOut}
    [Documentation]    Select item by using label from dropdownlist identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Select From Web List By Label | ${Locator} | ${Label} | ${Timeout}=${General_TimeOut}
    Web Element Should Be Visible    ${Locator}    ${Timeout}
    Wait Until Keyword Succeeds    5    1    Selenium2Library.Select From List By Label    ${Locator}    ${Label}

Select From Web List By Value
    [Arguments]    ${Locator}    ${Value}    ${Timeout}=${General_TimeOut}
    [Documentation]    Select item by using value from dropdownlist identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Select From Web List By Value | ${Value} | ${Label} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Select From List By Value    ${Locator}    ${Value}

Set Web Window Size
    [Arguments]    ${Width}    ${Higth}
    [Documentation]    Set Web Window Size
    ...    The keyword set Size screen website support if keyword maximize window not work
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Set Web Window Size | ${Width} | ${Higth}
    Selenium2Library.Set Window Size    ${Width}    ${Higth}
    Selenium2Library.Set Window Position    0    0

Split Equal String
    [Arguments]    ${String}
    [Documentation]    The keyword Split Equal String split string from = and strip string
    ...
    ...    **Example**
    ...
    ...    ${Variable} ${Data} Split Equal String ${String}
    ...    ${Variable} ${Data} Split Equal String ${String}
    ${Status}    BuiltIn.Run Keyword And Return Status    BuiltIn.Should Contain    ${String}    =
    BuiltIn.Run Keyword If    ${Status} == ${False}    log    Fail    Split string error fine = not found
    ${pre}    ${post}    String.Split String    ${String}    =    1
    ${pre}    Strip String    ${pre}
    ${post}    Strip String    ${post}    mode=left
    [Return]    ${pre}    ${post}

Unzip File
    [Arguments]    ${PathZipFile}    ${ExtractTo}
    [Documentation]    Keyword Unzip File Will wait ZipFile download success and Extract File to Path
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Unzip File | ${PathZipFile} | ${ExtractTo}
    ...
    ...    1. ${PathZipFile} =D:\\FileDevPortal\\Test.zip
    ...    2. ${ExtractTo} = D:\\FileDevPortal\\Test
    OperatingSystem.Wait Until Created    ${PathZipFile}
    BuiltIn.Wait Until Keyword Succeeds    10x    1s    OperatingSystem.File Should Exist    ${PathZipFile}
    ArchiveLibrary.Extract Zip File    ${PathZipFile}    dest=${ExtractTo}

Upload File
    [Arguments]    ${Locator}    ${FileName}    ${Path}=${CURDIR}\\..\\PageFile\\
    [Documentation]    "Locator" is Locator of Button which will be clicked for uploading file
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Upload File | ${Locator} | ${FileName}
    Click Web Element    ${Locator}
    ${PathUploadFile}    Set Variable    ${Path}${FileName}
    Wait Until Keyword Succeeds    5x    1s    Control Set Text    strTitle=File Upload    strText=    strControl=Edit1
    ...    strControlText=${PathUploadFile}
    Sleep    1s
    Control Click    strTitle=File Upload    strText=    strControl=Button1    strButton=LEFT    nNumClicks=1
    Sleep    1s
    ${State}    Win Get State    strTitle=File Upload    strText=
    log    ${State}
    BuiltIn.Run Keyword If    ${State} != 0    BuiltIn.Fail    File cannot be upload.

Verify CheckBox
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verify CheckBox identified by locator is selected or checked.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify CheckBox | ${Locator} | ${Flag}
    ...
    ...    ${Flag} = True
    ...    ${Flag} = False
    Comment    ${Flag}    Convert To Uppercase    ${Flag}
    Comment    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Variable flag must be only either True(true) or False(false).
    Comment    BuiltIn.Run Keyword If    '${Flag}' == 'TRUE'    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    ...    ELSE    Checkbox Should Not Be Selected    ${Locator}
    ${Flag}    Convert To Uppercase    ${Flag}
    ${SearchNot}    Evaluate    re.search(r"NOT","${Flag}")    re
    ${Flag}    Remove String    ${Flag}    NOT${Space}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Flag is wrong format.
    ${Flag}    Convert To Boolean    ${Flag}
    ${Boolean}    Set Variable If    '${SearchNOT}' != 'None'    not ${Flag}    '${SearchNOT}' == 'None'    ${Flag}
    ${Flag}    Evaluate    bool(${Boolean})
    BuiltIn.Run Keyword If    '${Flag}' == 'True'    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    ...    ELSE    Selenium2Library.Checkbox Should Not Be Selected    ${Locator}

Verify Database
    [Arguments]    @{input}
    [Documentation]    *Format keyword*
    ...
    ...    Verify Database | @{input}
    ...
    ...    @{input} = selectStatement, row, expectedValue
    ...    - selectStatement : Required. Uses the input `selectStatement` to query for the values
    ...    - row : Optional. (Default = 1)
    ...    - expectedValue : Required.
    DatabaseLibrary.Connect To Database Using Custom Params    pymysql    database='${AISTHESTARTUP_NAME_DB}', user='${AISTHESTARTUP_USERNAME_DB}', password='${AISTHESTARTUP_PASSWORD_DB}', host='${AISTHESTARTUP_HOST_DB}', port=${AISTHESTARTUP_PORT_DB},charset='utf8mb4'
    : FOR    ${i}    IN RANGE    0    5
    \    ${lengthList} =    BuiltIn.Get Length    ${input}
    \    @{resultQuery} =    DatabaseLibrary.Query    @{input}[0]
    \    ${row} =    BuiltIn.Run Keyword If    ${lengthList} == 3    Evaluate    @{input}[1] - 1
    \    @{result} =    BuiltIn.Set Variable If    ${lengthList} == 3    @{resultQuery}[${row}]    @{resultQuery}[0]
    \    ${ExpectedValue}    BuiltIn.Set Variable If    ${lengthList} == 3    @{input}[2]    @{input}[1]
    \    Comment    ${Status}    BuiltIn.Run Keyword And Return Status    Decode Bytes To String    @{result}[0]    iso-8859-11
    \    Comment    ${ResultActualInDB}    Run Keyword If    '${Status}'=='True'    Decode Bytes To String    @{result}[0]
    \    ...    iso-8859-11
    \    ...    ELSE    Set Variable    @{result}[0]    #Decode Thai Language
    \    Comment    ${ResultActualInDB}    BuiltIn.Convert To String    ${ResultActualInDB}
    \    Comment    ${StatusNone}    BuiltIn.Run Keyword And Return Status    Should Match Regexp    ^None$    ${ResultActualInDB}
    \    Comment    ${ResultActualInDB}    Set Variable If    ${StatusNone} == ${True}    ${EMPTY}    ${ResultActualInDB}
    \    ...    # Set result to ${EMPTY} if equal 'None'
    \    Comment    ${Status}    BuiltIn.Run Keyword And Return Status    BuiltIn.Should Be Equal    ${ResultActualInDB}    ${ExpectedValue}
    \    ${ResultActualInDB}    Set Variable    @{result}[0]
    \    ${Type}    Evaluate    type($ResultActualInDB)
    \    log    ${ResultActualInDB}
    \    Comment    ${ResultActualInDB}    Run Keyword If    "${Type}" == "<type 'str'>"    Evaluate    ord("${ResultActualInDB}")
    \    ...    ELSE    Set Variable    ${ResultActualInDB}
    \    Sleep    1s
    \    ${ResultActualInDB}    Run Keyword And Ignore Error    Run Keyword If    "${Type}" == "<type 'str'>"    Evaluate    ord("${ResultActualInDB}")
    \    ...    ELSE    Set Variable    ${ResultActualInDB}
    \    ${ResultActualInDB} =    BuiltIn.Set Variable If    '@{ResultActualInDB}[0]' == 'FAIL'    0    @{ResultActualInDB}[1]
    \    log    ${i}
    \    ${Status}    BuiltIn.Run Keyword And Return Status    BuiltIn.Should Be Equal As Strings    ${ResultActualInDB}    ${ExpectedValue}
    \    BuiltIn.Exit For Loop If    '${Status}' == 'True'
    Run Keyword If    '${Status}'=='False'    Fail    '${ResultActualInDB}' != '${ExpectedValue}'
    [Teardown]    DatabaseLibrary.Disconnect From Database

Verify Directory Should Exist
    [Arguments]    ${Path}
    [Documentation]    Name:
    ...    Directory Should Exist
    ...    Arguments:
    ...    [ path | msg=None ]
    ...    Fails unless the given path points to an existing directory.
    ...    The path can be given as an exact path or as a glob pattern. The pattern matching syntax is explained in `introduction`. The default error message can be overridden with the msg argument.
    BuiltIn.Wait Until Keyword Succeeds    5x    1s    OperatingSystem.Directory Should Exist    ${Path}

Verify DropdownList
    [Arguments]    ${Locator}    ${ExpectedAllItem}
    [Documentation]    Verify DropdownList Compare value in Dropdown List of actual with expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify DropdownList | ${Locator} | ${ExpectedAllItem}
    Comment    ${AutualListAllItemTemp}    Get Web Text    ${Locator}
    Comment    @{AutualListAllItem}    Split String    ${AutualListAllItemTemp}    \n
    Comment    ${ActualCountAllItem}    BuiltIn.Get Length    ${AutualListAllItem}
    Comment    @{ExpectedListAllItem}    String.Split String    ${ExpectedAllItem}    ,
    Comment    ${ExpectedCountAllItem}    BuiltIn.Get Length    ${ExpectedListAllItem}
    Comment    BuiltIn.Should Be Equal    ${ActualCountAllItem}    ${ExpectedCountAllItem}
    Comment    : FOR    ${i}    IN RANGE    0    ${ExpectedCountAllItem}
    Comment    \    log    ${i}
    Comment    \    log    @{AutualListAllItem}[${i}]
    ${count}    Set Variable    0
    @{AllItem}    Get List Items    ${Locator}
    : FOR    ${ListValue}    IN    @{AllItem}
    \    @{ExpectedListAllItem}    String.Split String    ${ExpectedAllItem}    ,
    \    Should Be Equal As Strings    @{ExpectedListAllItem}[${count}]    ${ListValue}
    \    ${count}    Evaluate    ${count}+1

Verify Enable
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verify element enable identified by locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Enable | ${Locator} | ${Flag}
    ...
    ...    ${Flag} = True
    ...    ${Flag} = False
    ${Flag}    Convert To Uppercase    ${Flag}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Variable flag must be only either True(true) or False(false).
    BuiltIn.Run Keyword If    '${Flag}' == 'TRUE'    Element Should Be Enabled    ${Locator}
    ...    ELSE    Element Should Be Disabled    ${Locator}

Verify File Name In Directory
    [Arguments]    ${FileName}    ${Path}=${PathDownloadFile}
    [Documentation]    Verify FileName in Directory keyword if get file name from directory compare filename expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify FileName In Directory | ${FileName} | ${Path}=${PathDownloadFile}
    BuiltIn.Wait Until Keyword Succeeds    5x    1s    OperatingSystem.File Should Exist    ${Path}${FileName}
    @{ListFile}    OperatingSystem.List Files In Directory    ${Path}    ${FileName}
    BuiltIn.Should Be Equal    @{ListFile}[0]    ${FileName}
    [Teardown]    # Delete File In Directory    ${FileName}

Verify Length
    [Arguments]    ${Locator}    ${LengthExpect}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify length by return length value of element and compare value of actual with expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify length | ${Locator} | ${LengthExpect} | ${Timeout}=${General_TimeOut}
    Comment    ${textActual} =    Selenium2Library.Get Text    ${Locator}
    ${Text}    Get Web Value    ${Locator}
    ${Count}    BuiltIn.Get Length    ${Text}
    ${Count}    BuiltIn.Convert To Integer    ${Count}
    ${lengthExpect}    BuiltIn.Convert To Integer    ${LengthExpect}
    BuiltIn.Should Be Equal    ${lengthExpect}    ${Count}

Verify Placeholder
    [Arguments]    ${Locator}    ${Expect}    ${Timeout}=${General_TimeOut}
    [Documentation]    Get placeholder of element and verify by compare between actual value and expected value.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Placeholder | ${Locator} | ${Expect} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    ${valueActual}    Selenium2Library.Get Element Attribute    ${Locator}@placeholder
    BuiltIn.Should Be Equal    ${valueActual}    ${Expect}

Verify Radio
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verifies Radio that element identified with `locator` is select or isn't select.
    ...
    ...    *Format keyword*
    ...
    ...    Verify Radio | ${Locator} | ${Flag}
    ...
    ...    *flag* can be as follows:
    ...    - True (means that locator is selected.)
    ...    - False (means that locator is not selected.)
    ...    - Not True (means that locator is not selected.)
    ...    - Not False (means that locator is selected.)
    ${Flag}    Convert To Uppercase    ${Flag}
    ${SearchNot}    Evaluate    re.search(r"NOT","${Flag}")    re
    ${Flag}    Remove String    ${Flag}    NOT${Space}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Flag is wrong format.
    ${Flag}    Convert To Boolean    ${Flag}
    ${Boolean}    Set Variable If    '${SearchNOT}' != 'None'    not ${Flag}    '${SearchNOT}' == 'None'    ${Flag}
    ${Flag}    Evaluate    bool(${Boolean})
    BuiltIn.Run Keyword If    '${Flag}' == 'True'    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    ...    ELSE    Checkbox Should Not Be Selected    ${Locator}

Verify Text
    [Arguments]    ${Locator}    ${Text}
    [Documentation]    Keyword will Get Text if text not found will keyword try get value com pare expect
    ...    Because Element have some one text or value
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Text | ${Locator} | ${Text}
    #Edit Performance 03/07/2017
    Web Element Should Be Visible    ${Locator}
    ${TextActual}    Wait Until Keyword Succeeds    5    1    Selenium2Library.Get Text    ${Locator}
    ${Temp}    Remove String    ${TextActual}    ${SPACE}
    ${Temp}    Get Length    ${Temp}    #count length because if not support special charector
    ${TextActual}    Run Keyword If    '${Temp}' == '0'    Selenium2Library.Get Value    ${Locator}
    ...    ELSE    Set Variable    ${TextActual}
    Should Be Equal    ${TextActual}    ${Text}
    log    ${TextActual} == ${Text}
    [Teardown]    Capture Page Screenshot

Verify Visible
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verifies Visible that element identified with `locator` is visible or isn't visible.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Visible | ${Locator} | ${Flag}
    ...
    ...    *flag* can be as follows:
    ...    - True (means that locator is visible.)
    ...    - False (means that locator is not visible.)
    ${Flag}    Convert To Uppercase    ${Flag}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Variable flag must be only either True(true) or False(false).
    BuiltIn.Run Keyword If    '${Flag}' == 'TRUE'    Web Element Should Be Visible    ${Locator}
    ...    ELSE    Web Element Should Be Not Visible    ${Locator}
    [Teardown]    Selenium2Library.Capture Page Screenshot

Wait Web Until Page Contains Element
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Wait until element appears on current page.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Wait Web Until Page Contains Element | ${Locator} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Page Contains Element    ${Locator}    ${Timeout}

Web Element Focus
    [Arguments]    ${Locator}    ${Index}=None    ${Timeout}=${General_TimeOut}
    [Documentation]    Focus to the element on web identified by locator.
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Focus | ${Locator} | ${Index}=None | ${Timeout}=${General_TimeOut}
    ...
    ...    - Locator can support id=XXXXXXXXXXX format or xpath format
    Comment    ${Locator}    Run Keyword If    '${Index}' != 'None'    Get Full Xpath    ${Locator}    ${Index}
    ...    ELSE    Set Variable    ${Locator}
    Comment    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Comment    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Comment    BuiltIn.sleep    500ms
    Comment    Comment    Selenium2Library.Scroll Element Into View    ${Locator}
    Comment    Comment    Selenium2Library.Execute Javascript    scrollBy(0,-150);
    Comment    Comment    Selenium2Library.Execute Javascript    $("[${Locator}]")[0].scrollIntoView();    scrollBy(0,-150);
    Comment    ${Locator}    Remove String Using Regexp    ${Locator}    (i?)xpath=
    Comment    log    ${Locator}
    Comment    log    window.document.evaluate("${Locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    Comment    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Execute Javascript    $("[${Locator}]")[0].scrollIntoView();    #id Format
    Comment    BuiltIn.Run Keyword If    '${result}'=='False'    Selenium2Library.Execute Javascript    window.document.evaluate("${Locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);    #xpath Format
    Comment    Selenium2Library.Execute Javascript    scrollBy(0,-300);
    Comment    BuiltIn.sleep    1s

Web Element Get Matching Xpath Count
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Returns number of elements matching by xpath
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Get Matching Xpath Count | ${Locator} | ${Timeout}=${General_TimeOut}
    Web Element Should Be Visible    ${Locator}    ${Timeout}
    ${Count}    Selenium2Library.Get Matching Xpath Count    ${Locator}
    [Return]    ${Count}

Web Element Mouse Over
    [Arguments]    ${Locator}    ${Index}=None    ${Timeout}=${General_TimeOut}
    [Documentation]    Simulates hovering mouse over to the element
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Mouse Over | ${Locator} | ${Timeout}=${General_TimeOut}
    ${Locator}    Run Keyword If    '${Index}' != 'None'    Get Full Xpath    ${Locator}    ${Index}
    ...    ELSE    Set Variable    ${Locator}
    ${Result}    BuiltIn.Run Keyword And Return Status    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Web Scroll Element Into View    ${Locator}
    Selenium2Library.Mouse Over    ${Locator}

Web Element Should Be Disabled
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that element is disabled.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Disabled | ${Locator} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Element Should Be Disabled    ${Locator}

Web Element Should Be Enabled
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that element is enabled.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Enabled | ${Locator} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Element Should Be Enabled    ${Locator}

Web Element Should Be Not Visible
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that element is not visible.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Not Visible | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    Run Keyword And Return Status    Element Should Not Be Visible    ${Locator}
    Run Keyword If    ${result} == ${False}    Wait Until Element Is Not Visible    ${Locator}    ${Timeout}

Web Element Should Be Visible
    [Arguments]    ${Locator}    ${Timeout}=5s
    [Documentation]    Verify that the element is visible.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Visible | ${Locator} | ${Timeout}=${General_TimeOut}
    Comment    Run Keyword And Return Status    Wait Until Page Contains Element    ${Locator}    ${Timeout}
    ${result}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Locator}    ${Timeout}
    ${result}    Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Element Should Be Visible    ${Locator}
    Comment    Run Keyword If    '${result}'=='False'    Selenium2Library.Element Should Be Visible    ${Locator}    ${Timeout}

Web Element Text Should Be
    [Arguments]    ${Locator}    ${Text}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify element exactly contains text is expected.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Text Should Be | ${Locator} | ${Text} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Wait Until Element Contains    ${Locator}    ${Text}    ${Timeout}
    Selenium2Library.Element Text Should Be    ${Locator}    ${Text}
    Capture Page Screenshot

Web Get Elements
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Return list of web element objects.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Get Elements | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    ${elements}    Selenium2Library.Get Webelements    ${Locator}
    [Return]    ${elements}

Web Scroll Element Into View
    [Arguments]    ${Locator}
    [Documentation]    The Keyword Support Click web Element
    ...
    ...    doing work scroll element if element is missing or hide in the tab
    #calculate element before focus
    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    ${windowWidth}    ${windowHeight}    Get Window Size
    #Calculate Center Height Element
    ${X}    ${Y}    Get Element Size    ${Locator}
    ${HeightCenterElement}    Evaluate    ${Y}/2
    ${heightElement}    Get Vertical Position    ${Locator}
    ${heightElement}    Evaluate    ${heightElement}+${HeightCenterElement}
    #Calculate Current Position Element
    ${CalPosition}    Evaluate    ${heightElement}-${windowPosition}
    Comment    ${tmpCalPosition}    Set Variable    ${CalPosition}
    #Calculate Window Position and delete position Taskbar
    ${CalWindowPosition}    Evaluate    ${windowHeight}-110
    ${StringMatch}    Run Keyword And Return Status    Should Match Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ${RegexpLocator}    Run Keyword If    ${StringMatch} == ${True}    Remove String Using Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ...    ELSE    Set Variable    ${Locator}
    comment    ${RegexpLocator}    Remove String Using Regexp    ${Locator}    (i?)xpath=
    #Check focus element
    BuiltIn.Run Keyword If    ${CalPosition} < 140 or ${CalPosition} > ${CalWindowPosition}    Selenium2Library.Execute Javascript    window.document.evaluate("${RegexpLocator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    #calculate element after focus
    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    ${CalPosition}    Evaluate    ${heightElement}-${windowPosition}
    : FOR    ${i}    INRANGE    0    99
    \    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    \    ${beforeCalPosition}    Evaluate    ${heightElement}-${windowPosition}
    \    Exit For Loop If    ${beforeCalPosition} > 140
    \    Selenium2Library.Execute Javascript    scrollBy(0,-100);
    \    Comment    ${windowPosition}    Selenium2Library.Execute Javascript    return $(window).scrollTop();
    \    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    \    ${afterCalPosition}    Evaluate    ${heightElement}-${windowPosition}
    \    Exit For Loop If    ${beforeCalPosition} == ${afterCalPosition}

Web Select Checkbox
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Selects checkbox identified by locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Select Checkbox | ${Locator} | ${Timeout}=${General_TimeOut}
    ${StringMatch}    Run Keyword And Return Status    BuiltIn.Should Match Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ${Locator}    Run Keyword If    ${StringMatch} == ${True}    Remove String Using Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ...    ELSE    Set Variable    ${Locator}
    Sleep    3    wait for element
    @{listLocator}    Get Webelements    ${Locator}
    ${CheckboxStatus}    BuiltIn.Set Variable    ${EMPTY}
    ${SelectCheckboxStatus}    BuiltIn.Set Variable    ${EMPTY}
    : FOR    ${Locator}    IN    @{listLocator}
    \    ${SelectCheckboxStatus}    BuiltIn.Run Keyword If    '${SelectCheckboxStatus}' != '${True}'    BuiltIn.Run Keyword And Return Status    Selenium2Library.Select Checkbox    ${Locator}
    \    ...    ELSE    BuiltIn.Set Variable    ${SelectCheckboxStatus}
    \    ${Status}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    \    BuiltIn.Exit For Loop If    ${Status} == ${True}
    : FOR    ${Locator}    IN    @{listLocator}
    \    ${CheckboxStatus}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    \    BuiltIn.Exit For Loop If    ${CheckboxStatus} == ${True}

Web Unselect CheckBox
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Removes selection of checkbox identified by locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Unselect Checkbox | ${Locator} | ${Timeout}=${General_TimeOut}
    ${StringMatch}    Run Keyword And Return Status    BuiltIn.Should Match Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ${Locator}    Run Keyword If    ${StringMatch} == ${True}    Remove String Using Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ...    ELSE    Set Variable    ${Locator}
    Comment    : FOR    ${i}    INRANGE    0    4
    Comment    \    ${Status}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Execute Javascript    window.document.evaluate("${Locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.checked = false;
    Comment    \    BuiltIn.Run Keyword If    ${Status} == ${False}    Selenium2Library.Click Element    ${Locator}
    Comment    \    ${ChkStatus}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Checkbox Should Not Be Selected    ${Locator}
    Comment    \    Exit For Loop If    ${ChkStatus} == ${True}
    @{listLocator}    Get Webelements    ${Locator}
    ${CheckboxStatus}    BuiltIn.Set Variable    ${EMPTY}
    ${SelectCheckboxStatus}    BuiltIn.Set Variable    ${EMPTY}
    : FOR    ${Locator}    IN    @{listLocator}
    \    ${SelectCheckboxStatus}    BuiltIn.Run Keyword And Return Status    Checkbox Should Not Be Selected    @{listLocator}[0]
    \    ${SelectCheckboxStatus}    BuiltIn.Run Keyword If    '${SelectCheckboxStatus}' != '${True}'    BuiltIn.Run Keyword And Return Status    Selenium2Library.Click Element    ${Locator}
    \    ...    ELSE    BuiltIn.Set Variable    ${SelectCheckboxStatus}
    : FOR    ${Locator}    IN    @{listLocator}
    \    ${CheckboxStatus}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Checkbox Should Not Be Selected    ${Locator}
    \    BuiltIn.Exit For Loop If    ${CheckboxStatus} == ${True}
    Run Keyword If    ${CheckboxStatus} != ${True}    Fail

Wait Until File Contains
    [Arguments]    ${ContainPath}
    [Documentation]    Example
    ...
    ...    Verify Export Excel File Require File Name and Verify contain file name in ${PATHDOWNLOADFILE} (local config)
    ...
    ...    Verify ExportToExcel File product_report_${Date}
    ...
    ...
    ...
    ...    *** Optional Keyword ***
    ...
    ...    Keywod can return full file name with contain file
    ...
    ...    ${FileName} Wait Until File Contains product_report_${Date}
    # For loop Because Waiting Create File
    : FOR    ${INDEX}    IN RANGE    1    30
    \    @{List}=    OperatingSystem.List Files In Directory    ${PATHDOWNLOADFILE}
    \    BuiltIn.Run Keyword And Return Status    log    @{List}[0]
    \    ${Status}    BuiltIn.Run Keyword And Return Status    BuiltIn.Should Contain    @{List}[0]    ${ContainPath}
    \    sleep    1
    \    Exit For Loop If    ${Status}==${True}
    Run Keyword If    ${Status} == ${False}    Fail    Fail ${ContainPath} is not contain
    ${FileName}    Set Variable    @{List}[0]
    [Return]    ${FileName}

Verify Cell Data By Name
    [Arguments]    ${ExcelFile}    ${Sheetname}    ${Cellname}    ${Expect}
    [Documentation]    Verify Excel
    ...
    ...    Verify Cell Data By Name ${ExcelFile} Proposal Worksheet A4 ${id[0][0]}
    ...    Verify Cell Data By Name ${ExcelFile} Proposal Worksheet A5 ${id[1][0]}
    ...    Verify Cell Data By Name ${ExcelFile} Proposal Worksheet A6 ${id[2][0]}
    ...    Verify Cell Data By Name ${ExcelFile} Proposal Worksheet A7 ${id[3][0]}
    ...    Verify Cell Data By Name ${ExcelFile} Proposal Worksheet A8 ${id[4][0]}
    CustomExcelXlsLibrary.Open Excel    ${PATHDOWNLOADFILE}${ExcelFile}
    ${result}    CustomExcelXlsLibrary.Read Cell Data By Name    ${Sheetname}    ${Cellname}
    # Convert Space and empty from DB to - in Excel
    ${Expect}    Set Variable If    '${Expect}' == '${EMPTY}'    -    ${Expect}
    # Check Format float
    ${typeFloat}    BuiltIn.Run Keyword And Return Status    Evaluate    isinstance(${result}, float)
    ${typeDate}    BuiltIn.Run Keyword And Return Status    Should Match Regexp    ${result}    ^(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[1,3-9]|1[0-2])\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$|^(?:29(\\/|-|\\.)0?2\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9])|(?:1[0-2]))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})$
    BuiltIn.Run Keyword If    ${typeFloat}==${True} and ${typeDate} != ${True}    BuiltIn.Should Be Equal As Integers    ${result}    ${Expect}
    ...    ELSE    BuiltIn.Should Be Equal As Strings    ${result}    ${Expect}
    [Teardown]    CustomExcelXlsLibrary.Close Excel
