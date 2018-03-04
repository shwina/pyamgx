from cpython cimport bool

include "amgxc.pxi"
include "amgxconfig.pxi"

include "Errors.pyx"
include "Config.pyx"
include "Resources.pyx"
include "Matrix.pyx"
include "Vector.pyx"
include "Solver.pyx"


def initialize():
    AMGX_initialize()
    AMGX_initialize_plugins()


def get_api_version():
    """
    pyamgx.get_api_version()

    Return the API version of AMGX as a string.

    Returns
    -------
    version : str
        String continaing major and minor API version information.
    """
    cdef int major, minor
    err = AMGX_get_api_version(
        &major,
        &minor)
    version = '{}.{}'.format(major, minor)
    return version



def read_system(Matrix A, Vector rhs, Vector sol, fname):
    err = AMGX_read_system(
        A.mtx,
        rhs.vec,
        sol.vec,
        fname.encode())


def finalize():
    AMGX_finalize_plugins()
    AMGX_finalize()
