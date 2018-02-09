import  os
from os.path import join as pjoin
from setuptools import setup, Extension
from Cython.Build import cythonize
import subprocess
import numpy

ext = Extension('pyamgx',
                sources=['pyamgx/pyamgx.pyx'],
                libraries=['amgxsh'],
                language='c',
                include_dirs = [numpy.get_include()])

setup(name='pyamgx',
      author='Ashwin Srinath',
      version='0.1',
      ext_modules = cythonize([ext]),
      zip_safe=False)
