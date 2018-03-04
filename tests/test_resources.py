import pyamgx

class TestResources:

    def setup(self):
        pyamgx.initialize()

    def test_create_and_destroy(self):
        cfg = pyamgx.Config().create("")
        rsrc = pyamgx.Resources().create_simple(cfg)
        rsrc.destroy()
        cfg.destroy()

    def teardown(self):
        pyamgx.finalize()

