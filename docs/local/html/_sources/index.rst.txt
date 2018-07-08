=====================================================
pyamgx - GPU accelerated multigrid library for Python
=====================================================

pyamgx is a Python interface to the NVIDIA `AMGX`_ library.
pyamgx can be used to construct complex solvers and preconditioners
to solve sparse sparse linear systems on the GPU.

Features
========

* Provides a Pythonic interface to all AMGX C-API functions for solving linear systems on a single GPU
* Allows directly uploading matrix and vector data from
  SciPy sparse CSR matrices, NumPy arrays and Numba
  `DeviceArrays <http://numba.pydata.org/numba-doc/latest/cuda/memory.html#device-arrays>`_,
  among others
* Solver settings can be provided in JSON files or as ``dict`` objects
* Error checking and handling: AMGX errors are automatically converted into Python exceptions

Contents
========

.. note::

   This guide provides an overview of the pyamgx library, its classes and functions.
   It does not contain information about AMGX algorithms (solvers and preconditioners),
   and their configuration. For that, please refer to the
   `AMGX Reference Manual`_

.. include:: toctree.rst

.. _AMGX Reference Manual: https://github.com/NVIDIA/AMGX/blob/master/doc/AMGX_Reference.pdf

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

.. _AMGX: https://github.com/NVIDIA/AMGX
