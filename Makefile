#
# To build with a different compiler / on a different platform, use
#     make PLATFORM=xxx
#
# where xxx is
#     icc = Intel compilers
#     gcc = GNU compilers
#     clang = Clang compiler (OS X default)
#
# Or create a Makefile.in.xxx of your own!
#

PLATFORM=icc
include Makefile.in.$(PLATFORM)

.PHONY: exe clean realclean


# === Executables

exe: path-mpi.x

path.x: path.o mt19937p.o
	$(CC) $(OMP_CFLAGS) $^ -o $@

path.o: path.c
	$(CC) -c $(OMP_CFLAGS) $<

path-mpi.x: path-mpi.o mt19937p.o
	$(MPICC) $(MPI_CFLAGS) $^ -o $@

path-mpi.o: path-mpi.c
	$(MPICC) -c $(MPI_CFLAGS) $<

path-blocked.x: path-blocked.o mt19937p.o
	$(CC) $(OMP_CFLAGS) $^ -o $@

path-blocked.o: path-blocked.c
	$(CC) -c $(OMP_CFLAGS) $<

path-blocked-device.x: path-blocked-device.o mt19937p.o
	$(CC) $(OMP_CFLAGS) $^ -o $@

path-blocked-device.o: path-blocked-device.c
	$(CC) -c $(OMP_CFLAGS) $<

path-blocked-device-naive.x: path-blocked-device-naive.o mt19937p.o
	$(CC) $(OMP_CFLAGS) $^ -o $@

path-blocked-device-naive.o: path-blocked-device-naive.c
	$(CC) -c $(OMP_CFLAGS) $<

%.o: %.c
	$(CC) -c $(CFLAGS) $<


# === Documentation

main.pdf: README.md path.md
	pandoc $^ -o $@

path.md: path.c
	ldoc -o $@ $^


# === Cleanup and tarball

clean:
	rm -f *.o

realclean: clean
	rm -f path.x path-mpi.x path-blocked.x path-blocked-device.x path-blocked-device-naive.x
