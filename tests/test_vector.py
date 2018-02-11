import pyamgx
from pyamgx import RC
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
        assert (v._err == RC.OK)
        v.destroy()
        assert (v._err == RC.OK)

    def test_upload_download(self):
        v = pyamgx.Vector().create(self.rsrc)

        v.upload(
               3,
                np.array([1, 2, 3.], dtype=np.float64))
        assert (v._err == RC.OK)

        a = np.zeros(3, dtype=np.float64)
        v.download(a)
        assert(v._err == RC.OK)
        assert_equal(a,
               np.array([1, 2, 3], dtype=np.float64))

        v.destroy()
