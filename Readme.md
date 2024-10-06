# Test structure
Tests are structured based on the functions described in ```hash.h```. The goal for each function is to invoke possible error codes, test various parameters that users can set, and demonstrate the functionality of the function.

Each test includes documentation that describes the test and its expected behavior.
# How to run tests
Tests are located in the src folder. Every test requires two key paths: the library path (where the targeted .dll is located) and the directory path (the folder from which MD5 hashes will be generated). These variables are crucial for the functionality of the tests. To run the tests, follow these steps:
1. Install ```python3``` and ```pip```.
2. Install ```robot framework``` using pip like ```pip install robotframework```.
3. Set the necessary variable paths, such as ```LIB_PATH``` (in the file *test_variables.resource*) and ```DIRECTORY_PATH```.
4. Navigate to the folder containing the tests and run:
```bash
robot .
```
To run a specific test, use:
```bash
robot -t "name_of_test"
```
To run tests based on tags, use:
```bash
robot --include my_tag
```
The tests will generate ```log.html```, ```output.xml```, and ```report.html```, where you can review which tests passed, which failed, and the reasons for failure.

# Bugs in tests
## Initialize Initialized Hash Library
The function is expected to return ```8``` after a second initialization, but it returns ```0```.
## Null Argument Hash Directory
The test should return status code ```6``` from HashDirectory if the parameter is ```NULL```. Every function should return a status.
## Read Log Line Test
This test should load the library, initialize it, hash the directory, and then read the hashed files line by line, comparing them with the correct MD5 hashes. However, some hashes from the target DLL are missing ```0``` values.
## Not Initialized Library for Read Log Line Test
The expected result for this test is ```7```, which means the library is not initialized, but the test returns ```1```, which indicates a general error.
## Read Log Line for Large File
Similar to the Read Log Line Test, this test uses the HashDirectory function, which generates invalid hashes. Additionally, files larger than 4 GB may cause memory issues due to insufficient RAM.
## Read Log Line for Uncommon Files
This test faces the same issue as the previous two, where the hash function generates incorrect hashes.
## Hash Status Invalid Argument
The HashStatus function should return status ```5``` when the argument is invalid, but it returns ```0```.
## Hash Status Null Argument
The HashStatus function should return status ```6``` for a ```NULL``` argument, but it currently throws a ```TypeError```.
## Hash Status Not Initialized Library
If the library is not initialized, the test should return code ```7```, but it returns ```0```.
## Hash Stop Invalid Argument
This test should return ```5```, but it instead returns a ```TypeError```.
## Hash Stop Not Initialized Library
When the library is not initialized, the result should be ```7```, but the test returns ```0```.