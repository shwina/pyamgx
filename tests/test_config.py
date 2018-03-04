import tempfile

import pytest

import pyamgx

class TestConfig:

    def setup(self):
        pyamgx.initialize()

    def teardown(self):
        pyamgx.finalize()

    def test_create_and_destroy(self):
        self.cfg = pyamgx.Config()
        self.cfg.create("")
        self.cfg.create("max_levels=10")
        self.cfg.create("    max_levels = 10; max_iters \t= 10\n")
        with pytest.raises(pyamgx.AMGXError) as excinfo:
            # newline is not delimiter
            self.cfg.create("    max_levels = 10 \n max_iters \t= 10\n")
        assert('amgx configuration' in str(excinfo.value))
        self.cfg.destroy()

    def test_create_from_file(self):
        self.cfg = pyamgx.Config()
        fp = tempfile.NamedTemporaryFile()
        fp.write(b"max_levels=10")
        fp.seek(0)
        self.cfg.create_from_file(fp.name)
        fp.close()

        fp = tempfile.NamedTemporaryFile()
        fp.write(b"    max_lovels = 10 \n max_iters \t= 10\n") #typo
        fp.seek(0)
        with pytest.raises(pyamgx.AMGXError) as excinfo:
            self.cfg.create_from_file(fp.name)
        assert('amgx configuration' in str(excinfo.value))
        fp.close()
