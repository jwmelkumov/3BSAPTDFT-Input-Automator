# Prepare:
- ${NAME}P.data
- ${NAME}A.dal
- corr
- trimer.info

# Modify:
$MAIN_SAPT_DIR/misc/daltutil/createtrimers

to either correctly parse from trimer.cnf
the atomsA, atomsB, and atomsC quantities,
or explicitly define them before running
gen_3saptdft_files.sh (they are the number
of atoms in monomer A, B, and C, respectively).

# Compile 
Compile programs in src/ and place binaries
in working directory along with prereq files:
```bash
gfortran gen_trimer_cnf.f95 -o gen_trimer_cnf
gfortran gen_dimer_cnf.f95 -o gen_dimer_cnf
gfortran gen_tempcoords.f95 -o gen_tempcoords
```
-------------------------------------------------
# Example usage:
-------------------------------------------------
```bash
./gen_3saptdft_files.sh meoh3 DCBS aug-cc-pVDZ
```
