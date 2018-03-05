import numpy as np
import pyamgx
import pytest

class TestSystem:

    def setup(self):
        pyamgx.initialize()

    def test_pin_unpin_memory(self):
        a = np.random.rand(5)
        pyamgx.pin_memory(a)
        pyamgx.unpin_memory(a)

    def teardown(self):
        pyamgx.finalize()
