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
