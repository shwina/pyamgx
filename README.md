# pyamgx: Python interface to NVIDIA's [AMGX](https://github.com/NVIDIA/AMGX) library

```bash
[atrikut@node1982 pyamgx]$ python demo.py
AMGX version 2.0.0.130-opensource
Built on Feb  6 2018, 20:25:44
Compiled with CUDA Runtime 8.0, using CUDA driver 9.0
AMG Grid:
         Number of Levels: 1
            LVL         ROWS               NNZ    SPRSTY       Mem (GB)
         --------------------------------------------------------------
           0(D)            5                25         1       3.69e-07
         --------------------------------------------------------------
         Grid Complexity: 1
         Operator Complexity: 1
         Total Memory Usage: 3.68804e-07 GB
         --------------------------------------------------------------
           iter      Mem Usage (GB)       residual           rate
         --------------------------------------------------------------
            Ini            0.420471   1.374279e+00
              0            0.420471   3.790535e-16         0.0000
         --------------------------------------------------------------
         Total Iterations: 1
         Avg Convergence Rate:               0.0000
         Final Residual:           3.790535e-16
         Total Reduction in Residual:      2.758200e-16
         Maximum Memory Usage:                0.420 GB
         --------------------------------------------------------------
Total Time: 0.00920678
    setup: 0.00825632 s
    solve: 0.000950464 s
    solve(per iteration): 0.000950464 s
pyamgx solution:  [-0.52114365  0.72874012  0.17712795  1.37890116 -1.03672993]
scipy solution:  [-0.52114365  0.72874012  0.17712795  1.37890116 -1.03672993]
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
