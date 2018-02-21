import pyamgx
from pyamgx import RC
import tempfile

class TestConfig:

    def setup(self):
        pyamgx.initialize()

    def teardown(self):
        pyamgx.finalize()

    def test_create_and_destroy(self):
        self.cfg = pyamgx.Config()
        self.cfg.create("")
        assert (self.cfg._err == RC.OK)
        self.cfg.create("max_levels=10")
        assert (self.cfg._err == RC.OK)
        self.cfg.create("    max_levels = 10 \n max_iters \t= 10\n")
        assert (self.cfg._err == RC.BAD_CONFIGURATION)
        self.cfg.destroy()
        assert (self.cfg._err == RC.OK)

    def test_create_from_file(self):
        self.cfg = pyamgx.Config()
        fp = tempfile.NamedTemporaryFile()
        fp.write(b"max_levels=10")
        fp.seek(0)
        self.cfg.create_from_file(fp.name)
        assert(self.cfg._err == RC.OK)
        fp.close()

        fp = tempfile.NamedTemporaryFile()
        fp.write(b"    max_lovels = \n max_iters \t= 10\n")
        fp.seek(0)
        self.cfg.create_from_file(fp.name)
        assert(self.cfg._err == RC.BAD_CONFIGURATION)
        fp.close()
