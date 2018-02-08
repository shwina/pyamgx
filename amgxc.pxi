cdef extern from "amgx_c.h":
    ctypedef enum AMGX_RC:
        AMGX_RC_OK = 0
        AMGX_RC_BAD_PARAMETERS = 1
        AMGX_RC_UNKNOWN = 2
        AMGX_RC_NOT_SUPPORTED_TARGET = 3
        AMGX_RC_NOT_SUPPORTED_BLOCKSIZE = 4
        AMGX_RC_CUDA_FAILURE = 5
        AMGX_RC_THRUST_FAILURE = 6
        AMGX_RC_NO_MEMORY = 7
        AMGX_RC_IO_ERROR = 8
        AMGX_RC_BAD_MODE = 9
        AMGX_RC_CORE = 10
        AMGX_RC_PLUGIN = 11
        AMGX_RC_BAD_CONFIGURATION = 12
        AMGX_RC_NOT_IMPLEMENTED = 13
        AMGX_RC_LICENSE_NOT_FOUND = 14
        AMGX_RC_INTERNAL = 15

    ctypedef struct AMGX_config_handle_struct:
        char AMGX_config_handle_dummy
    ctypedef AMGX_config_handle_struct *AMGX_config_handle

    ctypedef struct AMGX_resources_handle_struct:
        char AMGX_resources_handle_dummy
    ctypedef AMGX_resources_handle_struct *AMGX_resources_handle

    ctypedef struct AMGX_matrix_handle_struct:
        char AMGX_matrix_handle_dummy
    ctypedef AMGX_matrix_handle_struct *AMGX_matrix_handle

    ctypedef struct AMGX_vector_handle_struct:
        char AMGX_vector_handle_dummy
    ctypedef AMGX_vector_handle_struct *AMGX_vector_handle

    ctypedef struct AMGX_solver_handle_struct:
        char AMGX_solver_handle_dummy
    ctypedef AMGX_solver_handle_struct *AMGX_solver_handle

    AMGX_RC AMGX_initialize()
    AMGX_RC AMGX_initialize_plugins()
    AMGX_RC AMGX_finalize()
    AMGX_RC AMGX_finalize_plugins()

    AMGX_RC AMGX_config_create_from_file(AMGX_config_handle *cfg, const char *param_file)
    AMGX_RC AMGX_config_destroy(AMGX_config_handle)

    AMGX_RC AMGX_resources_create_simple(AMGX_resources_handle *rsc, AMGX_config_handle cfg)
    AMGX_RC AMGX_resources_destroy(AMGX_resources_handle rsc)

    AMGX_RC AMGX_matrix_create(AMGX_matrix_handle *mtx, AMGX_resources_handle rsc, AMGX_Mode mode)
    AMGX_RC AMGX_matrix_destroy(AMGX_matrix_handle mtx)
