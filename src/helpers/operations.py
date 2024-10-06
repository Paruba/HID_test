import wrapper
import os
import hashlib
import ctypes

def waitforHashDirectory(library, opID:int):
    while True:
        returnCode, opRunning = wrapper.hashStatus(library, opID)
        if ((int(returnCode) != 0) or (opRunning != True)): 
            break
    print('\nHashDirectory has finished.')
    return True

def processHashes(library, directory):
    dllHashes = readhashLog(library)
    print(dllHashes)
    realHashes = md5FilesInDirectory(directory)
    print(realHashes)
    return isRealHashes(dllHashes, realHashes)


def readhashLog(library):
    dllhashes = []
    while True:
        returnCode, logLine = wrapper.hashReadNextLogLine(library)
        if (int(returnCode) == 0): 
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
    md5realhashes_lower = [md5.lower() for md5 in md5realhashes]    
    in_real_hashes = True
    for md5 in md5hashes_lower:
        if md5 not in md5realhashes_lower:
            in_real_hashes = False
    return in_real_hashes