# pyamgx: Python interface to NVIDIA's [AMGX](https://github.com/NVIDIA/AMGX) library

```bash
$ python demo.py

AMGX version 2.0.0.130-opensource
Built on Feb  7 2018, 21:25:07
Compiled with CUDA Runtime 8.0, using CUDA driver 8.0
Reading data...
RHS vector was not found. Using RHS b=[1,...,1]^T
Solution vector was not found. Setting initial solution to x=[0,...,0]^T
Finished reading
AMG Grid:
         Number of Levels: 1
            LVL         ROWS               NNZ    SPRSTY       Mem (GB)
         --------------------------------------------------------------
           0(D)           12                61     0.424       8.75e-07
         --------------------------------------------------------------
         Grid Complexity: 1
         Operator Complexity: 1
         Total Memory Usage: 8.75443e-07 GB
         --------------------------------------------------------------
           iter      Mem Usage (GB)       residual           rate
         --------------------------------------------------------------
            Ini            0.408447   3.464102e+00
              0            0.408447   1.619840e-14         0.0000
         --------------------------------------------------------------
         Total Iterations: 1
         Avg Convergence Rate:               0.0000
         Final Residual:           1.619840e-14
         Total Reduction in Residual:      4.676075e-15
         Maximum Memory Usage:                0.408 GB
         --------------------------------------------------------------
Total Time: 0.00222678
    setup: 0.00149533 s
    solve: 0.000731456 s
    solve(per iteration): 0.000731456 s

```

## Installation

### Requirements:

1. [AMGX](https://github.com/NVIDIA/AMGX)
2. [Cython](https://github.com/cython/cython)


### Install:

1. Set the environment variable `AMGX_DIR` to the AMGX root directory.

2. Clone this repository:

```bash
$ git clone https://github.com/shwina/pyamgx
```

3. Build and install `pyamgx`:

```bash
$ cd pyamgx
$ python setup.py build_ext
$ pip install . --user
```

4. Run the demo:

```
$ python demo.py
```
