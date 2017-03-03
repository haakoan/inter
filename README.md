Interface used to connect the fortran routine toms660 to python.
The fortran code is taken from https://people.sc.fsu.edu/~jburkardt/f_src/toms660/toms660.html
and was written by John Burkardt. He adopted it from the code of by Robert Renka, which is 
a fortran 77 version. The source code by Burkardt can be found in toms660.F90.

The original lib is found here:
http://www.netlib.org/toms/index.html
gams: E2b
title: QSHEP2D
for: quadratic Shepard method for bivariate interpolation of scattered data
by: R. J. Renka
ref: ACM TOMS 14 (1988) 149-150

The module t660 is the python3 version, and the module t660py2 is the python2 version.
The files have been build using f2py3 and f2py. If you want to rebuild the libs
you should run:
 
f2py3 -c t660.f90 toms660.f90 t660.pyf (Python3)
f2py -c t660.f90 toms660.f90 t660py2.pyf (Python2)


