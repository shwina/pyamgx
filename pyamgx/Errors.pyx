class RC:
    OK = AMGX_RC_OK
    BAD_PARAMETERS = AMGX_RC_BAD_PARAMETERS
    UNKNOWN = AMGX_RC_UNKNOWN
    NOT_SUPPORTED_TARGET = AMGX_RC_NOT_SUPPORTED_TARGET
    NOT_SUPPORTED_BLOCKSIZE = AMGX_RC_NOT_SUPPORTED_BLOCKSIZE
    CUDA_FAILURE = AMGX_RC_CUDA_FAILURE
    THRUST_FAILURE = AMGX_RC_THRUST_FAILURE
    NO_MEMORY = AMGX_RC_NO_MEMORY
    IO_ERROR = AMGX_RC_IO_ERROR
    BAD_MODE = AMGX_RC_BAD_MODE
    CORE = AMGX_RC_CORE
    PLUGIN = AMGX_RC_PLUGIN
    BAD_CONFIGURATION = AMGX_RC_BAD_CONFIGURATION
    NOT_IMPLEMENTED = AMGX_RC_NOT_IMPLEMENTED
    LICENSE_NOT_FOUND = AMGX_RC_LICENSE_NOT_FOUND
    INTERNAL = AMGX_RC_INTERNAL


class AMGXError(Exception):
    """
    Exception class for errors returned from calls to AMGX routines.
    """
    pass


def get_error_string(err_code):
    """
    pyamgx.get_error_string(err_code)

    Return a human-readable error string corresponding to an error code.

    Parameters
    ----------
    err_code : RC
        Error code returned from call to an AMGX routine.

    Returns
    -------
    err_str : str
        Human-readable error string.
    """
    cdef char buff[1024]
    err = AMGX_get_error_string(
        err_code,
        buff, 1024)
    return buff.decode()


def check_error(err_code):
    """
    pyamgx.check_error(err_code)

    Raise `AMGXError` for non-zero values of `err_code`.

    Parameters
    ----------
    err_code : RC
        Error code returned from call to an AMGX routine.
    """
    if err_code is not RC.OK:
        raise AMGXError(get_error_string(err_code))
