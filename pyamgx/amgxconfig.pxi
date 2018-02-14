
cdef extern from "amgx_config.h":

    ctypedef enum AMGX_MemorySpace:
        AMGX_host
        AMGX_device
        AMGX_memorySpaceNum = 16

    ctypedef enum AMGX_ScalarPrecision:
        AMGX_double
        AMGX_float
        AMGX_int
        AMGX_doublecomplex
        AMGX_complex
        AMGX_usint
        AMGX_uint
        AMGX_uint64
        AMGX_int64
        AMGX_bool
        AMGX_scalarPrecisionNum = 1

    ctypedef enum AMGX_VecPrecision:
        AMGX_vecDouble = AMGX_double
        AMGX_vecFloat = AMGX_float
        AMGX_vecDoubleComplex = AMGX_doublecomplex
        AMGX_vecComplex = AMGX_complex
        AMGX_vecInt = AMGX_int
        AMGX_vecUSInt = AMGX_usint
        AMGX_vecUInt = AMGX_uint
        AMGX_vecUInt64 = AMGX_uint64
        AMGX_vecInt64 = AMGX_int64
        AMGX_vecBool = AMGX_bool
        AMGX_vecPrecisionNum = AMGX_scalarPrecisionNum
        AMGX_VecPrecisionInst

    ctypedef enum AMGX_MatPrecision:
        AMGX_matDouble = AMGX_double
        AMGX_matFloat = AMGX_float
        AMGX_matDoubleComplex = AMGX_doublecomplex
        AMGX_matComplex = AMGX_complex
        AMGX_matInt = AMGX_int
        AMGX_matPrecisionNum = AMGX_scalarPrecisionNum
        AMGX_MatPrecisionInst

    ctypedef enum AMGX_IndPrecision:
        AMGX_indInt = AMGX_int
        AMGX_indInt64 = AMGX_int64
        AMGX_indPrecisionNum = AMGX_scalarPrecisionNum
        AMGX_IndPrecisionInst

    ctypedef enum AMGX_ModeNums:
        AMGX_MemorySpaceBase = 1
        AMGX_MemorySpaceSize = AMGX_memorySpaceNum,
        AMGX_VecPrecisionBase = AMGX_MemorySpaceBase * AMGX_MemorySpaceSize,
        AMGX_VecPrecisionSize = AMGX_vecPrecisionNum,
        AMGX_MatPrecisionBase = AMGX_VecPrecisionBase * AMGX_VecPrecisionSize,
        AMGX_MatPrecisionSize = AMGX_matPrecisionNum,
        AMGX_IndPrecisionBase = AMGX_MatPrecisionBase * AMGX_MatPrecisionSize,
        AMGX_IndPrecisionSize = AMGX_indPrecisionNum

    ctypedef enum AMGX_Mode:
        AMGX_unset = -1
        AMGX_modeRange = (AMGX_memorySpaceNum * AMGX_vecPrecisionNum *
                          AMGX_matPrecisionNum * AMGX_indPrecisionNum)
        AMGX_mode_hDDI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecDouble*AMGX_VecPrecisionBase +
                          AMGX_matDouble*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hDFI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecDouble*AMGX_VecPrecisionBase +
                          AMGX_matFloat*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hFFI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecFloat*AMGX_VecPrecisionBase +
                          AMGX_matFloat*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dDDI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecDouble*AMGX_VecPrecisionBase +
                          AMGX_matDouble*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dDFI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecDouble*AMGX_VecPrecisionBase +
                          AMGX_matFloat*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dFFI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecFloat*AMGX_VecPrecisionBase +
                          AMGX_matFloat*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hIDI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecInt*AMGX_VecPrecisionBase +
                          AMGX_matDouble*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hIFI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecInt*AMGX_VecPrecisionBase +
                          AMGX_matFloat*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dIDI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecInt*AMGX_VecPrecisionBase +
                          AMGX_matDouble*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dIFI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecInt*AMGX_VecPrecisionBase +
                          AMGX_matFloat*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hZZI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecDoubleComplex*AMGX_VecPrecisionBase +
                          AMGX_matDoubleComplex*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hZCI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecDoubleComplex*AMGX_VecPrecisionBase +
                          AMGX_matComplex*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_hCCI = (AMGX_host*AMGX_MemorySpaceBase +
                          AMGX_vecComplex*AMGX_VecPrecisionBase +
                          AMGX_matComplex*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dZZI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecDoubleComplex*AMGX_VecPrecisionBase +
                          AMGX_matDoubleComplex*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dZCI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecDoubleComplex*AMGX_VecPrecisionBase +
                          AMGX_matComplex*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_mode_dCCI = (AMGX_device*AMGX_MemorySpaceBase +
                          AMGX_vecComplex*AMGX_VecPrecisionBase +
                          AMGX_matComplex*AMGX_MatPrecisionBase +
                          AMGX_indInt*AMGX_IndPrecisionBase)
        AMGX_modeNum = 10
        AMGX_ModeInst

cdef inline AMGX_Mode asMode(object mode):
    if isinstance(mode, str):
        if (mode == 'hDDI'):
            return AMGX_mode_hDDI
        if (mode == 'hDFI'):
            return AMGX_mode_hDFI
        if (mode == 'hFFI'):
            return AMGX_mode_hFFI
        if (mode == 'dDDI'):
            return AMGX_mode_dDDI
        if (mode == 'dDFI'):
            return AMGX_mode_dDFI
        if (mode == 'dFFI'):
            return AMGX_mode_dFFI
        if (mode == 'hIDI'):
            return AMGX_mode_hIDI
        if (mode == 'hIFI'):
            return AMGX_mode_hIFI
        if (mode == 'dIDI'):
            return AMGX_mode_dIDI
        if (mode == 'dIFI'):
            return AMGX_mode_dIFI
        if (mode == 'hZZI'):
            return AMGX_mode_hZZI
        if (mode == 'hZCI'):
            return AMGX_mode_hZCI
        if (mode == 'hCCI'):
            return AMGX_mode_hCCI
        if (mode == 'dZZI'):
            return AMGX_mode_dZZI
        if (mode == 'dZCI'):
            return AMGX_mode_dZCI
        if (mode == 'dCCI'):
            return AMGX_mode_dCCI
