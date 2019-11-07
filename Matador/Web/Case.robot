*** Settings ***
Resource          ../Resource/Keyword/Keyword.robot

*** Test Cases ***
testcase
    Open Firefox Profile Browser    https://ais.matadorsuite.com/
    Click Web Element    //a[@class='btn btn-primary text-uppercase btn-matador']
    Click Web Element    ${btnIDSSignin}
    Login    yongs457    Ais#1019
    Comment    Click Web Element    //a[@class='btn btn-primary text-uppercase btn-matador']
    Click Web Element    ${btnCalendar}
    Click Web Element    ${btnLeft}
    Click Web Element    ${btnLeft}
    Input Task    1    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    2    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    3    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    4    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    5    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    6    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    7    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    8    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    9    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    10    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    11    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    12    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    13    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    14    Singularity ( Playground ) :Unit test Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    15    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    16    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    17    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    18    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    19    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    20    Singularity ( Playground ) : Create New Keyword    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    21    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    22    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    23    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    24    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    25    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    26    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    27    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    28    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    29    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    30    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    Input Task    31    Singularity ( Playground ) : Create test script    Test (automation)    8    Project=20190376    Feature=[Feature] - AIS The Start Up Automation Test
    [Teardown]    Delete Task
