#!/bin/bash  
# This Makefile is used under Linux for mex file generation  
  
# Cluster = Matlab_2010b  
#MATLABDIR ?= /pkg/matlab_x86_64/R2010b  
  
# Firstname Surname workstation  
MATLABDIR ?= /home/xren/programs/others/octave
# for Mac  
# MATLABDIR ?= /opt/local/matlab  
  
INTEL = /opt/intel/composerxe-2011.4.191
MKLROOT = $(INTEL)/mkl/lib/intel64  

CC = icc  
CXX = icpc  
# -Wall -Wconversion and -fPIC are required for the mex  
CFLAGS = -Wall -Wconversion -fPIC -O3 -DMKL_ILP64 -I$(MATLABDIR)/extern/include -limf -L$(MKLROOT) -Wl,--start-group -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -Wl,--end-group -lpthread -msse3 -ffast-math
  
MEX = $(MATLABDIR)/bin/mex  
#MEX_OPTION = CXX\\#$(CXX) CXXFLAGS\\#"$(CFLAGS)"  
MEX_OPTION = CC=icc CXX=icpc
# comment the following line if you use MATLAB on 32-bit  
MEX_OPTION += -largeArrayDims  
MEX_EXT = $(MATLABDIR)/bin/mexext  
  
  
all:    matlab  
  
matlab: binary  
  
binary: ompmex.$(MEX_EXT)   
  
ompmex.$(MEX_EXT):       
	$(MEX) $(MEX_OPTION) ompmex.c mexutils.c  myblas.c  ompcore.c  ompprof.c  omputils.c
 
clean:  
	rm -f *~ *.o *.mex* *.obj  
