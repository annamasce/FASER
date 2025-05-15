#include "TPORecoEvent.hh"


namespace segments
{
  FaserCalData::FaserCalData(){}
  FaserCalData::~FaserCalData(){}
  
  void FaserCalData::LoadEvent(int iEvent)
  {
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
    
    fTcalEvent -> fTPOEvent -> dump_event();
    
    fPORecoEvent = new TPORecoEvent(fTcalEvent, fTcalEvent->fTPOEvent);
    fPORecoEvent -> Reconstruct();
    fPORecoEvent -> Dump();
  }

  void FaserCalData::DrawEvent()
  {
    
    
  }
  
  
  
} // namespace segments
