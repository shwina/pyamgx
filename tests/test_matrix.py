import sys
import numpy as np
import pytest

import pyamgx
from pyamgx import RC

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
        assert (M._err == RC.OK)
        M.destroy()
        assert (M._err == RC.OK)

    def test_upload(self):
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload(
                np.array([0, 1, 3], dtype=np.intc),
                np.array([1, 0, 1], dtype=np.intc),
                np.array([1, 2, 3], dtype=np.float64))
        assert (M._err == RC.OK)
        M.destroy()

    def test_upload_CSR(self):
        import scipy.sparse 
        M = pyamgx.Matrix()
        M.create(self.rsrc)
        M.upload_CSR(scipy.sparse.csr_matrix(
            np.array([[1., 2.], [3., 4]])))
        assert (M._err == RC.OK)
        M.destroy()
