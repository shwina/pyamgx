include "amgxc.pxi"
from libc.stdint cimport uintptr_t

def initialize():
    return AMGX_initialize()

def config_create_and_destroy(param_file):
    cdef AMGX_config_handle cfg
    err = AMGX_config_create_from_file(&cfg, param_file)
    return <uintptr_t> cfg

def config_destroy(cfg):
    err = AMGX_config_destroy(<AMGX_config_handle> <uintptr_t> cfg)
    return err

def resources_create_simple(cfg):
    cdef AMGX_resources_handle rsc
    err = AMGX_resources_create_simple(&rsc, <AMGX_config_handle> <uintptr_t> cfg)
    return <uintptr_t> rsc

def resources_destroy(rsc):
    err = AMGX_resources_destroy(<AMGX_resources_handle> <uintptr_t> rsc)
    return err

def finalize():
    return AMGX_finalize()
