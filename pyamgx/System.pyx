import numpy as np
cimport numpy as np


def pin_memory(double[:] data):
    """
    Notify the operating system that the
    underlying buffer of `data` is to be
    pinned to reside in physical memory.

    Parameters
    ----------
    data : numpy.ndarray, double
        The array containing data to be pinned.
    """
    check_error(AMGX_pin_memory(
        &data[0], data.nbytes))


def unpin_memory(double[:] data):
    """
    Notify the operating system that the
    underlying buffer of `data` is to be
    unpinned

    Parameters
    ----------
    data : numpy.ndarray, double
        The array containing data to be unpinned.
    """
    check_error(AMGX_unpin_memory(
        &data[0]))


def install_signal_handler():
    """
    Cause AMGX to install its default signal handlers.
    """
    check_error(AMGX_install_signal_handler())


def reset_signal_handler():
    """
    Cause AMGX to restore previous signal handlers.
    """
    check_error(AMGX_reset_signal_handler())


cdef void c_register_print_callback(AMGX_print_callback function):
    AMGX_register_print_callback(function)

cdef void c_print_callback(char *msg, int length) noexcept:
    global print_callback
    print_callback(msg.decode('utf-8'))

def register_print_callback(f):
    """
    register_print_callback(f)

    Register a user-provided callback function
    for handling text output from calls to AMGX functions.
    The callback function should accept
    a single argument (a string containing the text output).

    Parameters
    ----------
    f : function
        Python function that accepts a string as input

    Examples
    --------

    >>> import pyamgx
    >>> import time
    >>> import pyamgx
    >>> pyamgx.initialize()
    >>> pyamgx.register_print_callback(lambda msg: print('{}: {}'.format(time.asctime(), msg)))
    >>> cfg = pyamgx.Config().create("")
    Fri Aug 10 07:23:25 2018: Cannot read file as JSON object, trying as AMGX config
    >>> cfg.destroy()
    >>> pyamgx.finalize()


    """
    # print_callback is defined globally as
    # there is no other way to access it from
    # c_print_callback.
    # If c_print_callback could accept an additional void* argument
    # as a user-provided context,
    # print_callback can be passed as that argument without
    # defining it globally.
    global print_callback
    print_callback = f
    c_register_print_callback(c_print_callback)
