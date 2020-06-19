import numpy as np
import scipy.sparse as sparse
import scipy.sparse.linalg as splinalg

import pyamgx

# Initialize config and resources:
cfg = pyamgx.Config(
    params={
        "config_version": 2,
        "determinism_flag": 1,
        "exception_handling": 1,
        "solver": {
            "monitor_residual": 1,
            "solver": "BICGSTAB",
            "convergence": "RELATIVE_INI_CORE",
            "preconditioner": {"solver": "NOSOLVER"},
        },
    }
)
rsc = pyamgx.Resources(cfg)

# Create matrices and vectors:
A = pyamgx.Matrix(rsc)
b = pyamgx.Vector(rsc)
x = pyamgx.Vector(rsc)

# Create solver:
solver = pyamgx.Solver(rsc, cfg)

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
