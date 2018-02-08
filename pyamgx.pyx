include "amgxc.pxi"
include "amgxconfig.pxi"

from libc.stdint cimport uintptr_t

def initialize():
    return AMGX_initialize()

def config_create_from_file(param_file):
    cdef AMGX_config_handle cfg
    err = AMGX_config_create_from_file(&cfg, param_file)
    return <uintptr_t> cfg

def config_destroy(cfg):
    err = AMGX_config_destroy(<AMGX_config_handle> <uintptr_t> cfg)
    return err

def resources_create_simple(cfg):
    cdef AMGX_resources_handle rsrc
    err = AMGX_resources_create_simple(&rsrc, <AMGX_config_handle> <uintptr_t> cfg)
    return <uintptr_t> rsrc

def resources_destroy(rsrc):
    err = AMGX_resources_destroy(<AMGX_resources_handle> <uintptr_t> rsrc)
    return err

def matrix_create(rsrc, mode):
    cdef AMGX_matrix_handle A
    err = AMGX_matrix_create(&A, <AMGX_resources_handle> <uintptr_t> rsrc, asMode(mode))
    return <uintptr_t> A

def matrix_destroy(A):
    err = AMGX_matrix_destroy(<AMGX_matrix_handle> <uintptr_t> A)
    print(err)
    return err
def finalize():
    return AMGX_finalize()
