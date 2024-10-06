from src.helpers import wrapper
from src.helpers import fileHelper
import sys
import os
import hashlib

def waitforHashDirectory(library, opID:int):
    while True:
        returnCode, opRunning = wrapper.hashStatus(library, opID)
        if ((int(returnCode) != 0) or (opRunning != True)): 
            break
    print('\nHashDirectory has finished.')
    return True

def processHashes(library, directory):
    dllHashes = readhashLog(library)
    realHashes = md5FilesInDirectory(directory)
    return isRealHashes(dllHashes, realHashes)


def readhashLog(library):
    dllhashes = []
    while True:
        returnCode, logLine = wrapper.hashReadNextLogLine(library)
        if (int(returnCode) == 0): 
            print(logLine)
            dllhashes.append(extrachHash(logLine))
        else:
            break
    return dllhashes

def readNotInitializedHasLog(library):
    returnCode = 0
    while True:
        returnCode, logLine = wrapper.hashReadNextLogLine(library)
        if (int(returnCode) != 0):
            break
    return returnCode

def extrachHash(log_line):
    decoded_output = log_line.decode('utf-8')
    hash_value = decoded_output.split()[-1]
    return hash_value

def md5FilesInDirectory(directory_path):
    file_hashes = []
    for file in os.listdir(directory_path):
        file_path = os.path.join(directory_path, file)
        if os.path.isfile(file_path):
            file_hashes.append(md5File(file_path))
    
    return file_hashes

def md5File(file_path):
    md5_hash = hashlib.md5()
    with open(file_path, "rb") as file:
        for chunk in iter(lambda: file.read(4096), b""):
            md5_hash.update(chunk)
    return md5_hash.hexdigest()

def isRealHashes(md5hashes, md5realhashes):
    md5hashes_lower = [md5.lower() for md5 in md5hashes]
    print("*** dll")
    print(md5hashes_lower)
    md5realhashes_lower = [md5.lower() for md5 in md5realhashes]   
    print("*** real")
    print(md5realhashes_lower) 
    in_real_hashes = True
    for md5 in md5hashes_lower:
        if md5 not in md5realhashes_lower:
            in_real_hashes = False
    return in_real_hashes

if __name__ == "__main__":

    try: 
        lib = wrapper.loadHashLibrary("/Users/petrparoubek/Projects/HID_test/bin/mac/libhash.dylib")
        wrapper.hashInit(lib)
        fileHelper.createLargeFile("/Users/petrparoubek/Projects/HID_test/src/large_files")
        returnCode, ID = wrapper.hashDirectory(lib, "/Users/petrparoubek/Projects/HID_test/src/large_files")
        if (returnCode == 0):
            ret = waitforHashDirectory(lib, ID)
            if (ret):
                if processHashes(lib, "/Users/petrparoubek/Projects/HID_test/src/large_files"):
                    print("SUCCESS!!!!")
                wrapper.hashStop(lib, ID)
        wrapper.hashTerminate(lib)
    except Exception as e:
        print(e)
        sys.exit("\nSystem exited with an error condition.\n")
    else:
        sys.exit("\nSystem exited successfully.\n")