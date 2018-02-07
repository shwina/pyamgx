import pyamgx

pyamgx.initialize()

cfg = pyamgx.config_create_and_destroy(b'../../AMGX/core/configs/FGMRES_AGGREGATION.json')
rsc = pyamgx.resources_create_simple(cfg)

pyamgx.resources_destroy(rsc)
pyamgx.finalize()
