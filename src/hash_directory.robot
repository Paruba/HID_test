*** Settings ***
Library    ./helpers/wrapper.py
Library    ./helpers/operations.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  .

*** Test Cases ***
Hash Directory Test With Wait
    [Documentation]    Test hashing a directory and wait for the operation to complete.
    [Tags]    Directory
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    
    # Wait for Hash Directory to complete
    ${status_code}    ${op_running}    Hash Status    ${lib}    ${op_id}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Terminate   ${lib}

Not Initialized Library For Hash Directory
    [Documentation]    Test try hashing a directory and wait for the operation on not initialized library.
    [Tags]    Directory
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Wait For Hash Directory    ${lib}    ${op_id}
    Hash Terminate   ${lib}
    Should Be Equal As Numbers    ${result}    7

Null Argument Hash Directory
    [Documentation]    Test hashing a directory with null argument in function
    [Tags]    Directory
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${Null}
    Wait For Hash Directory    ${lib}    ${op_id}
    Should Be Equal As Numbers    ${result}    6

# BUG
# Hash Directory Invalid Path
#     [Documentation]    Test set full path for hash directory with invalid path
#     [Tags]    Directory
#     ${lib}    Load Hash Library    ${LIB_PATH}
#     ${result_init}    Hash Init    ${lib}
#     ${result}    ${op_id}    Hash Directory    ${lib}    /invalid/path
#     Wait For Hash Directory    ${lib}    ${op_id}
#     Hash Terminate   ${lib}
#     Should Be Equal As Numbers    ${result}    0