include "amgxc.pxi"
include "amgxconfig.pxi"

from libc.stdint cimport uintptr_t

def initialize():
    return AMGX_initialize()

def config_create_from_file(param_file):
    cdef AMGX_config_handle cfg
    err = AMGX_config_create_from_file(&cfg, param_file.encode())
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
    return err

def matrix_get_size(A):
    cdef int n, bx, by
    err = AMGX_matrix_get_size(<AMGX_matrix_handle> <uintptr_t> A,
        &n, &bx, &by)
    return n, [bx, by]

def vector_create(rsrc, mode):
    cdef AMGX_vector_handle vec
    err = AMGX_vector_create(&vec, <AMGX_resources_handle> <uintptr_t> rsrc, asMode(mode))
    return <uintptr_t> vec

def vector_destroy(vec):
    err = AMGX_vector_destroy(<AMGX_vector_handle> <uintptr_t> vec)
    return err

def solver_create(rsrc, mode, cfg):
    cdef AMGX_solver_handle slv
    err = AMGX_solver_create(&slv,
        <AMGX_resources_handle> <uintptr_t> rsrc,
        asMode(mode),
        <AMGX_config_handle> <uintptr_t> cfg)
    return <uintptr_t> slv

def solver_destroy(slv):
    err = AMGX_solver_destroy(<AMGX_solver_handle> <uintptr_t> slv)
    return err

def solver_setup(slv, A):
    err = AMGX_solver_setup(
        <AMGX_solver_handle> <uintptr_t> slv,
        <AMGX_matrix_handle> <uintptr_t> A)
    return err

def solver_solve(slv, rhs, sol):
    err = AMGX_solver_solve(
        <AMGX_solver_handle> <uintptr_t> slv,
        <AMGX_vector_handle> <uintptr_t> rhs,
        <AMGX_vector_handle> <uintptr_t> sol)
    return err

def read_system(A, rhs, sol, fname):
    err = AMGX_read_system(
        <AMGX_matrix_handle> <uintptr_t> A,
        <AMGX_vector_handle> <uintptr_t> rhs,
        <AMGX_vector_handle> <uintptr_t> sol,
        fname.encode())
    return err

def finalize():
    return AMGX_finalize()
