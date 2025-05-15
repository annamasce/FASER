# Compiler
CXX = g++

# ROOT flags
ROOTCFLAGS := $(shell root-config --cflags)
ROOTLIBS := $(shell root-config --libs)
ROOTGLIBS := $(shell root-config --glibs)

# Directories
SRCDIR = ../../CoreUtils
SRCDIR2 = ../CoreUtils
BUILDDIR = build_p
TARGET = PlotGDML

# Source files
SOURCES = $(SRCDIR)/TcalEvent.cc $(SRCDIR)/TPORecoEvent.cc $(SRCDIR)/TPOEvent.cc PlotGDML.cxx

# Object files
OBJECTS = $(SOURCES:%.cc=$(BUILDDIR)/%.o)
OBJECTS := $(OBJECTS:%.cxx=$(BUILDDIR)/%.o)

# Headers
HEADERS = $(SRCDIR2)/TcalEvent.hh $(SRCDIR2)/TPORecoEvent.hh $(SRCDIR2)/TPOEvent.hh

# Compiler flags
CXXFLAGS = -Wall -O2 -fPIC $(ROOTCFLAGS)

# Linker flags
LDFLAGS = $(ROOTLIBS) $(ROOTGLIBS)

# Include directories
INCLUDES = -I$(SRCDIR2)

# Create build directory
$(shell mkdir -p $(BUILDDIR))

# Default target
all: $(TARGET)

# Link target
$(TARGET): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS)

# Compile source files
$(BUILDDIR)/%.o: %.cc $(HEADERS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compile PlotGDML
$(BUILDDIR)/PlotGDML.o: PlotGDML.cxx $(HEADERS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Clean up
clean:
	rm -rf $(BUILDDIR) $(TARGET)

.PHONY: all clean
