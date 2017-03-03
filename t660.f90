!module t660_interface
!This file defines the interface used to connect the fortran routine toms660 to python.
!The fortran code is taken from https://people.sc.fsu.edu/~jburkardt/f_src/toms660/toms660.html
!and was written by John Burkardt. He adopted it from the code of by Robert Renka, which is 
!a fortran 77 version. The source code by Burkardt can be found in toms660.F90.  
!The original lib is found here:
!http://www.netlib.org/toms/index.html
!gams: E2b
!title: QSHEP2D
!for: quadratic Shepard method for bivariate interpolation of scattered data
!by: R. J. Renka
!ref: ACM TOMS 14 (1988) 149-150
!
! Writen by: Haakon Andresen, haakoan@gmail.com. Use this code as you wish
! The originale code is subject to the ACM Software Copyright. This code is then subject to the same restrictions.
!
!contains
subroutine int2d( n, x, y, f, nq, nw, nr, lcell, lnext, xmin, ymin, dx, dy, rmax, rsq, a, ier )
    use toms660
    integer(kind=4) :: n !Input, integer N, the number of nodes
    real(kind=8), intent(in), dimension(n) :: x !Input, real ( kind = 8 ) y(n) the x-coordinate
    real(kind=8), intent(in), dimension(n) :: y !Input, real ( kind = 8 ) x(n) the y-coordinate
    real(kind=8), intent(in), dimension(n) :: f !Input, real ( kind = 8 ) f(n) the data points
    !Input, integer NQ, the number of data points to be used in the least squares fit for coefficients defining the nodal functions Q(K).  
    !A highly recommended value is NQ = 13.  NQ must be at least 5, and no greater than the minimum of 40 and N-1.    
    integer(kind=4), intent(in) :: nq
    !Input, integer NW, the number of nodes within (and defining) the radii
    !of influence R(K) which enter into the weights W(K).  For N 
    !sufficiently large, a recommended value is NW = 19.   NW must be
    !at least 1, and no greater than the minimum of 40 and N-1.
    integer(kind=4), intent(in) :: nw
    !Input, integer NR, the number of rows and columns in the cell grid 
    !defined in subroutine STORE2.  A rectangle containing the nodes 
    !is partitioned into cells in order to increase search efficiency.  
    !NR = SQRT(N/3) is recommended.  NR must be at least 1.
    integer(kind=4), intent(in) :: nr
    !Output, integer LCELL(NR,NR), array of nodal indices associated with cells.
    integer(kind=4), intent(out), dimension(nr,nr) :: lcell
    !Output, integer LNEXT(N), contains next-node indices ( or their negatives ).
    integer(kind=4), intent(out), dimension(n) :: lnext
    !Output, real ( kind = 8 ) XMIN, YMIN, DX, DY, the minimum nodal X, Y coordinates, and the X, Y dimensions of a cell.
    real(kind=8), intent(out) :: xmin
    real(kind=8), intent(out) :: ymin
    real(kind=8), intent(out) :: dx
    real(kind=8), intent(out) :: dy
    !Output, real ( kind = 8 ) RMAX, the square root of the largest element in RSQ, the maximum radius of influence.
    real(kind=8), intent(out) :: rmax
    !Output, real ( kind = 8 ) RSQ(N), the squared radii which enter into the weights defining the interpolant Q.
    real(kind=8), intent(out),dimension(n) :: rsq
    !Output, real ( kind = 8 ) A(5,N), the coefficients for the nodal functions defining the interpolant Q.
    real(kind=8), intent(out), dimension(5,n) :: a
    !Output, integer IER, error indicator.
    !0, if no errors were encountered.
    !1, if N, NQ, NW, or NR is out of range.
    !2, if duplicate nodes were encountered.
    !3, if all nodes are collinear.
    integer(kind=4), intent(out) :: ier
 
  call qshep2 ( n, x, y, f, nq, nw, nr, lcell, lnext, xmin, ymin, dx, dy, rmax, rsq, a, ier)
  return
end subroutine int2d

subroutine eval2d(px, py, n, x, y, f, nr, lcell, lnext, xmin, ymin, dx, dy, rmax, rsq, a,val)
    use toms660
    real(kind=8), intent(in) :: px
    real(kind=8), intent(in) :: py
    integer(kind=4) :: n !Input, integer N, the number of nodes
    real(kind=8), intent(in), dimension(n) :: x !Input, real ( kind = 8 ) y(n) the x-coordinate
    real(kind=8), intent(in), dimension(n) :: y !Input, real ( kind = 8 ) x(n) the y-coordinate
    real(kind=8), intent(in), dimension(n) :: f !Input, real ( kind = 8 ) f(n) the data points
    !Input, integer NR, the number of rows and columns in the cell grid 
    !defined in subroutine STORE2.  A rectangle containing the nodes 
    !is partitioned into cells in order to increase search efficiency.  
    !NR = SQRT(N/3) is recommended.  NR must be at least 1.
    integer(kind=4), intent(in) :: nr
    !input, integer LCELL(NR,NR), array of nodal indices associated with cells.
    integer(kind=4), intent(in), dimension(nr,nr) :: lcell
    !input, integer LNEXT(N), contains next-node indices ( or their negatives ).
    integer(kind=4), intent(in), dimension(n) :: lnext
    !input, real ( kind = 8 ) XMIN, YMIN, DX, DY, the minimum nodal X, Y coordinates, and the X, Y dimensions of a cell.
    real(kind=8), intent(in) :: xmin
    real(kind=8), intent(in) :: ymin
    real(kind=8), intent(in) :: dx
    real(kind=8), intent(in) :: dy
    !Output, real ( kind = 8 ) RMAX, the square root of the largest element in RSQ, the maximum radius of influence.
    real(kind=8), intent(in) :: rmax
    !input, real ( kind = 8 ) RSQ(N), the squared radii which enter into the weights defining the interpolant Q.
    real(kind=8), intent(in),dimension(n) :: rsq
    !input, real ( kind = 8 ) A(5,N), the coefficients for the nodal functions defining the interpolant Q.
    real(kind=8), intent(in), dimension(5,n) :: a
    !output, the interpolated value
    real(kind=8), intent(out) :: val
    val =  qs2val ( px, py, n, x, y, f, nr, lcell, lnext, xmin, ymin, dx, dy, rmax, rsq, a )
   return

end subroutine eval2d


!end module t660_interface
