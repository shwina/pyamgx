git clone https://github.com/NVIDIA/AMGX/
INSTALL_PREFIX=/usr/local
mkdir AMGX/build && cd AMGX/build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_NO_MPI=true ../
make
