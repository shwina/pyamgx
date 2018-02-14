from cpython cimport bool

include "amgxc.pxi"
include "amgxconfig.pxi"

include "RC.pyx"
include "Config.pyx"
include "Resources.pyx"
include "Matrix.pyx"
include "Vector.pyx"
include "Solver.pyx"


def initialize():
    return AMGX_initialize()


def read_system(Matrix A, Vector rhs, Vector sol, fname):
    err = AMGX_read_system(
        A.mtx,
        rhs.vec,
        sol.vec,
        fname.encode())


def finalize():
    return AMGX_finalize()
