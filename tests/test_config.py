import pyamgx
from pyamgx import RC
import tempfile

class TestConfig:

    def setup(self):
        pyamgx.initialize()
        self.cfg = pyamgx.Config()

    def teardown(self):
        self.cfg.destroy()
        pyamgx.finalize()

    def test_create(self):
        self.cfg.create("")
        assert (self.cfg._err == RC.OK)
        self.cfg.create("max_levels=10")
        assert (self.cfg._err == RC.OK)
        self.cfg.create("    max_levels = 10 \n max_iters \t= 10\n")
        assert (self.cfg._err == RC.BAD_CONFIGURATION)
        self.cfg.destroy()

    def test_create_from_file(self):
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


