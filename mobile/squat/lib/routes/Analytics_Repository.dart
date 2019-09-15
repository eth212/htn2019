import 'package:cloud_firestore/cloud_firestore.dart';


class AnalyticsEntry{

  int kneeAnkle;
  int shoulderHip;
  int hipKnee;
  int earShoulder;
  int deltaShoulderHip;
  int progress;
  int reps;
  
  AnalyticsEntry(int ka, int sh, int hk, int es, int dsh, int p, int r){
    kneeAnkle = ka;
    shoulderHip = sh;
    hipKnee = hk;
    earShoulder = es;
    deltaShoulderHip = dsh;
    progress = p;
    reps = r;
  }

  addEntry(){
    Firestore.instance.runTransaction((transaction) async {
          await transaction.set(Firestore.instance.collection("USER_RESULTS").document("CcIOoTqGTbzetPd6wCQK"), {
            'Knee_Ankle': this.kneeAnkle,
            'Shoulder_Hip': this.shoulderHip,
            'Hip_Knee' : this.hipKnee,
            'Ear_Shoulder' : this.earShoulder,
            'Delta_Shoulder_Hip': this.deltaShoulderHip,
            'Progress': this.progress,
            'Reps': this.reps
          });
        });
  }



   getMostRecentEntry() {
    return Firestore.instance.collection("USER_RESULTS").document("CcIOoTqGTbzetPd6wCQK");
  }
  
}