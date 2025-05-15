#include "../CoreUtils/TcalEvent.hh"
#include "../CoreUtils/TPORecoEvent.hh"
#include "../CoreUtils/TPOEvent.hh"
#include "CoreUtilsLinkDef.h"



#include <TEveEventManager.h>
#include <TEveManager.h>
#include <TGeoManager.h>
#include "TGeoVolume.h"
#include <TPolyMarker3D.h>
#include "TGeoSphere.h"
#include "TGeoBBox.h"
#include "TGeoMedium.h"
#include <TView3D.h>
#include <TChain.h>
#include <TText.h>
#include <TEveGeoShape.h>
#include <TEveBoxSet.h>

TcalEvent* fTcalEvent = nullptr;
TPOEvent* POevent = nullptr;
TPORecoEvent* fPORecoEvent = nullptr;
TText* runText = nullptr;
TText* eventypeText = nullptr;
TText* energyText = nullptr;

// Function prototypes
void GetDetector();
void LoadEvent(int ievent);
void DrawEvent(int ievent);
void PlotGDML();

void GetDetector()
{
  TEveManager* gEve = TEveManager::Create(kTRUE, "V");
  
  std::cout << "Starting GetDetector()" << std::endl;
  TGeoManager::Import("/Users/ukose/WorkArea/FASER/Andre/FASER-1.0/GeomGDML/geometry.gdml");
  //
  if (!gGeoManager) {
    std::cerr << "Failed to import GDML file." << std::endl;
    return;
  }
  std::cout << "GDML file imported successfully." << std::endl;
  //
  TGeoVolume* gdmlTop = gGeoManager->GetTopVolume();
  if (!gdmlTop) {
    std::cerr << "Failed to get top volume." << std::endl;
    return;
  }
  TGeoIterator nextNode(gdmlTop);
  TGeoNode* curNode;
  //
  while ((curNode = nextNode())) {
    TGeoVolume* vol = curNode->GetVolume();
    if (!vol) {
      std::cerr << "Volume is null for node: " << curNode->GetName() << std::endl;
      continue;
    }
    //
    TGeoShape* shape = vol->GetShape();
    if (!shape) {
      std::cerr << "Shape is null for volume: " << vol->GetName() << std::endl;
      continue;
    }
    //
    TString nodeName(curNode->GetName());
    TString nodePath;
    nextNode.GetPath(nodePath);
    const TGeoMatrix* matrix = nextNode.GetCurrentMatrix();
    if (!matrix) {
      std::cerr << "Matrix is null for node: " << curNode->GetName() << std::endl;
      continue;
    }
    //
    const Double_t* trans = matrix->GetTranslation();
    const Double_t* rotMatrix = matrix->GetRotationMatrix();
    if (!trans || !rotMatrix) {
      std::cerr << "Transformation matrix is null for node: " << curNode->GetName() << std::endl;
      continue;
    }
    //
    TGeoRotation rotation;
    rotation.SetMatrix(rotMatrix);
    TGeoCombiTrans transform(trans[0], trans[1], trans[2], &rotation);
    // Create the TEveGeoShape for visualization
    TEveGeoShape* eveShape = new TEveGeoShape(vol->GetName());
    eveShape->SetShape(shape);
    eveShape->SetMainTransparency(90); // Set transparency
    eveShape->SetTransMatrix(transform);
    gEve->AddGlobalElement(eveShape);
  }
  gEve->Redraw3D(kTRUE);
  std::cout << "GetDetector() completed." << std::endl;
}




void Load_event(int ievent) {

    std::string base_path = "input/tcalevent_";

    // Create an instance of TcalEvent and TPOEvent
    fTcalEvent = new TcalEvent();
    POevent = new TPOEvent();

    fTcalEvent -> Load_event(base_path, ievent, POevent);
    std::cout << "Transverse size " << fTcalEvent->geom_detector.fScintillatorSizeX << " mm " << std::endl;
    std::cout << "Total size of one sandwich layer " << fTcalEvent->geom_detector.fSandwichLength << " mm " << std::endl;
    std::cout << "Number of layers " << fTcalEvent->geom_detector.NRep << std::endl;
    std::cout << "Voxel size " << fTcalEvent->geom_detector.fScintillatorVoxelSize << " mm " << std::endl;

    std::cout << " copied digitized tracks " << fTcalEvent->fTracks.size() << std::endl;

    //fTcalEvent -> fTPOEvent -> dump_event();

    fPORecoEvent = new TPORecoEvent(fTcalEvent, fTcalEvent->fTPOEvent);
    fPORecoEvent -> Reconstruct();
    //fPORecoEvent -> Dump();
}

void DrawEvent(int ievent)
{
    if (gEve->GetCurrentEvent()) {
        gEve->GetCurrentEvent()->DestroyElements();
    }
    
    LoadEvent(ievent);

    TEveBoxSet* boxSet = new TEveBoxSet();
    boxSet->SetTitle("Event Display");
    boxSet->UseSingleColor();
    boxSet->SetMainColor(kRed);  // Default color

    boxSet->Reset(TEveBoxSet::kBT_FreeBox, true, 64);

    for (const auto& track : fTcalEvent->fTracks) {
        size_t nhits = track->fhitIDs.size();
        for (size_t i = 0; i < nhits; i++) {
            long hittype = fTcalEvent->getChannelTypefromID(track->fhitIDs[i]);
            if (hittype == 0 && track->fEnergyDeposits[i] < 0.5) continue;

            ROOT::Math::XYZVector position = fTcalEvent->getChannelXYZfromID(track->fhitIDs[i]);

            float x = position.X() / 10.0;
            float y = position.Y() / 10.0;
            float z = position.Z() / 10.0;
            float dx = 0.25, dy = 0.25, dz = 0.25;  // Box dimensions

            if (hittype == 0) {
                if (fabs(track->fPDG) == 11) {
                    boxSet->AddBox(x - dx, y - dy, z - dz, x + dx, y + dy, z + dz);
                    boxSet->DigitColor(kBlue);
                } else if (fabs(track->fPDG) == 13) {
                    boxSet->AddBox(x - dx, y - dy, z - dz, x + dx, y + dy, z + dz);
                    boxSet->DigitColor(kGreen);
                } else {
                    boxSet->AddBox(x - dx, y - dy, z - dz, x + dx, y + dy, z + dz);
                }
            } else if (hittype == 1) {
                boxSet->AddBox(x - dx / 2, y - dy / 2, z - dz / 2, x + dx / 2, y + dy / 2, z + dz / 2);
                boxSet->DigitColor(kBlack);
            } else {
                std::cout << "Unknown type of hit" << std::endl;
            }
        }
    }

    gEve->AddElement(boxSet);
    gEve->Redraw3D(kTRUE);

    delete runText;
    runText = new TText(0.05, 0.95, Form("Run: %d Event: %d", POevent->run_number, POevent->event_id));
    runText->SetNDC();
    runText->SetTextSize(0.03);
    runText->Draw();

    delete eventypeText;
    std::ostringstream eventtype;
    int pdgin = POevent->in_neutrino.m_pdg_id;
    switch (pdgin) {
        case -12:
        case 12:
            eventtype << "nu_e";
            break;
        case -14:
        case 14:
            eventtype << "nu_mu";
            break;
        case -16:
        case 16:
            eventtype << "nu_tau";
            break;
        default:
            eventtype << " ?? ";
    }
    if (POevent->isCC) {
        eventtype << " CC ";
    } else {
        eventtype << " NC ";
    }
    eventypeText = new TText(0.05, 0.9, eventtype.str().c_str());
    eventypeText->SetNDC();
    eventypeText->SetTextSize(0.03);
    eventypeText->Draw();

    delete energyText;
    energyText = new TText(0.05, 0.85, Form("%f GeV", POevent->in_neutrino.m_energy));
    energyText->SetNDC();
    energyText->SetTextSize(0.03);
    energyText->Draw();
}

#include <TApplication.h>

void PlotGDML() {
  TApplication app("FaserCalDisplayApp", 0,0);
  GetDetector();
  DrawEvent(0);
  app.Run();
    
}
