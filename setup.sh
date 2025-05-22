# TODO: FIX
export HOMEFASER="/ws/FASER"

echo "Sourcing FASER environment at: $HOMEFASER"

source $HOMEFASER/root-install/bin/thisroot.sh
source $HOMEFASER/geant4-11.3.2-install/bin/geant4.sh

export PYTHIA8=$HOMEFASER/pythia-install
export CLHEPINSTALL=$HOMEFASER/CLHEP-install
export RAVEINSTALL=$HOMEFASER/rave-install
export GENFITINSTALL=$HOMEFASER/GenFit-install
export LD_LIBRARY_PATH=$GENFITINSTALL/lib:$RAVEINSTALL/lib:$CLHEPINSTALL/lib:$LD_LIBRARY_PATH
