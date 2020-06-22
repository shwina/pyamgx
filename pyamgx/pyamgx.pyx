include "amgxc.pxi"
include "amgxconfig.pxi"

include "utils.pyx"
include "Errors.pyx"
include "System.pyx"
include "Config.pyx"
include "Resources.pyx"
include "Matrix.pyx"
include "Vector.pyx"
include "Solver.pyx"


def initialize():
    """
    pyamgx.initialize()

    Initialize AMGX.
    """
    check_error(AMGX_initialize())
    check_error(AMGX_initialize_plugins())


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
    """
    Read linear system from a MatrixMarket file.

    Parameters
    ----------

    A : :py:class:`~pyamgx.Matrix`
    rhs : :py:class:`~pyamgx.Vector`
    sol : :py:class:`~pyamgx.Vector`
    fname : str
        Path/name of MatrixMarket file.
    """
    err = AMGX_read_system(
        A.mtx,
        rhs.vec,
        sol.vec,
        fname.encode())


def finalize():
    """
    pyamgx.finalize()

    Finalize AMGX.
    """
    check_error(AMGX_finalize_plugins())
    check_error(AMGX_finalize())
