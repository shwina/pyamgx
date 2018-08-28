Demo
====

To give you an idea of how pyamgx is used,
here is a simple demo program that sets up and solves a linear system
using pyamgx, and compares the result with
:py:func:`scipy.sparse.linalg.spsolve`.

.. code-block:: python

    import numpy as np
    import scipy.sparse as sparse
    import scipy.sparse.linalg as splinalg

    import pyamgx

    pyamgx.initialize()

    # Initialize config and resources:
    cfg = pyamgx.Config().create_from_dict({
       "config_version": 2,
            "determinism_flag": 1,
            "exception_handling" : 1,
            "solver": {
                "monitor_residual": 1,
                "solver": "BICGSTAB",
                "convergence": "RELATIVE_INI_CORE",
                "preconditioner": {
                    "solver": "NOSOLVER"
            }
        }
    })

    rsc = pyamgx.Resources().create_simple(cfg)

    # Create matrices and vectors:
    A = pyamgx.Matrix().create(rsc)
    b = pyamgx.Vector().create(rsc)
    x = pyamgx.Vector().create(rsc)

    # Create solver:
    solver = pyamgx.Solver().create(rsc, cfg)

    # Upload system:

    M = sparse.csr_matrix(np.random.rand(5, 5))
    rhs = np.random.rand(5)
    sol = np.zeros(5, dtype=np.float64)

    A.upload_CSR(M)
    b.upload(rhs)
    x.upload(sol)

    # Setup and solve system:
    solver.setup(A)
    solver.solve(b, x)

    # Download solution
    x.download(sol)
    print("pyamgx solution: ", sol)
    print("scipy solution: ", splinalg.spsolve(M, rhs))

    # Clean up:
    A.destroy()
    x.destroy()
    b.destroy()
    solver.destroy()
    rsc.destroy()
    cfg.destroy()

    pyamgx.finalize()

Output:

::

   AMGX version 2.0.0.130-opensource
   Built on Jul  6 2018, 12:08:15
   Compiled with CUDA Runtime 8.0, using CUDA driver 9.2
   pyamgx solution:  [-0.90571145  0.85909259  0.54397665  2.02579923 -0.94139638]
   scipy solution:  [-0.90571145  0.85909259  0.54397665  2.02579923 -0.94139638]
