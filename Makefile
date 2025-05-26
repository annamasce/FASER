TOPDIR = $(shell pwd)

UNAME_S := $(shell uname -s)

UNAME_S := $(shell uname -s)

PYTHIA8_DIR = $(TOPDIR)/pythia-install
PYTHIA8_INCLUDE_DIR = $(PYTHIA8_DIR)/include
PYTHIA8_LIBRARY = $(PYTHIA8_DIR)/lib/libpythia8.a

OPENGL = /usr/include/GL
OPEN_gl_LIBRARY=/usr/

root_git:
	if [ ! -d root ]; then \
		git clone --branch v6-32-12 --depth=1 https://github.com/root-project/root.git root ; \
	fi

root: root_git pythia8
	cmake -B root-build -S root \
	-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/root-install \
	-DPYTHIA8_INCLUDE_DIR=$(PYTHIA8_INCLUDE_DIR) \
	-DPYTHIA8_LIBRARY=$(PYTHIA8_LIBRARY) \
	-Dpythia8=ON -Dopengl=ON -Dbuiltin_openui5=OFF;
	cmake --build root-build -j 8 --target install

pythia8_tar:
	if [ ! -d pythia8312 ]; then \
		wget -q -O - https://cernbox.cern.ch/s/lOhu8P3H0beVnb0/download | tar -xzvf - ; \
	fi

pythia8: pythia8_tar
	if [ ! -d pythia-install ]; then \
		cd pythia8312; \
		./configure --prefix=$(TOPDIR)/pythia-install; \
		make; \
	fi

clhep: clhep_git
	if [ ! -d CLHEP-install ]; then \
		mkdir -p CLHEP-build; \
		mkdir -p CLHEP-install; \
		cd CLHEP-build && cmake -DCLHEP_SINGLE_THREAD=ON -DCMAKE_INSTALL_PREFIX=../CLHEP-install ../CLHEP; \
		make -j4; \
		make install; \
	fi

clhep_git:
	if [ ! -f CLHEP/README.md ]; then \
		git clone --depth 1 https://gitlab.cern.ch/CLHEP/CLHEP.git; \
	fi

.PHONY: rave
ifeq ($(UNAME_S),Darwin)
rave: 
	if [ ! -d rave-install ]; then \
		mkdir -p rave-install; \
		cd rave && ./configure --prefix=$(TOPDIR)/rave-install --disable-java --with-boost=/opt/homebrew --with-boost-libdir=/opt/homebrew/lib \
		--with-clhep=$(TOPDIR)/CLHEP-install; \
		make CXXFLAGS="-g -std=c++11" LHEPINCPATH=. -j4; \
		make install; \
	fi
else
rave: 
	if [ ! -d rave-install ]; then \
		mkdir -p rave-install; \
		cd rave && autoreconf && ./configure --prefix=$(TOPDIR)/rave-install --disable-java \
		--with-clhep=$(TOPDIR)/CLHEP-install; \
		make CXXFLAGS="-g -std=c++11" LHEPINCPATH=. -j4; \
		make install; \
	fi
endif

genfit_git:
	if [ ! -d GenFit ]; then \
		git clone https://github.com/GenFit/GenFit.git; \
		cd GenFit; \
		patch -p0 -u -i ../genfit.patch; \
	fi

ifeq ($(UNAME_S),Darwin)
genfit: genfit_git
	if [ ! -d GenFit-build ]; then \
		mkdir -p GenFit-build; \
		mkdir -p GenFit-install; \
		cd GenFit-build && cmake \
		-DCMAKE_BUILD_TYPE=Debug \
		-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/GenFit-install \
		-DRave_CFLAGS="-DRaveDllExport= -DWITH_FLAVORTAGGING -DWITH_KINEMATICS" \
		-DRave_INCLUDE_DIRS=$(TOPDIR)/rave-install/include/ \
		-DRave_LDFLAGS="-L$(TOPDIR)/rave-install/lib/ -lRaveBase -L$(TOPDIR)/CLHEP-install/lib/ -lCLHEP" \
		../GenFit; \
		make CXXFLAFS="-g" -j; \
		make install; \
	fi
else
genfit: genfit_git
	if [ ! -d GenFit-build ]; then \
		mkdir -p GenFit-build; \
		mkdir -p GenFit-install; \
		cd GenFit-build && cmake \
		-DCMAKE_BUILD_TYPE=Debug \
		-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/GenFit-install \
		-DGTEST_LIBRARY=$(TOPDIR)/googletest-install/lib/libgtest.a -DGTEST_INCLUDE_DIR=$(TOPDIR)/googletest-install/include \
		-DGTEST_MAIN_LIBRARY=$(TOPDIR)/googletest-install/lib/libgtest_main.a \
		-DRave_CFLAGS="-DRaveDllExport= -DWITH_FLAVORTAGGING -DWITH_KINEMATICS" \
		-DRave_INCLUDE_DIRS=$(TOPDIR)/rave-install/include/ \
		-DRave_LDFLAGS="-Wl,-rpath-link,$(TOPDIR)/rave-install/lib/ -L$(TOPDIR)/rave-install/lib/ -lRaveBase -L$(TOPDIR)/CLHEP-install/lib/ -lCLHEP" \
		../GenFit; \
		make CXXFLAFS="-g" -j; \
		sh CMakeFiles/gtests.dir/link.txt; \
		make -j; \
		make install; \
	fi
endif

googletest_git:
	if [ ! -d googletest ]; then \
		git clone --depth 1 https://github.com/google/googletest.git ; \
	fi

googletest: googletest_git
	cmake -B googletest-build -S googletest \
	-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/googletest-install; \
	cmake --build googletest-build -j 8 --target install;

geant4_tar:
	if [ ! -d geant4-11.3.2 ]; then \
		wget - q -O - https://github.com/Geant4/geant4/archive/refs/tags/v11.3.2.tar.gz | tar -xzvf - ; \
	fi

geant4: geant4_tar
	cmake -S geant4-11.3.2 -B build \
	-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/geant4-11.3.2-install \
	-DGEANT4_INSTALL_DATA=ON ; \
	cmake --build build -j 8 --target install ;

display-app:
	cmake -B Display-build -S Display -DGenFit_DIR=$(TOPDIR)/GenFit-install; \
	cmake --build Display-build -j 8 ;

.PHONY clean:
	rm -rf pythia-install pythia8312.tgz pythia8312
	rm -rf CLHEP-build CLHEP-install
	rm -rf CLHEP
	rm -rf rave-0.6.25 rave-install
	rm -rf GenFit-build GenFit-install
	rm -rf GenFit
	rm -rf googletest googletest-install googletest-build
