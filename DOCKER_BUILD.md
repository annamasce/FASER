
# Start a docker container
```
docker run -it --platform linux/amd64 --name faser-test --network host --volume /Users/annamascellani/workspace/faser-linux:/workspace --workdir /workspace --detach ubuntu:22.04
```

# Attach to container
```
docker exec -it faser-test bash
```

# Install requirements
In the container:
```
apt update
apt install build-essential bash-completion binutils cmake dpkg-dev g++ gcc libssl-dev git libx11-dev \
libxext-dev libxft-dev libxpm-dev python3 libtbb-dev libgif-dev wget ninja-build rsync
```

# Clone the repo
```
git clone -b dbscan_studies https://github.com/annamasce/FASER.git
cd FASER
```

# Install ROOT
```
wget -q -O - https://root.cern/download/root_v6.32.12.Linux-ubuntu22.04-x86_64-gcc11.4.tar.gz | tar -xzvf -
source root/bin/thisroot.sh
```

# Install Geant4
```
wget -q -O - https://github.com/Geant4/geant4/archive/refs/tags/v11.3.2.tar.gz | tar -xzvf -
cmake -S geant4-11.3.2/ -B build -G Ninja -DCMAKE_INSTALL_PREFIX=$PWD/geant4-11.3.2-install -DGEANT4_INSTALL_DATA=ON
cmake --build build -j 6 --target install
rm -rf build
```

# Install Pythia8
```
make pythia8
```

# Install CLHEP
```
make clhep
```

# Install Rave
```
make rave
```

# Install Googletest
```
make googletest
```

# Install GenFit
```
make genfit
```