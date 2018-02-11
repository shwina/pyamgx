
cdef class Config:
    """
    Config: Class for creating and handling AMGX Config objects
    """
    cdef AMGX_config_handle cfg
    cdef public AMGX_RC _err

    def create(self, options):
        """
        cfg.create(options)

        Create configuration from options string

        Parameters:

        options: str or bytes_like
            Options string
        """
        if not isinstance(options, bytes):
            options = options.encode()
        self._err = AMGX_config_create(&self.cfg, options)
        return self

    def create_from_file(self, param_file):
        """
        cfg.create_from_file(param_file)

        Create configuration from config file

        Parameters:
        ----------

        param_file: str or bytes_like
            Path to configuration file
        """
        if not isinstance(param_file, bytes):
            param_file = param_file.encode()
        self._err = AMGX_config_create_from_file(&self.cfg, param_file)
        print(self._err)
        return self

    def destroy(self):
        self._err = AMGX_config_destroy(self.cfg)

