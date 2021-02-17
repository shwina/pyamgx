import numpy as np
import cupy as cp
import scipy.sparse
import pytest
import pyamgx

class TestMatrix:

    @classmethod
    def setup_class(self):
        pyamgx.initialize()
        self.cfg = pyamgx.Config().create("")
        self.rsrc = pyamgx.Resources().create_simple(self.cfg)

    @classmethod
    def teardown_class(self):
        self.rsrc.destroy()
        self.cfg.destroy()
        pyamgx.finalize()

    def test_create_and_destroy(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.destroy()

    def test_upload(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload(
            np.array([0, 1, 3], dtype=np.int32),
            np.array([1, 0, 1], dtype=np.int32),
            np.array([1, 2, 3], dtype=np.float64))
        M.destroy()

    def test_upload_device(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload(
            cp.array([0, 1, 3], dtype=np.int32),
            cp.array([1, 0, 1], dtype=np.int32),
            cp.array([1, 2, 3], dtype=np.float64))
        M.destroy()

    def test_upload_rectangular(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload(
            np.array([0, 1, 3], dtype=np.int32),
            np.array([1, 0, 2], dtype=np.int32),
            np.array([1, 2, 3], dtype=np.float64))
        M.destroy()

    def test_upload_rectangular_device(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload(
            cp.array([0, 1, 3], dtype=np.int32),
            cp.array([1, 0, 2], dtype=np.int32),
            cp.array([1, 2, 3], dtype=np.float64))
        M.destroy()

    def test_upload_CSR(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.array([[1., 2.], [3., 4]])))
        M.destroy()

    def test_upload_CSR_device(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(cp.sparse.csr_matrix(
            scipy.sparse.csr_matrix(
                np.array([[1., 2.], [3., 4]])
            )
        ))
        M.destroy()

    def test_upload_CSR_rectangular(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.array([[1., 2., 3.], [4., 5., 6.]])))

        M.destroy()
    
    def test_upload_zero_rows(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        matrix = cp.sparse.csr_matrix(scipy.sparse.csr_matrix(np.array([[1., 2., 0.], [3., 4., 0.], [0., 0., 0.]])))
        M.upload(matrix.indptr, matrix.indices, matrix.data)
        M.destroy()

    def test_upload_CSR_zero_rows(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(cp.sparse.csr_matrix(
            scipy.sparse.csr_matrix(
                np.array([[1., 2., 0.], [3., 4., 0.], [0., 0., 0.]])
            )
        ))
        M.destroy()
    
    def test_upload_CSR_zero_rows(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(cp.sparse.csr_matrix(
            scipy.sparse.csr_matrix(
                np.array([[1., 2., 0.], [3., 4., 0.], [0., 0., 0.]])
            )
        ))
        M.destroy()
        
    def test_upload_CSR_singular(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.zeros([3, 3], dtype=np.float64)))
        M.destroy()

    def test_get_sizes(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload(
            np.array([0, 1, 3], dtype=np.int32),
            np.array([1, 0, 1], dtype=np.int32),
            np.array([1, 2, 3], dtype=np.float64))
        n, block_dims = M.get_size()
        assert(n == 2)
        assert(block_dims == (1, 1))
        M.destroy()

    def test_get_nnz(self):
        import scipy.sparse
        M = pyamgx.Matrix().create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.array([[0., 1.], [2., 3.]])))
        assert(M.get_nnz() == 3)
        M.destroy()

    def test_replace_coefficients(self):
        import scipy.sparse
        M = pyamgx.Matrix().create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.array([[0., 1.], [2., 3.]])))
        M.replace_coefficients(
            np.array([1., 0., 3.]))
        M.destroy()

    def test_replace_coefficients_device(self):
        import scipy.sparse
        M = pyamgx.Matrix().create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.array([[0., 1.], [2., 3.]])))
        M.replace_coefficients(
            cp.array([1., 0., 3.]))
        M.destroy()
