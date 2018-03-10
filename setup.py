import  os
from os.path import join as pjoin
from setuptools import setup, Extension
import subprocess
import numpy

try:
    from Cython.Build import cythonize
    ext = cythonize([
        Extension(
            'pyamgx',
            sources=['pyamgx/pyamgx.pyx'],
            depends=['pyamgx/*.pyx, pyamgx/*.pxi'],
            libraries=['amgxsh'],
            language='c',
            include_dirs = [numpy.get_include()])
        ])
except ImportError:
    ext = [
        Extension(
            'pyamgx',
            sources=['pyamgx/pyamgx.c'],
            libraries=['amgxsh'],
            language='c',
            include_dirs = [numpy.get_include()]
        )]

setup(name='pyamgx',
      author='Ashwin Srinath',
      version='0.1',
      ext_modules = ext,
      zip_safe=False)
