cdef class Solver:
    """
    Solver: Class for creating and handling AMGX Solver objects.
    """
    cdef AMGX_solver_handle slv

    def create(self, Resources rsrc, Config cfg, mode='dDDI'):
        """
        solver.create(Resources rsrc, Config cfg, mode='dDDI')

        Create Solver object

        Parameters:
        ----------

        rsrc: pyamgx.Resources
            Resources object

        cfg: pyamgx.Config
            Config object

        mode: str
            String representing data modes
        """
        err = AMGX_solver_create(&self.slv, rsrc.rsrc, asMode(mode),
            cfg.cfg)
        return self

    def setup(self, Matrix A):
        """
        solver.setup(Matrix A)

        Invoke the set up phase.

        Parameters:
        ----------
        
        A: pyamgx.Matrix
            Matrix object that was previously created
        """
        err = AMGX_solver_setup(
            self.slv,
            A.mtx)

    def solve(self, Vector rhs, Vector sol):
        """
        solver.solve(Vector rhs, Vector sol)

        Invoke the solve phase.

        Parameters:
        ----------

        rhs: pyamgx.Vector
            Vector object that was previously created. The vector
            represents the right-hand side of the equation to
            be solved.

        sol: pyamgx.Vector
            Vector object that was previously created
            and initialized.
        """
        err = AMGX_solver_solve(self.slv, rhs.vec, sol.vec)

    def destroy(self):
        err = AMGX_solver_destroy(self.slv)
