*** Settings ***
Library    ./helpers/wrapper.py
Library    ./helpers/operations.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  .

*** Test Cases ***
Hash Stop Test
    [Documentation]    Test the stop function of a hashing operation.
    [Tags]    Stop
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${op_id}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${op_id}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    0

Hash Stop Invalid Argument
    [Documentation]    Test the stop function of a hashing operation with invalid argument.
    [Tags]    Stop
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${op_id}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${Empty}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    0

Hash Stop Not Initialized Library
    [Documentation]    Test the stop function of a hashing operation where is not initialized library.
    [Tags]    Stop
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${op_id}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${op_id}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    7