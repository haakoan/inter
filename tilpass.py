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
