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
pyamgx.read_system(A, b, x, '/home/ashwin/software/AMGX/examples/matrix.mtx')

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
