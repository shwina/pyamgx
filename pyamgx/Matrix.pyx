cdef class Matrix:
    """
    Matrix: Class for creating and handling AMGX Resources objects.
    """
    cdef AMGX_matrix_handle mtx
    cdef public AMGX_RC _err

    def create(self, Resources rsrc, mode='dDDI'):
        """
        M.create(Resources rsrc, mode='dDDI')
        
        Create Matrix object.

        Parameters:
        ----------

        rsrc: pyamgx.Resources
            Resources object

        mode: str
            String representing data modes
        """
        self._err = AMGX_matrix_create(&self.mtx, rsrc.rsrc, asMode(mode))
        return self

    def upload(self, n, int nnz,
            np.ndarray[int, ndim=1, mode="c"] row_ptrs,
            np.ndarray[int, ndim=1, mode="c"] col_indices,
            np.ndarray[double, ndim=1, mode="c"] data,
            block_dims=[1, 1]):
        """
        M.upload(n, nnz, row_ptrs, col_indices, data, block_dims=[1, 1])

        Copy data from a numpy.ndarray

        Parameters:
        ----------

        n: int
            Number of columns (and rows) of the matrix in terms of block units
        nnz: int
            Number of nonzeros in the matrix in terms of block units
        row_ptrs: np.ndarray[int, ndim=1, mode="c"]
            Array of row pointers
        col_indices: np.ndarray[int, ndim=1, mode="c"]
            Array of column pointers
        data: np.ndarray[double, ndim=1, mode="c"]
            Array of matrix data
        block_dims: tuple_like
            Dimensions of block in x- and y- directions. Currently
            only square blocks are supported.
        """
        cdef int block_dimx, block_dimy

        block_dimx = block_dims[0]
        block_dimy = block_dims[1]

        self._err = AMGX_matrix_upload_all(self.mtx,
                n, nnz, block_dimx, block_dimy,
                &row_ptrs[0], &col_indices[0],
                &data[0], NULL)

    def get_size(self):
        cdef int n, bx, by
        self._err = AMGX_matrix_get_size(self.mtx,
            &n, &bx, &by)
        return n, [bx, by]
    
    def destroy(self):
        self._err = AMGX_matrix_destroy(self.mtx)
