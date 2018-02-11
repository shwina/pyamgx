import pyamgx
from pyamgx import RC
import numpy as np

class TestVector:

    def setup(self):
        pyamgx.initialize()
        self.cfg = pyamgx.Config().create("")
        self.rsrc = pyamgx.Resources().create_simple(self.cfg)
        self.v = pyamgx.Vector()

    def teardown(self):
        self.v.destroy()
        self.rsrc.destroy()
        self.cfg.destroy()
        pyamgx.finalize()

    def test_create(self):
        self.v.create(self.rsrc)
        assert (self.v._err == RC.OK)

    def test_upload(self):
        self.v.create(self.rsrc)
        self.v.upload(
               3,
                np.array([1, 2, 3.], dtype=np.float64))
        assert (self.v._err == RC.OK)
