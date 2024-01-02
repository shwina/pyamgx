import  os
from os.path import join as pjoin
from setuptools import setup, Extension
import subprocess
import sys
import numpy

AMGX_DIR = os.environ.get('AMGX_DIR')
AMGX_BUILD_DIR = os.environ.get('AMGX_BUILD_DIR')

if not AMGX_DIR:
    # look in PREFIX:
    PREFIX = sys.prefix
    if os.path.isfile(os.path.join(PREFIX, 'lib/libamgxsh.so')):
        AMGX_lib_dirs = [os.path.join(PREFIX, 'lib')]
        AMGX_include_dirs = [os.path.join(PREFIX, 'include')]
    else:
        raise EnvironmentError('AMGX_DIR not set and libamgxsh.so not found')
else:
    if not AMGX_BUILD_DIR:
        AMGX_BUILD_DIR = os.path.join(AMGX_DIR, 'build')
    AMGX_lib_dirs = [AMGX_BUILD_DIR]
    AMGX_include_dirs = [
        os.path.join(AMGX_DIR, 'include')
    ]

from Cython.Build import cythonize
ext = cythonize([
    Extension(
        'pyamgx',
        sources=['pyamgx/pyamgx.pyx'],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-lgomp'],
        depends=['pyamgx/*.pyx, pyamgx/*.pxi'],
        libraries=['amgxsh'],
        language='c',
        include_dirs = [
            numpy.get_include(),
        ] + AMGX_include_dirs,
        library_dirs = [
            numpy.get_include(),
        ] + AMGX_lib_dirs,
        runtime_library_dirs = [
            numpy.get_include(),
        ] + AMGX_lib_dirs,
)])

setup(name='pyamgx',
      author='Ashwin Srinath',
      version='0.1',
      ext_modules = ext,
      zip_safe=False)
