program gen_tempcoords
! - John Melkumov 2/21/2024
    implicit none
    character(len=100) :: monomer_label(3) = ['MONOMER_A', 'MONOMER_B', &
                                              'MONOMER_C']
    integer, parameter :: maxsites = 10000
    character(len=100) :: line
    character(len=100) :: system_name
    integer :: num_atoms_total
    real, allocatable :: x(:,:), y(:,:), z(:,:)
    real, allocatable :: nuc_charge(:,:), atm_mass(:,:)
    character(len=4), allocatable :: atom_name(:,:)
    integer :: num_atoms(maxsites)
    integer :: i,j

    ! Open input file
    open(unit=10, file='trimer.info', status='old', action='read')
    ! Open output file
    open(unit=40, file='tempcoords', status='replace', action='write')

    ! Read system name and number of atoms
    read(10, *) system_name
    read(10, *) num_atoms_total
   
    allocate( atom_name(3,maxsites), x(3,maxsites), y(3,maxsites), z(3,maxsites), &
              nuc_charge(3,maxsites), atm_mass(3,maxsites) )   

    ! Loop through each monomer section
    do i = 1, 3
        do
            read(10, '(A100)', end=10) line
            if (trim(line) == trim(monomer_label(i))) then
                write(*,*) monomer_label(i)
                exit
            end if
        end do
        
        ! Read number of atoms for each monomer
        if (monomer_label(1) == 'MONOMER_A') then
            read(10, *) num_atoms(i)
            write(*,*) num_atoms(i)
        else if (monomer_label(2) == 'MONOMER_B') then
            read(10, *) num_atoms(i)
        else if (monomer_label(3) == 'MONOMER_C') then
            read(10, *) num_atoms(i)
        end if
        write(*,*) ' numatoms i = ', num_atoms(i)
        ! Read atomic coordinates, nuclear charges, and masses
        do j = 1, num_atoms(i)
            read(10, *) atom_name(i,j), x(i,j), y(i,j), z(i,j), nuc_charge(i,j), atm_mass(i,j)
            write(*,*) 'atomnameij = ', atom_name(i,j)
            write(40, '(A1, 3X, 3F20.13)') trim(atom_name(i,j)), x(i,j), y(i,j), z(i,j)
        end do
    end do
 
    close(10)
    close(40)

10 continue

end program gen_tempcoords
