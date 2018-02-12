import pyamgx
import os

pyamgx.initialize()

# Initialize config, resources and mode:
cfg = pyamgx.Config().create_from_file(os.environ['AMGX_DIR']+'/core/configs/FGMRES_AGGREGATION.json')

rsc = pyamgx.Resources().create_simple(cfg)
mode = 'dDDI'
# Create matrices and vectors:
A = pyamgx.Matrix().create(rsc, mode)
x = pyamgx.Vector().create(rsc, mode)
b = pyamgx.Vector().create(rsc, mode)

# Create solver:
slv = pyamgx.Solver().create(rsc, cfg, mode)

# Upload system:
import numpy as np
import scipy.sparse as sparse
import scipy.sparse.linalg as splinalg

M = sparse.csr_matrix(np.random.rand(5, 5))
rhs = np.random.rand(5)
sol = np.zeros(5, dtype=np.float64)

A.upload_CSR(M)
b.upload(rhs.size, rhs)
x.upload(sol.size, sol)

# Setup and solve system:
slv.setup(A)
slv.solve(b, x)

# Download solution
x.download(sol)
print("pyamgx solution: ", sol)
print("scipy solution: ", splinalg.spsolve(M, rhs))

# Clean up:
A.destroy()
x.destroy()
b.destroy()
slv.destroy()
rsc.destroy()
cfg.destroy()

pyamgx.finalize()
