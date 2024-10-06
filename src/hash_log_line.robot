*** Settings ***
Library    OperatingSystem
Library    ./helpers/wrapper.py
Library    ./helpers/operations.py
Library    ./helpers/fileHelper.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  ${CURDIR}${/}test_files
${BIG_FILES_DIRECTORY}    ${CURDIR}${/}large_files
${UNCOMMON_FILES_DIRECTORY}    ${CURDIR}${/}test_bad_files

*** Test Cases ***
Read Log Line Test
    [Documentation]    Test reading log lines from the hash library.
    [Tags]    Log Line
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal As Numbers    ${result}    0
    Wait For Hash Directory    ${lib}    ${op_id}
    ${process_hashes_result}    Process Hashes    ${lib}    ${DIRECTORY_PATH}
    Should Be Equal    ${process_hashes_result}    True
    Hash Terminate   ${lib}

Not Initialized Library For Read Log Line Test
    [Documentation]    Test reading log lines from the hash library which is not initialized.
    [Tags]    Log Line
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${DIRECTORY_PATH}
    Wait For Hash Directory    ${lib}    ${op_id}
    ${status}    Read Not Initialized Has Log    ${lib}
    Hash Terminate   ${lib}
    Should Be Equal As Numbers    ${status}    7

Read Log Line For Large File
    [Documentation]    Test reading big files from the hash library.
    [Tags]    Log Line
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${BIG_FILES_DIRECTORY}
    Should Be Equal As Numbers    ${result}    0
    Create Large File   ${BIG_FILES_DIRECTORY}
    Wait For Hash Directory    ${lib}    ${op_id}
    ${process_hashes_result}    Process Hashes    ${lib}    ${BIG_FILES_DIRECTORY}
    Hash Terminate   ${lib}
    Should Be Equal    ${process_hashes_result}    True

Read Log Line For Uncommon Files
    [Documentation]    Test reading big files from the hash library.
    [Tags]    Log Line
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_init}    Hash Init    ${lib}
    ${result}    ${op_id}    Hash Directory    ${lib}    ${UNCOMMON_FILES_DIRECTORY}
    Should Be Equal As Numbers    ${result}    0
    Wait For Hash Directory    ${lib}    ${op_id}
    ${process_hashes_result}    Process Hashes    ${lib}    ${UNCOMMON_FILES_DIRECTORY}
    Hash Terminate   ${lib}
    Should Be Equal    ${process_hashes_result}    True