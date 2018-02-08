import pyamgx

pyamgx.initialize()

cfg = pyamgx.config_create_from_file(b'/home/ashwin/software/AMGX/core/configs/FGMRES_AGGREGATION.json')
rsc = pyamgx.resources_create_simple(cfg)
A = pyamgx.matrix_create(rsc, 'hDDI')
print(A)
pyamgx.matrix_destroy(A)
pyamgx.resources_destroy(rsc)
pyamgx.finalize()
