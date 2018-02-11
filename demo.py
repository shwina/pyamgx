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

# Read system from file
pyamgx.read_system(A, b, x, os.environ['AMGX_DIR']+'/examples/matrix.mtx')

# Setup and solve system:
slv.setup(A)
slv.solve(b, x)

# Clean up:
A.destroy()
x.destroy()
b.destroy()
slv.destroy()
rsc.destroy()
cfg.destroy()

pyamgx.finalize()
