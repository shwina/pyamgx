cdef class Solver:
    """
    Solver: Class for creating and handling AMGX Solver objects.
    """
    cdef AMGX_solver_handle slv
    cdef public AMGX_RC _err

    def create(self, Resources rsrc, Config cfg, mode='dDDI'):
        """
        solver.create(Resources rsrc, Config cfg, mode='dDDI')

        Create Solver object

        Parameters
        ----------
        rsrc : Resources
            `Resources` object

        cfg: Config
            `Config` object

        mode : str, optional
            String representing data modes
        """
        self._err = AMGX_solver_create(&self.slv, rsrc.rsrc, asMode(mode),
            cfg.cfg)
        return self

    def setup(self, Matrix A):
        """
        solver.setup(Matrix A)

        Invoke the set up phase.

        Parameters
        ----------
        A : Matrix
            `Matrix` object that was previously created using
            the `create` method.
        """
        self._err = AMGX_solver_setup(
            self.slv,
            A.mtx)

    def solve(self, Vector rhs, Vector sol):
        """
        solver.solve(Vector rhs, Vector sol)

        Invoke the solve phase.

        Parameters
        ----------
        rhs : Vector
            `Vector` object that was previously created using
            the `create` method. The vector
            represents the right-hand side of the equation to
            be solved.

        sol : Vector
            `Vector` object that was previously created
            and initialized.
        """
        self._err = AMGX_solver_solve(self.slv, rhs.vec, sol.vec)

    def destroy(self):
        self._err = AMGX_solver_destroy(self.slv)
