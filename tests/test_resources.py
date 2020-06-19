import pyamgx

class TestResources:

    def test_create_and_destroy(self):
        cfg = pyamgx.Config("")
        rsrc = pyamgx.Resources(cfg)
