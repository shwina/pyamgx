import json
import tempfile
import os


cdef class Config:
    """
    Config: Class for creating and handling AMGX Config objects.
    """
    cdef AMGX_config_handle cfg

    def __cinit__(self, config_string=None, params=None, config_file=None):
        """
        Create the underlying AMGX Config object from a configuration string.

        Parameters
        ----------
        options : str or bytes_like
            AMGX configuration string.

        Returns
        -------
        self : Config
        """
        if params is not None:
            self.create_from_dict(params)
        elif config_file is not None:
            self.create_from_file(config_file)
        elif config_string is not None:
            if not isinstance(config_string, bytes):
                options = config_string.encode()
            check_error(AMGX_config_create(&self.cfg, options))
        else:
            raise TypeError("One of params, config_file or config_string must be provided")

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
        if not os.path.isfile(param_file):
            raise IOError('File {} not found.'.format(param_file))
        check_error(AMGX_config_create_from_file(&self.cfg, param_file))
        return self

    def create_from_dict(self, params):
        """
        cfg.create_from_dict(param_file)

        Create the underlying AMGX Config object from a dictionary.

        Parameters
        ----------
        params : dict
            Dictionary with configuration options.
        """
        with tempfile.NamedTemporaryFile(mode='r+') as fp:
            json.dump(params, fp)
            fp.seek(0)
            self.create_from_file(fp.name.encode())
        return self

    def __dealloc__(self):
        check_error(AMGX_config_destroy(self.cfg))
