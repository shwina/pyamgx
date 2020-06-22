from libc.stdint cimport uintptr_t

import numpy as np

cdef uintptr_t ptr_from_array_interface(data, check_for_dtype=None) except *:
    if hasattr(data, "__array_interface__"):
        desc = data.__array_interface__
    elif hasattr(data, "__cuda_array_interface__"):
        desc = data.__cuda_array_interface__
    else:
        raise TypeError("Must pass array-like for data")

    cdef uintptr_t ptr = desc["data"][0]

    if check_for_dtype:
        dtype = np.dtype(desc["typestr"])

        if dtype != check_for_dtype:
            raise ValueError("Invalid dtype: {}".format(dtype))

    return ptr
