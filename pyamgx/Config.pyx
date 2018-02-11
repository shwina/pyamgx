
cdef class Config:

    cdef AMGX_config_handle cfg
    cdef public AMGX_RC _err

    def create(self, options):
        if not isinstance(options, bytes):
            options = options.encode()
        self._err = AMGX_config_create(&self.cfg, options)
        return self

    def create_from_file(self, param_file):
        if not isinstance(param_file, bytes):
            param_file = param_file.encode()
        self._err = AMGX_config_create_from_file(&self.cfg, param_file)
        return self

    def destroy(self):
        self._err = AMGX_config_destroy(self.cfg)

