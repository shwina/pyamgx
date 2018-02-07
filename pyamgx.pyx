include "amgxc.pxi"
from libc.stdint cimport uintptr_t

def initialize():
    return AMGX_initialize()

def config_create_from_file(param_file):
    cdef AMGX_config_handle cfg
    err = AMGX_config_create_from_file(&cfg, param_file)
    return <uintptr_t> cfg

def finalize():
    return AMGX_finalize()
