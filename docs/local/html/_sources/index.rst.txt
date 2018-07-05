=====================================================
pyamgx - GPU accelerated multigrid library for Python
=====================================================

pyamgx is a Python interface to the NVIDIA AMGX_ library.
pyamgx can be used to construct complex solvers and preconditioners
to solve sparse sparse linear systems on the GPU.

Features
========

* Provides a Pythonic interface to all AMGX C-API functions for solving linear systems on a single GPU
* Allows directly uploading SciPy sparse CSR matrices, NumPy arrays or Numba.
  `DeviceArrays <https://numba.pydata.org/numba-doc/dev/cuda/memory.html#device-arrays>`_
  to the GPU>
* Solver settings can be provided in JSON files or as ``dict`` objects.
* Error checking and handling: AMGX errors are automatically converted into Python exceptions.

Contents
========

.. include:: toctree.rst

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

.. _AMGX: https://github.com/NVIDIA/AMGX
