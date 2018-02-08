import pyamgx

pyamgx.initialize()

cfg = pyamgx.config_create_from_file('/home/ashwin/software/AMGX/core/configs/FGMRES_AGGREGATION.json')
rsc = pyamgx.resources_create_simple(cfg)

mode = 'dDDI'

A = pyamgx.matrix_create(rsc, mode)
x = pyamgx.vector_create(rsc, mode)
b = pyamgx.vector_create(rsc, mode)

pyamgx.read_system(A, b, x, '/home/ashwin/software/AMGX/examples/matrix.mtx')

slv = pyamgx.solver_create(rsc, mode, cfg)
pyamgx.solver_setup(slv, A)
pyamgx.solver_solve(slv, b, x)

pyamgx.matrix_destroy(A)
pyamgx.vector_destroy(x)
pyamgx.vector_destroy(b)
pyamgx.solver_destroy(slv)
pyamgx.resources_destroy(rsc)
pyamgx.finalize()
