import  os
import warnings
from os.path import join as pjoin
from setuptools import setup, Extension
import subprocess
import sys
import numpy

AMGX_DIR = os.environ.get('AMGX_DIR')
AMGX_BUILD_DIR = os.environ.get('AMGX_BUILD_DIR')


if sys.platform == "win32":
    lib_name = 'amgxsh.dll'
else:
    lib_name = 'libamgxsh.so'

if not AMGX_DIR:
    # look in PREFIX:
    PREFIX = sys.prefix
    if os.path.isfile(os.path.join(PREFIX, f'lib/{lib_name}')):
        lib_path = os.path.join(PREFIX, 'lib')
        AMGX_lib_dirs = [lib_path]
        AMGX_include_dirs = [os.path.join(PREFIX, 'include')]
    else:
        raise EnvironmentError(f'AMGX_DIR not set and {lib_name} not found')
else:
    if not AMGX_BUILD_DIR:
        AMGX_BUILD_DIR = os.path.join(AMGX_DIR, 'build')

    for root, dirs, files in os.walk(AMGX_BUILD_DIR):
        if lib_name in files:
            lib_path = root
            break
    else:
        raise RuntimeError(f'Cannot locate {lib_name} under "{AMGX_BUILD_DIR}".')

    AMGX_lib_dirs = [lib_path]
    AMGX_include_dirs = [
        os.path.join(AMGX_DIR, 'base/include'),
        os.path.join(AMGX_DIR, 'core/include')
    ]

lib_file_path = os.path.join(lib_path, lib_name)

runtime_lib_dirs = []
data_files = []

if sys.platform == "win32":
    if 'install' in sys.argv[1:]:
        data_files = [('', [lib_file_path])]
    else:
        warnings.warn(
            f'Running commands other than `python setup.py install` on Windows'
            f' will not package AMGX library, which may lead to ImportError.'
            f'\nTry adding directory to {lib_name} (which is "{lib_path}") into PATH to avoid this.'
        )
else:
    runtime_lib_dirs = [numpy.get_include(), ] + AMGX_lib_dirs

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
        runtime_library_dirs = runtime_lib_dirs
)])

setup(name='pyamgx',
      author='Ashwin Srinath',
      version='0.1',
      ext_modules = ext,
      data_files=data_files,
      zip_safe=False)
