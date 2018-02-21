import pyamgx
from pyamgx import RC

class TestResources:

    def setup(self):
        pyamgx.initialize()

    def test_create_and_destroy(self):
        cfg = pyamgx.Config().create("")
        rsrc = pyamgx.Resources().create_simple(cfg)
        assert(rsrc._err == RC.OK)
        rsrc.destroy()
        assert(rsrc._err == RC.OK)
        cfg.destroy()

    def teardown(self):
        pyamgx.finalize()

