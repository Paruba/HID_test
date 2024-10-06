*** Settings ***
Library    ./helpers/wrapper.py
Resource          test_variables.resource

*** Variables ***
${DIRECTORY_PATH}  .

*** Test Cases ***
Initialize Hash Library
    [Documentation]    Test to initialize targeted library and then terminate.
    [Tags]    Init
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    Hash Init    ${lib}
    ${result_terminate}    Hash Terminate    ${lib}
    Should Be Equal As Numbers    ${result}    0

Initialize Initialized Hash Library
    [Documentation]    Test to initilize initialized library.
    [Tags]    Init
    ${lib}    Load Hash Library    ${LIB_PATH}
    ${result}    Hash Init    ${lib}
    Should Be Equal As Numbers    ${result}    0
    ${result_reinitialized}    Hash Init    ${lib}
    Should Be Equal As Numbers    ${result_reinitialized}    8
    ${result_terminate}    Hash Terminate    ${lib}