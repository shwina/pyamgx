import numpy as np
from numpy.testing import assert_allclose
import pytest

import pyamgx


class TestSolver:
    @classmethod
    def setup_class(self):
        pyamgx.initialize()
        self.cfg = pyamgx.Config().create("")
        self.rsrc = pyamgx.Resources().create_simple(self.cfg)

    @classmethod
    def teardown_class(self):
        self.rsrc.destroy()
        self.cfg.destroy()
        pyamgx.finalize()

    def test_create_and_destroy(self):
        solver = pyamgx.Solver().create(self.rsrc, self.cfg)
        solver.destroy()

    def test_solve_defaults(self):
        M = pyamgx.Matrix().create(self.rsrc)
        x = pyamgx.Vector().create(self.rsrc)
        b = pyamgx.Vector().create(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))
        
        solver = pyamgx.Solver().create(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x)

        sol = np.zeros(3, dtype=np.float64)
        x.download(sol)
        assert_allclose(sol, np.array([1., 2., 4.]))
        solver.destroy()
        M.destroy()
        x.destroy()
        b.destroy()

    def test_solve_matrix_rhs_dim_mismatch(self):
        M = pyamgx.Matrix().create(self.rsrc)
        x = pyamgx.Vector().create(self.rsrc)
        b = pyamgx.Vector().create(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))

        # matrix - RHS mismatch
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4., 5.], dtype=np.float64))
        solver = pyamgx.Solver().create(self.rsrc, self.cfg)
        solver.setup(M)
        with pytest.raises(ValueError):
            solver.solve(b, x)

        solver.destroy()
        M.destroy()
        x.destroy()
        b.destroy()

    def test_solve_rhs_solution_dim_mismatch(self):
        M = pyamgx.Matrix().create(self.rsrc)
        x = pyamgx.Vector().create(self.rsrc)
        b = pyamgx.Vector().create(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))

        # RHS - solution mismatch
        x.upload(np.zeros(4, dtype=np.float64))
        b.upload(np.array([1., 2., 3], dtype=np.float64))
        solver = pyamgx.Solver().create(self.rsrc, self.cfg)
        solver.setup(M)
        with pytest.raises(ValueError):
            solver.solve(b, x)

        solver.destroy()
        M.destroy()
        x.destroy()
        b.destroy()
        
    def test_solve_no_setup(self):
        x = pyamgx.Vector().create(self.rsrc)
        b = pyamgx.Vector().create(self.rsrc)
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        solver = pyamgx.Solver().create(self.rsrc, self.cfg)

        with pytest.raises(RuntimeError):
            solver.solve(b, x)

        solver.destroy()
        x.destroy()
        b.destroy()

    def test_solve_0_initial_guess(self):
        M = pyamgx.Matrix().create(self.rsrc)
        x = pyamgx.Vector().create(self.rsrc)
        b = pyamgx.Vector().create(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))
        
        solver = pyamgx.Solver().create(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x, zero_initial_guess=True)

        sol = np.zeros(3, dtype=np.float64)
        x.download(sol)
        assert_allclose(sol, np.array([1., 2., 4.]))

        solver.destroy()
        M.destroy()
        x.destroy()
        b.destroy()
