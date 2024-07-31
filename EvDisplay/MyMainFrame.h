#include <TGFrame.h>
#include <TGWindow.h>
#include <TGButton.h>
#include <TRootEmbeddedCanvas.h>
#include <TGeoVolume.h>
#include <RQ_OBJECT.h>
#include <TText.h>
#include <TGTextEntry.h>


#include <TcalEvent.hh>
#include "TPORecoEvent.hh"

class MyMainFrame : public TGMainFrame {
    RQ_OBJECT("MyMainFrame")
public:
    MyMainFrame(int run_number, int ievent, int mask, const TGWindow *p, UInt_t w, UInt_t h);
    virtual ~MyMainFrame();

    void Load_event(int run_number, int ievent, int mask);
    void Draw_event();
    void Next_Event(int ievent);

    void HandleButton(); // Function to handle button click
    void toggle_prim_em();
    void toggle_prim_had();
    void toggle_sec_em();
    void toggle_sec_had();
    void next_event();
    void goto_event();

    void ZoomToPosition(Double_t x, Double_t y, Double_t z);
    void SideView();

    ClassDef(MyMainFrame,1)

private:
    TGMainFrame *fMain;
    TGTextButton *fButton;
    TRootEmbeddedCanvas *fCanvas;
    TGTextEntry *textNextEventEntry;

    TText *runText = nullptr;
    TText *eventypeText = nullptr;
    TText *energyText = nullptr;

    int ievent;
    int event_mask;

    TcalEvent* fTcalEvent;
    TPOEvent *POevent;
    TPORecoEvent* fPORecoEvent;

    TGeoVolume *primary_em;
    TGeoVolume *primary_had;
    TGeoVolume *secondary_em;
    TGeoVolume *secondary_had;
    TGeoVolume *si_tracker;

    bool toggle_primary_em;
    bool toggle_primary_had;
    bool toggle_secondary_em;
    bool toggle_secondary_had;

};
