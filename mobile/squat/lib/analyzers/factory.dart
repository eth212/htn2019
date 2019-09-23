import 'package:squat/analyzers/analyzer.dart';
import 'package:squat/utils/workouts.dart';

class AnalyzerFactory{
  static Analyzer getAnalyzer(int workout){
    switch (workout) {
      case Workout.SQUAT:
        return SquatAnalyzer();
        break;
      default:
        return null;
    }
  }
}