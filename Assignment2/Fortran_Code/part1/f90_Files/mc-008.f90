! file: mc-008.f90
!
! Lennard-Jones particles
!  (truncated)
!
! Marcelo A. Carignano
! Chemistry - Purdue U.
! February 2008
!

program lennard
  implicit none

  integer :: i,j
  integer, parameter :: np=20
  real :: x(np)=0,y(np)=0,z(np)=0
  real :: box,vol,ndens
  real :: hbox
  real :: rcut
  real :: eps,sig
  
  real :: ddx,ddy,ddz,dd
  real :: u
      
  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*

  eps=0.650d0
  sig=0.3166d0

  rcut=0.7d0
  
  print*,' Lennard-Jones parameters:'
  print*,'   eps= ',eps,' kJ/mol'
  print*,'   sig= ',sig,' nm'
  print*,'  rcut= ',rcut,' nm'
  print*

  box=1.5d0
  hbox=box/2.0
  vol=box**3
  ndens=np/vol

  print*,' Simulation box length: ',box
  print*,' Volume               : ',vol
  print*,' Number density       : ',ndens
  print*

  print*,' Initial coordinates'
  
  do i=1,np
     x(i)=ran()*box
     y(i)=ran()*box
     z(i)=ran()*box
     print*,i,x(i),y(i),z(i)
  enddo

  call energy(u,np,x,y,z,eps,sig,box,hbox,rcut,0)

  print*
  print*,' Initial Potential Energy: ',u 
  print*

  stop
end program lennard

!------------------------------------------------------------------
!------------------------------------------------------------------

subroutine energy(u,np,x,y,z,eps,sig,box,hbox,rcut,it)

  implicit none
  integer :: np,it
  real :: u,eps,sig,box,hbox,rcut
  real :: x(np),y(np),z(np)

  integer :: i,j
  real :: ddx,ddy,ddz,dd

  if (it == 0) then           ! 'it' is a flag to be used later
                              !   it=0 means to calculate the total energy
     u=0.0e0

     do i=1,np-1
        do j=i+1,np
           
           ddx=x(i)-x(j)
           ddy=y(i)-y(j)
           ddz=z(i)-z(j)

           if (ddx > hbox) ddx=ddx-box
           if (ddy > hbox) ddy=ddy-box
           if (ddz > hbox) ddz=ddz-box
           
           if (ddx < -hbox) ddx=ddx+box
           if (ddy < -hbox) ddy=ddy+box
           if (ddz < -hbox) ddz=ddz+box
           
           dd=sqrt(ddx*ddx+ddy*ddy+ddz*ddz)
           
           if (dd <= rcut) then
              u = u + ( (sig/dd)**12 - (sig/dd)**6 )  
           endif

        enddo
     enddo

     u=u*4.0*eps

  endif

  return
end subroutine energy
