cdef class Resources:
    """
    Resources: Class for creating and freeing AMGX Resources objects.
    """
    cdef AMGX_resources_handle rsrc
    cdef dict __dict__

    def __cinit__(self, Config cfg):
        """
        rsc.create_simple(cfg)

        Create the underlying AMGX Resources object in a
        single-threaded application.

        Parameters
        ----------
        cfg : Config

        Returns
        -------
        self : Resources
        """
        check_error(AMGX_resources_create_simple(&self.rsrc, cfg.cfg))
        self._cfg = cfg

    def __dealloc__(self):
        check_error(AMGX_resources_destroy(self.rsrc))
