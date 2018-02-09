import pyamgx

pyamgx.initialize()

# Initialize config, resources and mode:
cfg = pyamgx.Config().create_from_file('/home/ashwin/software/AMGX/core/configs/FGMRES_AGGREGATION.json')
rsc = pyamgx.Resources().create_simple(cfg)
mode = 'dDDI'

# Create matrices and vectors:
A = pyamgx.Matrix().create(rsc, mode)
x = pyamgx.Vector().create(rsc, mode)
b = pyamgx.Vector().create(rsc, mode)

# Create solver:
slv = pyamgx.Solver().create(rsc, mode, cfg)

# Read system from file
import numpy as np
import scipy.sparse as sp
A_sp = sp.csr_matrix(np.random.rand(5, 5))
x_np = np.zeros(5, dtype=np.float64)
b_np = np.random.rand(5)
print("True solution: ", np.linalg.solve(A_sp.todense(), b_np))

A.upload(5, 25, A_sp.indptr, A_sp.indices, A_sp.data)
x.upload(5, x_np)
b.upload(5, b_np)

# Setup and solve system:
slv.setup(A)
slv.solve(b, x)

x_np[...] = 0
x.download(x_np)
print("Obtained solution: ", x_np)

# Clean up:
A.destroy()
x.destroy()
b.destroy()
slv.destroy()
rsc.destroy()
cfg.destroy()

pyamgx.finalize()
