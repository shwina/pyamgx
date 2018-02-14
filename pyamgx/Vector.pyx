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
    cdef public AMGX_RC _err

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
        self._err = AMGX_vector_create(&self.vec, rsrc.rsrc, asMode(mode))
        return self

    def upload(self, np.ndarray[double, ndim=1, mode="c"] data, block_dim=1):
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

        self._err = AMGX_vector_upload(
            self.vec, n, block_dim,
            &data[0])

    def download(self, np.ndarray[double, ndim=1, mode="c"] data):
        """
        v.download(data)

        Copy data from the Vector to a :class:`numpy.ndarray`.

        Parameters
        ----------

        data : ndarray[double, ndim=1, mode="c"]
            Array to copy data to.
        """
        self._err = AMGX_vector_download(self.vec, &data[0])

    def destroy(self):
        """
        v.destroy()

        Destroy the underlying AMGX Vector object.
        """
        self._err = AMGX_vector_destroy(self.vec)
