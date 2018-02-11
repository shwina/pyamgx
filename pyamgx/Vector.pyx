cdef class Vector:
    """
    Vector: Class for creating and handling AMGX Vector objects.
    """
    cdef AMGX_vector_handle vec
    cdef public AMGX_RC _err

    def create(self, Resources rsrc, mode='dDDI'):
        """
        v.create(Resources rsrc, mode='dDDI')

        Create Vector object.

        Parameters:
        ----------

        rsrc: pyamgx.Resources
            Resources object

        mode: str
            String representing data modes
        """
        self._err = AMGX_vector_create(&self.vec, rsrc.rsrc, asMode(mode))
        return self

    def upload(self, int n, np.ndarray[double, ndim=1, mode="c"] data, block_dim=1):
        """
        v.upload(n, data, block_dim=1)

        Copy data from a numpy.ndarray

        Parameters:
        ----------

        n: int
            Number of entries to be copied, in block units
        data: np.ndarray[double, ndim=1, mode="c"]
            Array of vector data
        block_dim: int
            Number of values per block
        """

        self._err = AMGX_vector_upload(self.vec, n, block_dim,
            &data[0])
    
    def download(self, np.ndarray[double, ndim=1, mode="c"] data):
        """
        v.download(data)

        Copy data to a numpy.ndarray. See pyamgx.Vector.upload
        """
        self._err = AMGX_vector_download(self.vec, &data[0])

    def destroy(self):
        self._err = AMGX_vector_destroy(self.vec)
