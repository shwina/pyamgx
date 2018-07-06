Quick start
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

:py:class:`~pyamgx.Config` objects are used to store configurations
for :py:class:`~pyamgx.Resource` and :py:class:`~pyamgx.Solver` objects.
:py:class:`~pyamgx.Config` objects can be constructed from
JSON files or :py:class:`dict` objects.
Example configurations can be found
`here <https://github.com/NVIDIA/AMGX/tree/master/core/configs>`_.

.. code-block:: python

   cfg = pyamgx.Config()
   cfg.create_from_file("/path/to/config.json")
   cfg.create_from_dict({"max_levels": 10})

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
:py:meth:`~pyamgx.Resources.destroy` method **after** all
:py:class:`~pyamgx.Vector`, :py:class:`~pyamgx.Matrix` and :py:class:`~pyamgx.Solver`
classes constructed from the :py:class:`~pyamgx.Resouces` object are destroyed.

.. code-block:: python

   # destroy Solver, Matrix and Vector objects first.
   resources.destroy()

Vectors
-------

:py:class:`~pyamgx.Vector` objects store vectors on
either the host (CPU memory) or device (GPU memory).
The value of the *mode* argument to the :py:meth:`~pyamgx.Vector.create` method
specifies whether the data resides on the host or device.

.. code-block:: python

   vec = pyamgx.Vector()
   vec.create(resources, mode='dDDI')

Values of :py:class:`~pyamgx.Vector` objects can be populated
in two ways:

1. From NumPy :py:class:`numpy.ndarray` using the :py:meth:`~pyamgx.Vector.upload` method.
2. Using the :py:meth:`~pyamgx.Vector.set_zero` method.

Matrices
--------

Solvers
-------
