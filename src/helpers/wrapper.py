#
# IMPORTANT: To load 32-bit DLL, use 32-bit Python!
#
import ctypes
import time

ReturnCodes = {
    0: 'HASH_ERROR_OK',
    1: 'HASH_ERROR_GENERAL',
    2: 'HASH_ERROR_EXCEPTION',
    3: 'HASH_ERROR_MEMORY',
    4: 'HASH_ERROR_LOG_EMPTY',
    5: 'HASH_ERROR_ARGUMENT_INVALID',
    6: 'HASH_ERROR_ARGUMENT_NULL',
    7: 'HASH_ERROR_NOT_INITIALIZED',
    8: 'HASH_ERROR_ALREADY_INITIALIZED'
}


def loadHashLibrary(libFullPath):
    try:
        lib = ctypes.cdll.LoadLibrary(libFullPath)
    except FileNotFoundError as e:
        print("Library file not found.")
        raise e
    except OSError as e:
        print("Library cannot be loaded. System will exit without calling the hash routines.")
        raise e
    except Exception as e:
        print(e)
        raise e
    else:
        print("\nLibray loaded successfully.")
        return lib


def hashInit(library):
    returnCode = library.HashInit()
    print('\nHashInit Return code: {}.'.format(ReturnCodes[returnCode]))
    return returnCode


def hashTerminate(library):
    returnCode = library.HashTerminate()
    print('\nHashTerminate Return code: {}.'.format(ReturnCodes[returnCode]))
    return returnCode  


def hashDirectory(library, directoryFullPath):
    try:
        opID = ctypes.c_size_t(0)
        returnCode = library.HashDirectory(directoryFullPath.encode('utf-8'), ctypes.byref(opID))
        # below get only first char -> not working when parameter is full path
        # returnCode = library.HashDirectory(ctypes.c_wchar_p(directoryFullPath), ctypes.byref(opID))
        print('\nHashDirectory Return code: {}, Operation ID: {}.'.format(ReturnCodes[returnCode], opID.value))
        return returnCode, int(opID.value)
    except:
        return 2

def hashReadNextLogLine(library):
    # 64 is not enough for full path
    # HASHLENGTHINBYTE = 64
    HASHLENGTHINBYTE = 256
    HashFunction = library.HashReadNextLogLine
    HashFunction.argtypes = [ctypes.POINTER(ctypes.c_char_p)]
    
    logLine = ctypes.c_char_p()
    buffer = (ctypes.c_char * (HASHLENGTHINBYTE + 1))()
    returnCode = library.HashReadNextLogLine(ctypes.byref(logLine))
    print(logLine)
    if (returnCode == 0):
        ctypes.memmove(buffer, logLine, (HASHLENGTHINBYTE + 1))
        library.HashFree(logLine)

    #When returnCode is 0 ('HASH_ERROR_OK'), buffer contains w_char array terminated by a null character
    return returnCode, buffer.value


def hashStop(library, opID):
    returnCode = library.HashStop(ctypes.c_size_t(opID))
    print('\nHashStop Return code: {}.'.format(ReturnCodes[returnCode]))
    return returnCode  


def hashStatus(library, opID):
    opRunning = ctypes.c_bool(False)

    returnCode = library.HashStatus(ctypes.c_size_t(opID), ctypes.byref(opRunning))
    return returnCode, bool(opRunning)

def hash_free(library,memory_ptr):
    if memory_ptr:
        library.HashFree(ctypes.cast(memory_ptr, ctypes.c_void_p))
        memory_ptr = None  # Mark memory as freed by setting pointer to None
    else:
        raise ValueError("Attempting to free an already freed or invalid pointer")
    
def isMemoryFree(library):
    logLine = ctypes.c_char_p()
    returnCode = library.HashReadNextLogLine(ctypes.byref(logLine))
    if (returnCode == 0):
        library.HashFree(logLine)
        try:
            test = logLine[0]  # Accessing the first byte of the memory
            return False  # If access succeeds, memory wasn't freed
        except (ValueError, TypeError):
            return True 
    return False
