from libc.stdint cimport uintptr_t

cdef class Vector:
    """
    Vector: Class for creating and handling AMGX Vector objects.

    Examples
    --------

    Creating a vector, uploading values from a numpy array,
    and downloading values back to a numpy array:

    >>> import pyamgx, numpy as np
    >>> pyamgx.initialize()
    >>> cfg = pyamgx.Config().create("")
    >>> rsrc = pyamgx.Resources().create_simple(cfg)
    >>> v = pyamgx.Vector().create(rsrc)
    >>> v.upload(np.array([1., 2., 3.,], dtype=np.float64))
    >>> v.download()
    array([ 1.,  1.,  1.])
    >>> v.destroy()
    >>> rsrc.destroy()
    >>> cfg.destroy()
    >>> pyamgx.finalize()


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

    def upload(self, data, block_dim=1):
        """
        v.upload(data, block_dim=1)

        Copy data to the Vector from an array.

        Parameters
        ----------
        data : array_like, ndim=1
            Array to copy data from.

        block_dim : int, optional
            Number of values per block.

        Returns
        -------
        self : Vector
        """

        if block_dim == 1:
            n = data.size
        else:
            n = data.size/block_dim

        cdef uintptr_t ptr = ptr_from_array_interface(data, "float64")
        self.upload_raw(ptr, n, block_dim)

        return self

    def upload_raw(self, uintptr_t ptr, int n, block_dim=1):
        """
        v.upload_raw(ptr, n, block_dim=1)

        Copy data to the Vector from an array, given a raw pointer
        to the array.

        Parameters
        ----------
        ptr : pointer
            An integer (or long integer, if required) that
            points to the array containing data
        n : int
            Size of the array
        block_dim : int, optional
            Number of values per block.
        """

        check_error(AMGX_vector_upload(
            self.vec, n, block_dim,
            <void *> ptr))

        return self

    def download(self, double[:] data=None):
        """
        v.download(data)

        Copy data from the Vector to an array.

        Parameters
        ----------
        data : array, ndim=1
            Array to copy data to.
        """
        if data is None:
            n = self.get_size()[0]
            data = np.zeros(n, dtype=np.float64)

        self.download_raw(<uintptr_t> &data[0])
        return np.asarray(data)

    def download_raw(self, uintptr_t ptr):
        """
        v.download_raw(ptr)

        Copy data from the Vector to an array, given a raw pointer
        to the array.

        Parameters
        ----------
        ptr : pointer
            An integer (or long integer, if required) that
            points to the array containing data
        """
        check_error(AMGX_vector_download(self.vec, <void *>ptr))

    def set_zero(self, n=None, block_dim=None):
        """
        v.set_zero(n=None, block_dim=None)

        Allocate storage if needed and set all
        the values in the vector to zero.

        Parameters
        ----------
        n : int, optional
            Number of entries in the vector, in block units.
            If not provided or `None`, then the values *must*
            have been previously initialized using e.g.,
            `v.upload()`.

        block_dim : int, optional
            Number of values per block. If not provided
            or `None`, then the values *must* have been previously

            initialized using e.g., `v.upload()`.
        """
        n_, block_dim_ = self.get_size()
        if n_ == 0:
            if n is None or block_dim is None:
                raise ValueError("set_zero() requires arguments"
                                 "'n' and 'block_dim'"
                                 "for uninitialized vector")
        if n is None:
            n = n_
        if block_dim is None:
            block_dim = block_dim_

        check_error(AMGX_vector_set_zero(
            self.vec, n, block_dim))

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
