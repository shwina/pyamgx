from fipy.solvers.solver import Solver
from fipy.matrices.scipyMatrix import _ScipyMeshMatrix
from fipy.tools import numerix

import numpy
from scipy.sparse import csr_matrix
import pyamgx
import os

class PyAMGXSolver(Solver):
    """
    The PyAMGXSolver class.
    """

    def __init__(self, *args, **kwargs):
        self.create()

    def create(self):
        self.cfg = pyamgx.Config().create_from_file(os.environ["AMGX_DIR"]+"/core/configs/AMG_CLASSICAL_PMIS.json")
        self.resources = pyamgx.Resources().create_simple(self.cfg)
        self.x_gpu = pyamgx.Vector().create(self.resources)
        self.b_gpu = pyamgx.Vector().create(self.resources)
        self.A_gpu = pyamgx.Matrix().create(self.resources)
        self.solver = pyamgx.Solver().create(self.resources, self.cfg)
        return self

    @property
    def _matrixClass(self):
        return _ScipyMeshMatrix

    def _storeMatrix(self, var, matrix, RHSvector):
        self.var = var
        self.matrix = matrix
        self.RHSvector = RHSvector

        self.A_gpu.upload_CSR(self.matrix.matrix)
        self.solver.setup(self.A_gpu)

    def _solve_(self, L, x, b):
        relres=[]
        
        # transfer data from CPU to GPU
        self.x_gpu.upload(x)
        self.b_gpu.upload(b)
        
        # solve system on GPU

        self.solver.solve(self.b_gpu, self.x_gpu)

        # download values from GPU to CPU
        self.x_gpu.download(x)

    def _solve(self):
        self._solve_(self.matrix, self.var.ravel(), numerix.array(self.RHSvector))
        pass
            
    def _canSolveAssymetric(self):
        return False

    def destroy(self):
        self.A_gpu.destroy()
        self.b_gpu.destroy()
        self.x_gpu.destroy()
        self.solver.destroy()
        self.resources.destroy()
        self.cfg.destroy()
