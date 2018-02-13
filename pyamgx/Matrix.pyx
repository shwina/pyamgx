cdef class Matrix:
    """
    `Matrix` : Class for creating and handling AMGX Matrix objects.
    """
    cdef AMGX_matrix_handle mtx
    cdef public AMGX_RC _err

    def create(self, Resources rsrc, mode='dDDI'):
        """
        M.create(Resources rsrc, mode='dDDI')
        
        Create Matrix object.

        Parameters
        ----------
        rsrc : `pyamgx.Resources`
            Resources object

        mode : str
            String representing data modes
        """
        self._err = AMGX_matrix_create(&self.mtx, rsrc.rsrc, asMode(mode))
        return self

    def upload(self,
            np.ndarray[int, ndim=1, mode="c"] row_ptrs,
            np.ndarray[int, ndim=1, mode="c"] col_indices,
            np.ndarray[double, ndim=1, mode="c"] data,
            block_dims=[1, 1]):
        """
        M.upload(n, nnz, row_ptrs, col_indices, data, block_dims=[1, 1])

        Copy data from arrays describing the sparse matrix.

        Parameters
        ----------
        row_ptrs : (N,) array
            Array (one-dimensional) of row pointers. 
            For an explanation of the arrays `row_ptrs`, `col_indices` and `data`,
            please see `<https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format)>`_.
        col_indices : (N,) ndarray
            Array (one-dimensional) of column indices
        data : (N,) ndarray
            Array (one-dimensional) of matrix data
        block_dims : tuple_like, optional
            Dimensions of block in x- and y- directions. Currently
            only square blocks are supported.
        """
        cdef int block_dimx, block_dimy

        block_dimx = block_dims[0]
        block_dimy = block_dims[1]

        n = len(row_ptrs) - 1
        nnz = len(data)

        self._err = AMGX_matrix_upload_all(self.mtx,
                n, nnz, block_dimx, block_dimy,
                &row_ptrs[0], &col_indices[0],
                &data[0], NULL)

    def upload_CSR(self, csr):
        """
        M.upload(csr)

        Copy data from a `scipy.sparse.csr_matrix`.

        Parameters
        ----------
        csr : sparse matrix
            A `scipy.sparse.csr_matrix`.
            
        """
        n = csr.shape[0]
        nnz = csr.nnz
        row_ptrs = csr.indptr
        col_indices = csr.indices
        data = csr.data
        self.upload(n, nnz, row_ptrs, col_indices, data)

    def get_size(self):
        cdef int n, bx, by
        self._err = AMGX_matrix_get_size(self.mtx,
            &n, &bx, &by)
        return n, [bx, by]
    
    def destroy(self):
        self._err = AMGX_matrix_destroy(self.mtx)
