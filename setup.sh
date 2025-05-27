export HOMEFASER=$PWD

echo "Setting up environment for FASER simulation"
echo "Current working directory: $HOMEFASER"

ROOT_INSTALL=$HOMEFASER/root-install
source $ROOT_INSTALL/bin/thisroot.sh
echo "Root installed in $ROOT_INSTALL"

GEANT4_INSTALL=/Users/annamascellani/workspace/faser/FASER/geant4-11.3.2-install/
source $GEANT4_INSTALL/bin/geant4.sh
echo "GEANT4 installed in $GEANT4_INSTALL"

# export PYTHIA8=/Users/annamascellani/workspace/faser/FASER/pythia-install

export PYTHIA8=$HOMEFASER/pythia-install
export CLHEPINSTALL=$HOMEFASER/CLHEP-install
export RAVEINSTALL=$HOMEFASER/rave-install
export GENFITINSTALL=$HOMEFASER/GenFit-install
export LD_LIBRARY_PATH=$GENFITINSTALL/lib:$RAVEINSTALL/lib:$CLHEPINSTALL/lib:$LD_LIBRARY_PATH

export DYLD_LIBRARY_PATH=$HOMEFASER/CLHEP-install/lib:$DYLD_LIBRARY_PATH

# Detect macOS (Darwin)
if [[ "$(uname)" == "Darwin" ]]; then
  export DYLD_LIBRARY_PATH="/opt/homebrew/opt/boost/lib:$DYLD_LIBRARY_PATH"
fi
