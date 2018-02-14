cdef class Solver:
    """
    Solver: Class for creating and handling AMGX Solver objects.
    """
    cdef AMGX_solver_handle slv
    cdef public AMGX_RC _err

    def create(self, Resources rsrc, Config cfg, mode='dDDI'):
        """
        solver.create(Resources rsrc, Config cfg, mode='dDDI')

        Create the underlying AMGX Solver object

        Parameters
        ----------
        rsrc : Resources
        cfg: Config
        mode : str, optional
            String representing data modes to use.
        """
        self._err = AMGX_solver_create(
            &self.slv, rsrc.rsrc, asMode(mode),
            cfg.cfg)
        return self

    def setup(self, Matrix A):
        """
        solver.setup(Matrix A)

        Invoke the set up phase.

        Parameters
        ----------
        A : Matrix
            The `Matrix` representing the coefficient matrix of the equation
            to be solved.
        """
        self._err = AMGX_solver_setup(
            self.slv,
            A.mtx)

    def solve(self, Vector rhs, Vector sol, zero_initial_guess=False):
        """
        solver.solve(Vector rhs, Vector sol)

        Invoke the solve phase.

        Parameters
        ----------
        rhs : Vector
            The `Vector` representing the right-hand side of the equation
            to be solved.
        sol : Vector
            The `Vector` representing the solution vector of the equation
            to be solved. If `zero_initial_guess` is unspecified,
            the values in `sol` are used as the initial guess for iterative
            algorithms.
        zero_initial_guess : bool, optional
            If `True`, use an initial guess of zero for the solution,
            regardless of the values in `sol`.
        """
        if zero_initial_guess:
            self._err = AMGX_solver_solve_with_0_initial_guess(
                self.slv, rhs.vec, sol.vec)
        else:
            self._err = AMGX_solver_solve(self.slv, rhs.vec, sol.vec)

    def destroy(self):
        """
        solver.destroy()

        Destroy the underlying AMGX Matrix object.
        """
        self._err = AMGX_solver_destroy(self.slv)
