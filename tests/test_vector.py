import pyamgx
import numpy as np
from numpy.testing import assert_equal


class TestVector:

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
        v = pyamgx.Vector().create(self.rsrc)
        v.destroy()

    def test_upload_download(self):
        v = pyamgx.Vector().create(self.rsrc)

        v.upload(np.array([1, 2, 3.], dtype=np.float64))

        a = np.zeros(3, dtype=np.float64)
        v.download(a)
        assert_equal(a, np.array([1, 2, 3], dtype=np.float64))

        v.destroy()

    def test_get_size(self):
        v = pyamgx.Vector().create(self.rsrc)

        v.upload(np.array([1, 2, 3.], dtype=np.float64))
        
        n, block_dim = v.get_size()

        assert(n == 3)
        assert(block_dim == 1)
