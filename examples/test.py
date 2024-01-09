
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

N = 5

M = sparse.csr_matrix(np.random.rand(N, N))
rhs = np.random.rand(N)
sol = np.zeros(N, dtype=np.float64)

A.upload_CSR(M)
b.upload(rhs)
x.upload(sol)

# Setup and solve system:
solver.setup(A)
solver.solve(b, x)

# Download solution
x.download(sol)
print("pyamgx solution: ", sol)
print("   norm: ", np.linalg.norm(M*sol-rhs))

X = splinalg.spsolve(M, rhs)

print("scipy solution: ", X)
print("   norm: ", np.linalg.norm(M*X-rhs))

# Clean up:
A.destroy()
x.destroy()
b.destroy()
solver.destroy()
rsc.destroy()
cfg.destroy()

pyamgx.finalize()
