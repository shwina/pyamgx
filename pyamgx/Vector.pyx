cdef class Vector:
    """
    Vector: Class for creating and handling AMGX Vector objects.

    Examples
    --------

    Creating a vector, uploading values from a numpy array,
    and downloading values back to a numpy array:

    >>> v = pyamgx.Vector().create(rsrc)
    >>> v.upload(np.array([1., 2., 3.,], dtype=np.float64))
    >>> a = np.zeros([0., 0., 0.])
    >>> v.download(a)
    >>> print(a)
    array([1., 2., 3.])

    """
    cdef AMGX_vector_handle vec

    def create(self, Resources rsrc, mode='dDDI'):
        """
        v.create(Resources rsrc, mode='dDDI')

        Create the underlying AMGX Vector object.

        Parameters
        ----------
        rsrc : Resources
        mode : str, optional
            String representing data modes to use.

        Returns
        -------
        self : Vector
        """
        check_error(AMGX_vector_create(&self.vec, rsrc.rsrc, asMode(mode)))
        return self

    def upload(self, double[:] data, block_dim=1):
        """
        v.upload(data, block_dim=1)

        Copy data to the Vector from a :class:`numpy.ndarray`.

        Parameters
        ----------
        data : ndarray[double, ndim=1, mode="c"]
            Array to copy data from.
        block_dim : int, optional
            Number of values per block.
        """

        if block_dim == 1:
            n = len(data)
        else:
            n = len(data)/block_dim

        check_error(AMGX_vector_upload(
            self.vec, n, block_dim,
            &data[0]))

    def download(self, double[:] data):
        """
        v.download(data)

        Copy data from the Vector to a :class:`numpy.ndarray`.

        Parameters
        ----------

        data : ndarray[double, ndim=1, mode="c"]
            Array to copy data to.
        """
        check_error(AMGX_vector_download(self.vec, &data[0]))

    def get_size(self):
        """
        v.get_size()

        Get the size of the vector (in block units), and the
        block size.

        Returns
        -------
        n : int
            The size of the vector in block units.
        block_dim : int
            The block size.
        """
        cdef int n, block_dim
        check_error(AMGX_vector_get_size(
            self.vec,
            &n, &block_dim))
        return n, block_dim

    def destroy(self):
        """
        v.destroy()

        Destroy the underlying AMGX Vector object.
        """
        check_error(AMGX_vector_destroy(self.vec))

