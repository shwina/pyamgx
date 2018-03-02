import pyamgx

class TestUtilities:

    def setup_class(cls):
        pyamgx.initialize()

    def test_get_api_version(self):
        api_version = pyamgx.get_api_version()
        major, minor = api_version.split('.')
        assert(major)
        assert(minor)

    def test_get_error_string(self):
        assert(pyamgx.get_error_string(0) == 'No error.')
        assert(pyamgx.get_error_string(pyamgx.RC.OK) == 'No error.')
        assert(pyamgx.get_error_string(pyamgx.RC.BAD_PARAMETERS) == 'Incorrect parameters for amgx call.')
        assert(pyamgx.get_error_string(pyamgx.RC.INTERNAL) == 'Internal error.')

    def teardown_class(cls):
        pyamgx.finalize()
