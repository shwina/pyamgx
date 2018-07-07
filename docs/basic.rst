Basic Usage
===========

Initializing and finalizing pyamgx
----------------------------------

The :py:func:`~pyamgx.initialize` and :py:func:`~pyamgx.finalize` functions
**must** be called to initialize and finalize the library respectively.

.. code-block:: python

   import pyamgx
   pyamgx.initialize()

   # use pyamgx

   pyamgx.finalize()

Config objects
--------------

:py:class:`~pyamgx.Config` objects are used to store configuration settings
for the linear solver used, including
algorithm, preconditioner(s), smoother(s) and associated parameters.

:py:class:`~pyamgx.Config` objects can be constructed from
JSON files or :py:class:`dict` objects.

As an example, the :py:class:`~pyamgx.Config` object below
represents the configuration for a BICGSTAB solver
without preconditioning, and is constructed using
the :py:meth:`~pyamgx.Config.create_from_dict` method:

.. code-block:: python

   cfg = pyamgx.Config()
   cfg.create_from_dict({
        "config_version": 2,
        "determinism_flag": 1,
        "exception_handling" : 1,
        "solver": {
            "monitor_residual": 1,
            "solver": "BICGSTAB",
            "convergence": "RELATIVE_INI_CORE",
            "preconditioner": {
                "solver": "NOSOLVER"
            }
        }
    })

Examples of more complex configurations can be found
`here <https://github.com/NVIDIA/AMGX/tree/master/core/configs>`_,
and a description of all configuration settings can be found in the
AMGX Reference Guide.

The :py:meth:`~pyamgx.Config.create_from_file` method can be used
to read configuration settings from a JSON file instead:

.. code-block:: python

    cfg = pyamgx.Config()
    cfg.create_from_file('/path/to/GMRES.json')

After use, :py:class:`~pyamgx.Config` objects **must** be destroyed using the
:py:meth:`~pyamgx.Config.destroy` method.

.. code-block:: python

   cfg.destroy()

Resources objects
-----------------

:py:class:`~pyamgx.Resources` objects are used to specify the resources
(GPUs, MPI ranks) used by :py:class:`~pyamgx.Vector`, :py:class:`~pyamgx.Matrix`
and :py:class:`~pyamgx.Solver` objects.
Currently, pyamgx only supports "simple" :py:class:`~pyamgx.Resources` objects for
single threaded, single GPU applications.
created using the :py:meth:`~pyamgx.Resources.create_simple` method:

.. code-block:: python

   resources = pyamgx.Resources()
   resources.create_simple(cfg)

After use, :py:class:`~pyamgx.Resources` objects **must** be destroyed using the
:py:meth:`~pyamgx.Resources.destroy` method.

.. code-block:: python

   resources.destroy()

.. important::

   A :py:class:`~pyamgx.Resources` object should be destroyed only **after**
   all :py:class:`~pyamgx.Vector`, :py:class:`~pyamgx.Matrix` and :py:class:`~pyamgx.Solver`
   objects constructed from it are destroyed.

Vectors
-------

:py:class:`~pyamgx.Vector` objects store vectors on
either the host (CPU memory) or device (GPU memory).

The value of the optional `mode` argument to the :py:meth:`~pyamgx.Vector.create` method
specifies whether the data resides on the host or device.
If it is ``'dDDI'`` (default), the data resides on the device.
If it is ``'hDDI'``, the data resides on the host.

.. code-block:: python

   vec = pyamgx.Vector()
   vec.create(resources, mode='dDDI')

Values of :py:class:`~pyamgx.Vector` objects can be populated
in the following ways:

1. From an array using the :py:meth:`~pyamgx.Vector.upload` method

   .. code-block:: python

      vec.upload(np.array([1, 2, 3], dtype=np.float64))

2. Using the :py:meth:`~pyamgx.Vector.set_zero` method

   .. code-block:: python

      vec.set_zero(5) # implicitly allocates storage for the vector

3. From a raw pointer using the :py:meth:`~pyamgx.Vector.upload_raw` method.
   This allows uploading values from arrays already on the GPU,
   for instance from :py:class:`numba.cuda.device_array` objects.

   .. code-block:: python

      import numba.cuda

      a = np.array([1, 2, 3], dtype=np.float64)
      d_a = numba.cuda.to_device(a, dtype=np.float64))

      vec.upload_raw(d_a.device_ctypes_pointer.value, 3) # copies directly from GPU

After use, :py:class:`~pyamgx.Vector` objects **must** be destroyed using the
:py:meth:`~pyamgx.Vector.destroy` method.

Matrices
--------

:py:class:`~pyamgx.Matrix` objects store sparse matrices on
either the host (CPU memory) or device (GPU memory).

The value of the optional `mode` argument to the :py:meth:`~pyamgx.Matrix.create` method
specifies whether the data resides on the host or device.
If it is ``'dDDI'`` (default), the data resides on the device.
If it is ``'hDDI'``, the data resides on the host.

.. code-block:: python

   mat = pyamgx.Matrix()
   mat.create(resources, mode='dDDI')

:py:class:`~pyamgx.Matrix` objects store matrices
in the `CSR`_ sparse format.

Matrix data can be copied into the :py:class:`~pyamgx.Matrix`
object in the following ways:

1. From the arrays *row_ptrs*, *col_indices* and *data* that define
   the CSR matrix, using the :py:meth:`~pyamgx.Matrix.upload` method:

   .. code-block:: python

       mat.upload(
           row_ptrs=np.array([0, 2, 4], dtype=np.int32),
           col_indices=np.array([0, 1, 0, 1], dtype=np.int32),
           data=np.array([1., 2., 3., 4.], dtype=np.float64))

2. From a :py:class:`scipy.sparse.csr_matrix`,
   using the :py:meth:`~pyamgx.Matrix.upload_CSR` method:

   .. code-block:: python

      import scipy.sparse
      M = scipy.sparse.csr_matrix(np.random.rand(5, 5))

      mat.upload_CSR(M)

.. _CSR: https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_row_(CSR,_CRS_or_Yale_format)

After use, :py:class:`~pyamgx.Matrix` objects **must** be destroyed using the
:py:meth:`~pyamgx.Matrix.destroy` method.

Solvers
-------

A :py:class:`~pyamgx.Solver` encapsulates the linear solver specified
in the :py:class:`~pyamgx.Config` object.

The :py:meth:`~pyamgx.Solver.setup` method,
must be called prior to solving a linear system;
it sets the coefficient matrix of the linear system:

.. code-block:: python

   solver = pyamgx.Solver()
   solver.create(resources, cfg)

   solver.setup(mat)

The :py:meth:`~pyamgx.Solver.solve` method solves the linear system.
The two required parameters to :py:meth:`~pyamgx.Solver.solve`
the right hand side :py:class:`~pyamgx.Vector` `b` and
the solution vector :py:class:`~pyamgx.Vector` `x`
respectively.
The optional argument `zero_initial_guess` can be set to ``True`` to specify
that an initial guess of zero is to be used for the solution,
regardless of the values in `x`.

.. code-block:: python

   b = pyamgx.Vector().create(resources)
   x = pyamgx.Vector().create(resources)
   b.upload(np.random.rand(5))

   solver.solve(b, x, zero_initial_guess=True)

After use, :py:class:`~pyamgx.Solver` objects **must** be destroyed using the
:py:meth:`~pyamgx.Solver.destroy` method.

Typically, the :py:meth:`pyamgx.Solver.solve` method is called multiple times
(e.g., in a time-stepping simulation loop).
For the case in which the coefficient matrix remains fixed,
the :py:meth:`pyamgx.Solver.setup` method should only be called once
(prior to iteration).

If the coefficient matrix changes
at each iteration (e.g., in a non-linear solver),
the :py:meth:`pyamgx.Solver.setup` method should be called every iteration.
In this case, the :py:meth:`pyamgx.Matrix.replace_coefficients` method
can be used to update the values of the coefficient matrix,
as long as the location of non-zeros in the matrix remains the same.

