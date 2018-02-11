import pyamgx
from pyamgx import RC
import numpy as np

class TestMatrix:

    def setup(self):
        pyamgx.initialize()
        self.cfg = pyamgx.Config().create("")
        self.rsrc = pyamgx.Resources().create_simple(self.cfg)
        self.M = pyamgx.Matrix()

    def teardown(self):
        self.M.destroy()
        self.rsrc.destroy()
        self.cfg.destroy()
        pyamgx.finalize()

    def test_create(self):
        self.M.create(self.rsrc)
        assert (self.M._err == RC.OK)

    def test_upload(self):
        self.M.create(self.rsrc)
        self.M.upload(
                4,
                3,
                np.array([0, 3], dtype=np.intc),
                np.array([1, 2, 3], dtype=np.intc),
                np.array([1, 2, 3], dtype=np.float64))
        assert (self.M._err == RC.OK)
