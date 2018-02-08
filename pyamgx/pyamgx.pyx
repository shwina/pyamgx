include "amgxc.pxi"
include "amgxconfig.pxi"

from libc.stdint cimport uintptr_t

def initialize():
    return AMGX_initialize()

cdef class Config:

    cdef AMGX_config_handle cfg

    def create_from_file(self, param_file):
        err = AMGX_config_create_from_file(&self.cfg, param_file.encode())
        return self

    def destroy(self):
        err = AMGX_config_destroy(self.cfg)

cdef class Resources:

    cdef AMGX_resources_handle rsrc

    def create_simple(self, Config cfg):
        err = AMGX_resources_create_simple(&self.rsrc, cfg.cfg)
        return self

    def destroy(self):
        err = AMGX_resources_destroy(self.rsrc)

cdef class Matrix:

    cdef AMGX_matrix_handle mtx

    def create(self, Resources rsrc, mode):
        err = AMGX_matrix_create(&self.mtx, rsrc.rsrc, asMode(mode))
        return self

    def get_size(self):
        cdef int n, bx, by
        err = AMGX_matrix_get_size(self.mtx,
            &n, &bx, &by)
        return n, [bx, by]
    
    def destroy(self):
        err = AMGX_matrix_destroy(self.mtx)

cdef class Vector:

    cdef AMGX_vector_handle vec

    def create(self, Resources rsrc, mode):
        err = AMGX_vector_create(&self.vec, rsrc.rsrc, asMode(mode))
        return self

    def destroy(self):
        err = AMGX_vector_destroy(self.vec)

cdef class Solver:

    cdef AMGX_solver_handle slv

    def create(self, Resources rsrc, mode, Config cfg):
        err = AMGX_solver_create(&self.slv, rsrc.rsrc, asMode(mode),
            cfg.cfg)
        return self

    def destroy(self):
        err = AMGX_solver_destroy(self.slv)

    def setup(self, Matrix A):
        err = AMGX_solver_setup(
            self.slv,
            A.mtx)

    def solve(self, Vector rhs, Vector sol):
        err = AMGX_solver_solve(self.slv, rhs.vec, sol.vec)

def read_system(Matrix A, Vector rhs, Vector sol, fname):
    err = AMGX_read_system(
        A.mtx,
        rhs.vec,
        sol.vec,
        fname.encode())

def finalize():
    return AMGX_finalize()
