import tempfile

import pytest

import pyamgx

class TestConfig:

    def setup_class(self):
        self.cfg = pyamgx.Config("")

    def test_create_and_destroy(self):
        self.cfg = pyamgx.Config("")
        self.cfg = pyamgx.Config("max_levels=10")
        self.cfg = pyamgx.Config("    max_levels = 10; max_iters \t= 10\n")
        with pytest.raises(pyamgx.AMGXError) as excinfo:
            # newline is not delimiter
            self.cfg = pyamgx.Config("    max_levels = 10 \n max_iters \t= 10\n")
        assert('amgx configuration' in str(excinfo.value))

    def test_create_from_file(self):
        fp = tempfile.NamedTemporaryFile()
        fp.write(b"max_levels=10")
        fp.seek(0)
        self.cfg = pyamgx.Config(config_file=fp.name)
        fp.close()

        # typo in configuration file:
        fp = tempfile.NamedTemporaryFile()
        fp.write(b"    max_lovels = 10 \n max_iters \t= 10\n")
        fp.seek(0)
        with pytest.raises(pyamgx.AMGXError) as excinfo:
            self.cfg = pyamgx.Config(config_file=fp.name)
        assert('amgx configuration' in str(excinfo.value))
        fp.close()

        # non-existent configuration file:
        with pytest.raises(IOError):
            self.cfg = pyamgx.Config(config_file='idontexist.txt')

    def test_create_from_dict(self):
        self.cfg = pyamgx.Config(params={"max_levels": 10})
        with pytest.raises(pyamgx.AMGXError):
            self.cfg = pyamgx.Config(params={"max_lovels": 10})
