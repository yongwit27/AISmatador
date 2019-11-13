*** Settings ***
Resource          ../Resource/Keyword/Keyword.robot

*** Test Cases ***
Testcase
    Open Web Browser    http://www.google.com    ff
    sleep    2s
    Close Web Browser
