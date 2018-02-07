
cdef extern from "amgx_c.h":

    ctypedef enum AMGX_RC:
        AMGX_RC_OK = 0
        AMGX_RC_BAD_PARAMETERS = 1
        AMGX_RC_UNKNOWN = 2
        AMGX_RC_NOT_SUPPORTED_TARGET = 3
        AMGX_RC_NOT_SUPPORTED_BLOCKSIZE = 4
        AMGX_RC_CUDA_FAILURE = 5
        AMGX_RC_THRUST_FAILURE = 6
        AMGX_RC_NO_MEMORY = 7
        AMGX_RC_IO_ERROR = 8
        AMGX_RC_BAD_MODE = 9
        AMGX_RC_CORE = 10
        AMGX_RC_PLUGIN = 11
        AMGX_RC_BAD_CONFIGURATION = 12
        AMGX_RC_NOT_IMPLEMENTED = 13
        AMGX_RC_LICENSE_NOT_FOUND = 14
        AMGX_RC_INTERNAL = 15

    AMGX_RC AMGX_initialize()
    AMGX_RC AMGX_initialize_plugins()
    AMGX_RC AMGX_finalize()
    AMGX_RC AMGX_finalize_plugins()

def initialize():
    return AMGX_initialize()

def finalize():
    return AMGX_finalize()
