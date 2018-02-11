cimport numpy as np

include "amgxc.pxi"
include "amgxconfig.pxi"

include "RC.pyx"
include "Config.pyx"

def initialize():
    return AMGX_initialize()

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

    def upload(self, n, int nnz,
            np.ndarray[int, ndim=1, mode="c"] row_ptrs,
            np.ndarray[int, ndim=1, mode="c"] col_indices,
            np.ndarray[double, ndim=1, mode="c"] data,
            block_dims=[1, 1]):

        cdef int block_dimx, block_dimy

        block_dimx = block_dims[0]
        block_dimy = block_dims[1]

        err = AMGX_matrix_upload_all(self.mtx,
                n, nnz, block_dimx, block_dimy,
                &row_ptrs[0], &col_indices[0],
                &data[0], NULL)

    def download(self, np.ndarray[int, ndim=1, mode="c"] row_ptrs,
            np.ndarray[int, ndim=1, mode="c"] col_indices,
            np.ndarray[double, ndim=1, mode="c"] data):
        err = AMGX_matrix_download_all(self.mtx,
            &row_ptrs[0], &col_indices[0], &data[0], NULL)

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

    def upload(self, n, np.ndarray[double, ndim=1, mode="c"] data, block_dim=1):
        err = AMGX_vector_upload(self.vec, n, block_dim,
            &data[0])
    
    def download(self, np.ndarray[double, ndim=1, mode="c"] data):
        err = AMGX_vector_download(self.vec, &data[0])

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
