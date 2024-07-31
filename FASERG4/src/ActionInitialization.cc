#include "ActionInitialization.hh"

#include "G4ParticleDefinition.hh"
#include "G4ParticleTable.hh"
#include "CustomTauDecay.hh"
#include "G4Decay.hh"
#include "G4DecayTable.hh"

#include "G4TauPlus.hh"
#include "G4TauMinus.hh"

ActionInitialization::ActionInitialization(G4int startEvent, ParticleManager* pm)
    : G4VUserActionInitialization(), fParticleManager(pm), fStartEvent(startEvent) {}  
	
void ActionInitialization::BuildForMaster() const { SetUserAction(new RunAction(fParticleManager)); }

void ActionInitialization::Build() const
{
	SetUserAction(new PrimaryGeneratorAction(fParticleManager));
	SetUserAction(new RunAction(fParticleManager));
	SetUserAction(new EventAction(fStartEvent, fParticleManager));
	SetUserAction(new TrackingAction(fParticleManager));
}
