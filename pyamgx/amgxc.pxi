cdef extern from "amgx_c.h":

    # Return codes
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

    # Forward (opaque) handle declaration:
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

    # Build:
    AMGX_RC AMGX_get_api_version(int *major,
        int *minor)

    AMGX_RC AMGX_get_build_info_strings(char **version,
        char **date,
        char **time)

    AMGX_RC AMGX_get_error_string(AMGX_RC err,
        char *buf,
        int buf_len)

    # Init & Shutdown:
    AMGX_RC AMGX_initialize()
    AMGX_RC AMGX_initialize_plugins()
    AMGX_RC AMGX_finalize()
    AMGX_RC AMGX_finalize_plugins()

    # Config:
    AMGX_RC AMGX_config_create(AMGX_config_handle *cfg, const char *options)
    AMGX_RC AMGX_config_create_from_file(
        AMGX_config_handle *cfg, const char *param_file)
    AMGX_RC AMGX_config_destroy(AMGX_config_handle)

    # Resources:
    AMGX_RC AMGX_resources_create_simple(
        AMGX_resources_handle *rsc, AMGX_config_handle cfg)
    AMGX_RC AMGX_resources_destroy(AMGX_resources_handle rsc)

    # Matrix:
    AMGX_RC AMGX_matrix_create(
        AMGX_matrix_handle *mtx, AMGX_resources_handle rsc, AMGX_Mode mode)
    AMGX_RC AMGX_matrix_destroy(AMGX_matrix_handle mtx)

    AMGX_RC AMGX_matrix_get_size(
        const AMGX_matrix_handle mtx, int *n, int *block_dimx,
        int *block_dimy)

    AMGX_RC AMGX_matrix_upload_all(
        AMGX_matrix_handle mtx, int n, int nnz,
        int block_dimx, int block_dimy,
        const int *row_ptrs, const int *col_indices,
        const void *data, const void *diag_data)

    AMGX_RC AMGX_matrix_download_all(
        const AMGX_matrix_handle mtx,
        int *row_ptrs, int *col_indices, void *data, void **diag_data)

    # Vector:
    AMGX_RC AMGX_vector_create(
        AMGX_vector_handle *vec, AMGX_resources_handle rsc, AMGX_Mode mode)
    AMGX_RC AMGX_vector_destroy(AMGX_vector_handle vec)

    AMGX_RC AMGX_vector_upload(
        AMGX_vector_handle vec, int n, int block_dim,
        const void *data)

    AMGX_RC AMGX_vector_download(
        const AMGX_vector_handle vec,
        void *data)

    AMGX_RC AMGX_vector_get_size(const AMGX_vector_handle vec,
        int *n,
        int *block_dim)

    # Solver:
    AMGX_RC AMGX_solver_create(
        AMGX_solver_handle *slv,
        AMGX_resources_handle rsc,
        AMGX_Mode mode,
        const AMGX_config_handle cfg_solver)

    AMGX_RC AMGX_solver_destroy(AMGX_solver_handle slv)

    AMGX_RC AMGX_solver_setup(
        AMGX_solver_handle slv,
        AMGX_matrix_handle mtx)

    AMGX_RC AMGX_solver_solve(
        AMGX_solver_handle slv,
        AMGX_vector_handle rhs,
        AMGX_vector_handle sol)

    AMGX_RC AMGX_solver_solve_with_0_initial_guess(
        AMGX_solver_handle slv,
        AMGX_vector_handle rhs,
        AMGX_vector_handle sol)

    # Utilities:
    AMGX_RC AMGX_read_system(
        AMGX_matrix_handle mtx, AMGX_vector_handle rhs,
        AMGX_vector_handle sol, const char *filename)
