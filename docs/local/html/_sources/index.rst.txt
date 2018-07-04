.. pyamgx documentation master file, created by
   sphinx-quickstart on Mon Feb 12 05:33:01 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive

==================================
Welcome to pyamgx's documentation!
==================================

pyamgx is a Python interface to the NVIDIA AMGX_ library.
pyamgx can be used to construct complex nested solvers and preconditioners
to solve sparse sparse linear systems transparently on the GPU.

Features
========

* Provides a Pythonic interface to all AMGX C-API functions for solving linear systems on a single GPU
* Allows directly uploading SciPy sparse CSR matrices, NumPy arrays or Numba
  `DeviceArrays <https://numba.pydata.org/numba-doc/dev/cuda/memory.html#device-arrays>`_
* Solvers specification can be provided specified in JSON files or ``dict``
* Error checking and handling: AMGX errors are automatically converted into Python exceptions

Class reference
===============

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   config
   resources
   matrix
   vector
   solver

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

.. _AMGX: https://github.com/NVIDIA/AMGX
