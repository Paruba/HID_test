*** Settings ***
Library    ./helpers/wrapper.py
Library    ./helpers/operations.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  .

*** Test Cases ***
Hash Status Test
    [Documentation]    Test the status of a hashing operation.
    [Tags]    Status
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${op_id}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${op_id}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    0

Hash Status Invalid Argument
    [Documentation]    Test the status of a hashing operation with invalid argument.
    [Tags]    Status
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${-2222222222}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${op_id}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    5

Hash Status Null Argument
    [Documentation]    Test the status of a hashing operation with null argument.
    [Tags]    Status
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${Null}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${op_id}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    6

Hash Status Not Initialized Library
    [Documentation]    Test the status of a hashing operation with no initialized library.
    [Tags]    Status
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${op_id}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Stop    ${lib}    ${op_id}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${status_code}    7