Installation
============

pyamgx has been tested only on Linux,
though it should be possible to install on Windows as well.

Requirements
------------

Before installing pyamgx, you should ensure the following
software packages are installed:

1. The `AMGX <https://github.com/NVIDIA/AMGX>`_ library.
   The distributed (MPI) version of AMGX is not required.

2. Python 2 >= 2.7 or Python 3 >= 3.5. If you are using Python 2 < 2.7.9,
   you will need to `install pip <https://pip.pypa.io/en/stable/installing/#installation>`_.

3. Python libraries
   `SciPy <https://www.scipy.org/scipylib/>`_
   and
   `Cython <http://cython.org/>`_.
   It is highly recommended to
   `use pip <https://www.scipy.org/install.html#installing-via-pip>`_
   to install these packages:

   .. code-block:: bash

      $ pip install scipy cython

   If you are using the
   `Anaconda <https://docs.anaconda.com/anaconda/>`_
   distribution, these packages should already be installed.

Building and installing pyamgx
------------------------------

Get the source code
^^^^^^^^^^^^^^^^^^^

Download the pyamgx source
either by visiting https://github.com/shwina/pyamgx and clicking
"Clone or Download", or if you have Git, running the following command:

.. code-block:: bash

   $ git clone https://github.com/shwina/pyamgx

Install pyamgx
^^^^^^^^^^^^^^

.. code-block:: bash

   $ cd pyamgx
   $ pip install .

