from __future__ import print_function

import numpy as np
import pyamgx
import pytest

class TestSystem:

    def test_pin_unpin_memory(self):
        a = np.random.rand(5)
        pyamgx.pin_memory(a)
        pyamgx.unpin_memory(a)

    def test_register_print_callback(self, capfd):
        pyamgx.register_print_callback(lambda msg: print("test"))
        pyamgx.Config("")
        out, err = capfd.readouterr()
        assert out == "test\n"
