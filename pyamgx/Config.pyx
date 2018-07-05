import json
import tempfile
import os

cdef class Config:
    """
    Config: Class for creating and handling AMGX Config objects.
    """
    cdef AMGX_config_handle cfg

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
        check_error(AMGX_config_create(&self.cfg, options))
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

    def destroy(self):
        """
        cfg.destroy()

        Destroy the underlying AMGX Config object.
        """
        check_error(AMGX_config_destroy(self.cfg))
