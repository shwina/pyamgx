cdef class Config:
    """
    Config: Class for creating and handling AMGX Config objects
    """
    cdef AMGX_config_handle cfg
    cdef public AMGX_RC _err

    def __init__(self):
        pass

    def create(self, options):
        """
        cfg.create(options)

        Create the underlying AMGX Config object from a configuration string.

        Parameters
        ----------
        options : str or bytes_like
            AMGX configuration string.

        Returns
        -------
        self : Config
        """
        if not isinstance(options, bytes):
            options = options.encode()
        self._err = AMGX_config_create(&self.cfg, options)
        return self

    def create_from_file(self, param_file):
        """
        cfg.create_from_file(param_file)

        Create the underlying AMGX Config object from a configuration file.

        Parameters
        ----------
        param_file : str or bytes_like
            Path to configuration file.
        """
        if not isinstance(param_file, bytes):
            param_file = param_file.encode()
        self._err = AMGX_config_create_from_file(&self.cfg, param_file)
        return self

    def destroy(self):
        """
        cfg.destroy()

        Destroy the underlying AMGX Config object.
        """
        self._err = AMGX_config_destroy(self.cfg)
