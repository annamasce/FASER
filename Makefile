TOPDIR = $(shell pwd)

PYTHIA8_DIR = $(TOPDIR)/pythia8312
PYTHIA8_INCLUDE_DIR = $(PYTHIA8_DIR)/include
PYTHIA8_LIBRARY = $(PYTHIA8_DIR)/lib/libpythia8.a

OPENGL = /usr/include/GL
OPEN_gl_LIBRARY=/usr/

.PHONY: hello

hello:
	@echo "Hello World - please select a target"

root_src:
	if [ ! -d root-6.32.02 ]; then \
		wget https://cernbox.cern.ch/s/5LgzZYg141mQ03c/download -O root_v6.32.02.source.tar.gz; \
		tar xvfz root_v6.32.02.source.tar.gz;\
	fi

root_cmake:
		cd root-build && cmake \
		-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/root-install \
		-DPYTHIA8_INCLUDE_DIR=$(PYTHIA8_INCLUDE_DIR) \
		-DPYTHIA8_LIBRARY=$(PYTHIA8_LIBRARY) \
		-Dpythia8=ON -Dopengl=ON -Dbuiltin_openui5=OFF \
		../root-6.32.02/

root_make:
	cd root-build && make -j 8

root_install:
	cd root-build && make install

root:
	if [ ! -d root-build ]; then \
		mkdir -p root-build; \
		mkdir -p root-install; \
		cd root-build && cmake \
		-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/root-install \
		-DPYTHIA8_INCLUDE_DIR=$(PYTHIA8_INCLUDE_DIR) \
		-DPYTHIA8_LIBRARY=$(PYTHIA8_LIBRARY) \
		-Dpythia8=ON -Dopengl=ON -Dbuiltin_openui5=OFF \
		../root-6.32.06/; \
	fi

pythia8_tar:
	if [ ! -d pythia8312 ]; then \
		wget -q -O - https://cernbox.cern.ch/s/lOhu8P3H0beVnb0/download | tar -xzvf - ; \
	fi

pythia8: pythia8_tar
	if [ ! -d pythia8312/lib ]; then \
		cd pythia8312; \
		./configure --prefix=$(TOPDIR)/pythia-install; \
		make -j; \
		make install; \
	fi

clhep: clhep_git
	if [ ! -d CLHEP-install ]; then \
		cmake -B CLHEP-build -S CLHEP -DCMAKE_INSTALL_PREFIX=./CLHEP-install; \
		cmake --build CLHEP-build --target install; \
	fi

clhep_git:
	if [ ! -f CLHEP/README.md ]; then \
		git clone https://gitlab.cern.ch/CLHEP/CLHEP.git; \
	fi

rave_tar: 
	if [ ! -d rave-0.6.25 ]; then \
		wget -q -O - https://rave.hepforge.org/downloads/?f=rave-0.6.25.tar.gz | tar --exclude=".svn" -xzvf - ; \
	fi

rave: rave_tar
	if [ ! -d rave-install ]; then \
		mkdir -p rave-install; \
		cd rave-0.6.25 && ./configure --prefix=$(TOPDIR)/rave-install --disable-java \
		--with-clhep=$(TOPDIR)/CLHEP-install; \
		make CXXFLAGS="-g -std=c++11" LHEPINCPATH=. -j; \
		make install; \
	fi

genfit_git:
	if [ ! -d GenFit ]; then \
		git clone https://github.com/GenFit/GenFit.git; \
		cd GenFit; \
		patch -p0 -u -i ../genfit.patch; \
	fi

genfit: genfit_git
	cmake -B GenFit-build -S GenFit \
	-DCMAKE_CXX_FLAGS="-g" \
	-DCMAKE_BUILD_TYPE=Debug \
	-DBUILD_TESTING=OFF \
	-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/GenFit-install \
	-DGTEST_LIBRARY=$(TOPDIR)/googletest-install/lib/libgtest.a -DGTEST_INCLUDE_DIR=$(TOPDIR)/googletest-install/include \
	-DGTEST_MAIN_LIBRARY=$(TOPDIR)/googletest-install/lib/libgtest_main.a \
	-DRave_CFLAGS="-DRaveDllExport= -DWITH_FLAVORTAGGING -DWITH_KINEMATICS" \
	-DRave_INCLUDE_DIRS=$(TOPDIR)/rave-install/include/ \
	-DRave_LDFLAGS="-Wl,-rpath-link,$(TOPDIR)/rave-install/lib/ -L$(TOPDIR)/rave-install/lib/ -lRaveBase -L$(TOPDIR)/CLHEP-install/lib/ -lCLHEP" ; \
	cmake --build GenFit-build -j --target install; \

googletest_git:
	if [ ! -d googletest ]; then \
		git clone https://github.com/google/googletest.git ; \
	fi

googletest: googletest_git
	cmake -B googletest-build -S googletest \
	-DCMAKE_INSTALL_PREFIX=$(TOPDIR)/googletest-install; \
	cmake --build googletest-build -j --target install;

display-app:
	cmake -B Display-build -S Display -DGenFit_DIR=$(TOPDIR)/GenFit-install; \
	cmake --build Display-build -j ;

.PHONY clean:
	rm -rf pythia-install pythia8312.tgz pythia8312
	rm -rf CLHEP-build CLHEP-install
	rm -rf CLHEP
	rm -rf rave-0.6.25 rave-install
	rm -rf GenFit-build GenFit-install
	rm -rf GenFit
	rm -rf googletest googletest-install googletest-build


