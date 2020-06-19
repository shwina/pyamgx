import numpy as np
from numpy.testing import assert_allclose
import pytest

import pyamgx


class TestSolver:
    @classmethod
    def setup_class(self):
        self.cfg = pyamgx.Config("")
        self.rsrc = pyamgx.Resources(self.cfg)

    def test_create_and_destroy(self):
        solver = pyamgx.Solver(self.rsrc, self.cfg)

    def test_solve_defaults(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x)

        sol = np.zeros(3, dtype=np.float64)
        x.download(sol)
        assert_allclose(sol, np.array([1., 2., 4.]))

    def test_solve_matrix_rhs_dim_mismatch(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))

        # matrix - RHS mismatch
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4., 5.], dtype=np.float64))
        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        with pytest.raises(ValueError):
            solver.solve(b, x)

    def test_solve_rhs_solution_dim_mismatch(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))

        # RHS - solution mismatch
        x.upload(np.zeros(4, dtype=np.float64))
        b.upload(np.array([1., 2., 3], dtype=np.float64))
        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        with pytest.raises(ValueError):
            solver.solve(b, x)

    def test_solve_no_setup(self):
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        solver = pyamgx.Solver(self.rsrc, self.cfg)

        with pytest.raises(RuntimeError):
            solver.solve(b, x)

    def test_solve_0_initial_guess(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x, zero_initial_guess=True)

        sol = np.zeros(3, dtype=np.float64)
        x.download(sol)
        assert_allclose(sol, np.array([1., 2., 4.]))

    def test_get_status(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x, zero_initial_guess=True)
        assert(solver.status == 'success')

        self.cfg.create_from_dict({'monitor_residual': 1, 'max_iters': 0})
        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x, zero_initial_guess=True)
        assert(solver.status == 'diverged')

    def test_get_iterations_number(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        self.cfg.create_from_dict({'monitor_residual': 1, 'max_iters': 0})
        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x, zero_initial_guess=True)
        assert (solver.iterations_number == 0)

        self.cfg.create_from_dict({'max_iters': 1})
        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x)
        assert (solver.iterations_number == 1)

    def test_get_residual(self):
        M = pyamgx.Matrix(self.rsrc)
        x = pyamgx.Vector(self.rsrc)
        b = pyamgx.Vector(self.rsrc)
        M.upload(
            np.array([0, 1, 2, 3], dtype=np.int32),
            np.array([0, 1, 2], dtype=np.int32),
            np.array([1., 1., 1.]))
        x.upload(np.zeros(3, dtype=np.float64))
        b.upload(np.array([1., 2., 4.], dtype=np.float64))

        self.cfg.create_from_dict({'monitor_residual': 1, 'store_res_history': 1,
            'tolerance': 1e-14})
        solver = pyamgx.Solver(self.rsrc, self.cfg)
        solver.setup(M)
        solver.solve(b, x)
        assert (solver.get_residual() <= 1e-14)
        niter = solver.iterations_number
        assert (solver.get_residual() == solver.get_residual(niter))
