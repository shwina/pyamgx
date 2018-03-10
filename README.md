# pyamgx: Python interface to NVIDIA's [AMGX](https://github.com/NVIDIA/AMGX) library

## Example usage

See `demo.py` for the full example.

```python
# Create matrices and vectors:
A = pyamgx.Matrix().create(rsc)
x = pyamgx.Vector().create(rsc)
b = pyamgx.Vector().create(rsc)

# Create solver:
solver = pyamgx.Solver().create(rsc, cfg)

# Upload system:
M = sparse.csr_matrix(np.random.rand(5, 5))
rhs = np.random.rand(5)
sol = np.zeros(5, dtype=np.float64)

A.upload_CSR(M)
b.upload(rhs)
x.upload(sol)

# Setup and solve:
solver.setup(A)
solver.solve(b, x)

# Download solution
x.download(sol)
print("pyamgx solution: ", sol)
print("scipy solution: ", splinalg.spsolve(M, rhs))
```

```
pyamgx solution:  [-0.52114365  0.72874012  0.17712795  1.37890116 -1.03672993]
scipy solution:  [-0.52114365  0.72874012  0.17712795  1.37890116 -1.03672993]
```

## Installation

### Requirements:

1. [AMGX](https://github.com/NVIDIA/AMGX)
1. [SciPy](https://www.scipy.org/scipylib/download.html)


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
$ pip install .
```

**Note:** If you do not have administrative priveleges
and if you are *not* installing inside a virtualenv or conda environment,
replace the last command above with:

```bash
$ pip install . --user
```

4. Run the demo:

```
$ python demo.py
```
