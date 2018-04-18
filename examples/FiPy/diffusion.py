from fipy import *
nx = 2000
ny = nx
dx = 1.
dy = dx
L = dx * nx
mesh = Grid2D(dx=dx, dy=dy, nx=nx, ny=ny)

phi = CellVariable(name = "solution variable",
                   mesh = mesh,
                   value = 0.)

D = 1.

valueTopLeft = 0
valueBottomRight = 1

X, Y = mesh.faceCenters
facesTopLeft = ((mesh.facesLeft & (Y > L / 2))
                 | (mesh.facesTop & (X < L / 2)))
facesBottomRight = ((mesh.facesRight & (Y < L / 2))
                     | (mesh.facesBottom & (X > L / 2)))

phi.constrain(valueTopLeft, facesTopLeft)
phi.constrain(valueBottomRight, facesBottomRight)

timeStepDuration = 10 * 0.9 * dx**2 / (2 * D)
steps = 10

"""
DiffusionTerm().solve(var=phi)
"""
from pyamgx_solver import PyAMGXSolver

import pyamgx
pyamgx.initialize()
solver = PyAMGXSolver()

DiffusionTerm().solve(var=phi, solver=solver)

print(numerix.allclose(phi(((L,), (0,))), valueBottomRight, atol = 1e-2))

solver.destroy()
pyamgx.finalize()

print(phi(((nx/2,), (nx/2))))
