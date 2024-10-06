*** Settings ***
Library    ./helpers/wrapper.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  .

*** Test Cases ***
Correct Hash Terminate
    [Documentation]    Test correct way to terminate initialized and working library.
    [Tags]    Terminite
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    Hash Init    ${lib}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${result_terminate}    0

Call Termination For Already Terminated
    [Documentation]    Test terminate terminated library.
    [Tags]    Terminite
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    Hash Init    ${lib}
    ${result}    Hash Terminate    ${lib}
    ${result}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${result}    7

Terminate Not Initialized
    [Documentation]    Test terminate on not initialized library.
    [Tags]    Terminite
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${result_terminate}    7