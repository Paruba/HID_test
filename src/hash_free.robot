*** Settings ***
Library    OperatingSystem
Library    ./helpers/wrapper.py
Library    ./helpers/operations.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  ${CURDIR}${/}test_files

*** Test Cases ***
Hash Free Test
    [Documentation]    Test free memory.
    [Tags]    Directory
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    Wait For Hash Directory    ${lib}    ${op_id}
    ${is_freed}    Is Memory Free    ${lib}
    Hash Terminate   ${lib}
    Should Be True    ${is_freed}



