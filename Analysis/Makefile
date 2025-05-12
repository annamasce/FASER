EXE = AnalyReco.exe
EXE2 = plots.exe
EXE3 = AnalyReco_optim.exe

include ../Makefile.common

SRC = AnalyReco.cc
SRC2 = plots.C
SRC3 = AnalyReco_optim.cc

SRCCORE = $(wildcard $(COREUTILSDIR)/*.cc)
OBJCORE := $(SRCCORE:.cc=.o)

SRC += $(SRCCORE)
OBJ = $(SRC:.C=.o)
OBJ := $(OBJ:.cxx=.o)
OBJ := $(OBJ:.cc=.o)
OBJ += dict.o

OBJ2 = $(SRC2:.C=.o)

SRC3 += $(SRCCORE)
OBJ3 = $(SRC3:.C=.o)
OBJ3 := $(OBJ3:.cxx=.o)
OBJ3 := $(OBJ3:.cc=.o)
OBJ3 += dict.o

INCS = $(wildcard *.h)
INCS += $(wildcard *.hh)
INCS += $(wildcard $(COREUTILSDIR)/*.hh)

all : $(EXE) $(EXE2) $(EXE3)

dict.cxx : $(INCS) $(SRC)
	rootcling -f dict.cxx -c LinkDef.h -I$(COREUTILSDIR) -I$(GENFITINCDIR)

$(EXE) : $(OBJ) Makefile
	g++ $(ROOTCFLAGS) $(OBJ) `root-config --glibs` -lEG -lGeom $(GENFITLIBS) -o $@
	g++ -shared -o libTPORec.so dict.o $(OBJCORE) -L$(ROOTSYS)/lib `root-config --glibs` $(GENFITLIBS) 

$(EXE2): $(OBJ2) Makefile
	g++ -o $(EXE2) $(OBJ2) `root-config --glibs` -lRooFit -lRooFitCore

$(EXE3) : $(OBJ3) Makefile
	g++ $(ROOTCFLAGS) $(OBJ3) `root-config --glibs` -lEG -lGeom $(GENFITLIBS) -o $@
	g++ -shared -o libTPORec.so dict.o $(OBJCORE) -L$(ROOTSYS)/lib `root-config --glibs` $(GENFITLIBS)

# Compile source files to object files
%.o: %.C $(INCS)
	$(CXX) $(ROOTCFLAGS) -c $< -o $@
%.o: %.cc $(INCS)
	$(CXX) $(ROOTCFLAGS) -c $< -o $@
%.o: %.cxx $(INCS)
	$(CXX) $(ROOTCFLAGS) -c $< -o $@

# Clean target
clean:
	rm -f $(OBJ) $(EXE) $(OBJ3) $(EXE3) dict.cxx dict_rdict.pcm libTPORec.so

.PHONY : all clean

