import  os
from os.path import join as pjoin
from setuptools import setup, Extension
import subprocess
import numpy

try:
    AMGX_DIR = os.environ['AMGX_DIR']
except KeyError:
    raise EnvironmentError("AMGX_DIR environment variable not set."
            "Set AMGX_DIR to the "
            "root directory of your AMGX installation.")

try:
    AMGX_BUILD_DIR = os.environ['AMGX_BUILD_DIR']
except KeyError:
    AMGX_BUILD_DIR = os.path.join(AMGX_DIR, 'build')

from Cython.Build import cythonize
ext = cythonize([
    Extension(
        'pyamgx',
        sources=['pyamgx/pyamgx.pyx'],
        depends=['pyamgx/*.pyx, pyamgx/*.pxi'],
        libraries=['amgxsh'],
        language='c',
        include_dirs = [
            numpy.get_include(),
            os.path.join(AMGX_DIR, 'base/include'),
            os.path.join(AMGX_DIR, 'core/include')
        ],
        library_dirs = [
            numpy.get_include(),
            AMGX_BUILD_DIR
        ],
        runtime_library_dirs = [
            numpy.get_include(),
            AMGX_BUILD_DIR
        ],
)])

setup(name='pyamgx',
      author='Ashwin Srinath',
      version='0.1',
      ext_modules = ext,
      zip_safe=False)
