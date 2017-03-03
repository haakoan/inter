Interface used to connect the fortran routine toms660 to python.
The fortran code is taken from https://people.sc.fsu.edu/~jburkardt/f_src/toms660/toms660.html
and was written by John Burkardt. He adopted it from the code of by Robert Renka, which is 
a fortran 77 version. The source code by Burkardt can be found in toms660.F90.
<br />
The original lib is found here:<br />
http://www.netlib.org/toms/index.html<br />
gams: E2b<br />
title: QSHEP2D<br />
for: quadratic Shepard method for bivariate interpolation of scattered data <br />
by: R. J. Renka<br />
ref: ACM TOMS 14 (1988) 149-150<br />
<br />
The module t660 is the python3 version, and the module t660py2 is the python2 version.
The files have been build using f2py3 and f2py. If you want to rebuild the libs
you should run:<br />
 
f2py3 -c t660.f90 toms660.f90 t660.pyf (Python3) <br />
f2py -c t660.f90 toms660.f90 t660py2.pyf (Python2)<br />
<br />
The files you want are t660.cpython-34m.so and t660py2.so. Just copy them
into your working dir or to your python-lib path.
<br />
Python3 code testing the lib.<br />
The result is shown in the figure below. Left interpolated version, right input data.
```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import t660
import time
#Interpolate a large scatterd grid                                                                                     
x = np.random.uniform(0,10,1048576)
y = np.random.uniform(0,10,1048576)
# data = np.random.uniform(1,200,1048576)                                                                              
def func(x1, y1):
    return np.cos(0.5*np.pi*x1) + np.sin(0.5*np.pi*y1)
data = func(x,y)
n = len(data)
nq = 13
nw = 19
nr = int(np.sqrt(n/3))
start = time.clock()
lcell,lnext,xmin,ymin,dx,dy,rmax,rsq,a,ier = t660.int2d(n,x,y,data,nq,nw,nr)
end = time.clock()
print(end-start)

start = time.clock()
inp = t660.eval2d(x[15],y[15],n,x,y,data,nr,lcell,lnext,xmin,ymin,dx,dy,rmax,rsq,a)
end = time.clock()
print(end-start)

print(inp,data[15])


#Cheek that it works                                                                                                   
x = np.random.uniform(0,10,1048)
y = np.random.uniform(0,10,1048)
data = func(x,y)
n = len(data)
nq = 13
nw = 19
nr = int(np.sqrt(n/3))
lcell,lnext,xmin,ymin,dx,dy,rmax,rsq,a,ier = t660.int2d(n,x,y,data,nq,nw,nr)


xi = np.linspace(0,10,200)
yi = np.linspace(0,10,200)
datai = np.ones([200,200])
for i in range(1,200):
    for j in range(1,200):
        datai[i,j] = t660.eval2d(xi[i],yi[j],n,x,y,data,nr,lcell,lnext,xmin,ymin,dx,dy,rmax,rsq,a)
x12 = np.sort(x)
y12 = np.sort(y)
datap = func(x12[:,None],y12[None,:])
f, ax =  plt.subplots(figsize=(12,12),nrows=1,ncols=2)
ax[0].contourf(xi,yi,datai)
ax[1].contourf(x12,y12,datap)
plt.savefig('iptest2.png',bbox_inches='tight')
```

![alt tag](https://github.com/haakoan/inter/blob/master/iptest2.png)
