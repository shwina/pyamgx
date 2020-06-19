import pytest

import numpy as np
from numpy.testing import assert_equal

import pyamgx

class TestVector:

    @classmethod
    def setup_class(self):
        self.cfg = pyamgx.Config("")
        self.rsrc = pyamgx.Resources(self.cfg)

    def test_create_and_destroy(self):
        v = pyamgx.Vector(self.rsrc)

    def test_upload_download(self):
        v = pyamgx.Vector(self.rsrc)

        v.upload(np.array([1, 2, 3.], dtype=np.float64))

        a = np.zeros(3, dtype=np.float64)
        v.download(a)
        assert_equal(a, np.array([1, 2, 3], dtype=np.float64))

        assert_equal(v.download(), np.array([1, 2, 3], dtype=np.float64))

    def test_upload_raw(self):
        v = pyamgx.Vector(self.rsrc)

        a = np.array([1, 2, 3], dtype=np.float64)

        v.upload_raw(a.__array_interface__['data'][0], 3)

        b = np.zeros(3, dtype=np.float64)
        v.download(b)
        assert_equal(b, np.array([1, 2, 3], dtype=np.float64))

    def test_download_raw(self):
        v = pyamgx.Vector(self.rsrc)

        v.upload(np.array([1, 2, 3], dtype=np.float64))

        a = np.zeros(3, dtype=np.float64)
        v.download_raw(a.__array_interface__['data'][0])

        assert_equal(a, np.array([1, 2, 3], dtype=np.float64))

    def test_get_size(self):
        v = pyamgx.Vector(self.rsrc)

        n, block_dim = v.get_size()
        assert(n == 0)
        assert(block_dim == 1)

        v.upload(np.array([1, 2, 3.], dtype=np.float64))

        n, block_dim = v.get_size()
        assert(n == 3)
        assert(block_dim == 1)

    def test_set_zero(self):
        v = pyamgx.Vector(self.rsrc)

        a = np.ones(3, dtype=np.float64)
        v.set_zero(3, 1)
        v.download(a)
        assert_equal(a, np.zeros(3, dtype=np.float64))

        a = np.ones(3, dtype=np.float64)
        v.upload(np.ones(3, dtype=np.float64))
        v.set_zero()
        v.download(a)
        assert_equal(a, np.zeros(3, dtype=np.float64))

        a = np.ones(3, dtype=np.float64)
        v.upload(np.ones(3, dtype=np.float64))
        v.set_zero(2)
        v.download(a)
        assert_equal(a, np.array([0, 0, 1], dtype=np.float64))

        a = np.ones(3, dtype=np.float64)
        v.upload(np.ones(3, dtype=np.float64))
        v.set_zero(2, 1)
        v.download(a)
        assert_equal(a, np.array([0, 0, 1], dtype=np.float64))
