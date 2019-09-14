import 'package:flutter/material.dart';
import 'package:squat/main.dart';

class WorkoutSelectionPage extends StatefulWidget {
  WorkoutSelectionPage({
    Key key,
    this.title
  }): super(key: key);
  final String title;
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State < WorkoutSelectionPage > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272727),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), child: AppBar(
          centerTitle: true,
          title: new Text('JUMPY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 45)),
          backgroundColor: SquatApp().squatPrimary
        )),
      body: Container(child:Center(
        child: Column(

          // mainAxisAlignment: MainAxisAlignment.center,
          children: < Widget > [
              AspectRatio(child:WorkoutList(),aspectRatio: 1,)
            // Row(
            //   children: < Widget > [
            //     // Expanded(
            //     //   child: Container(color: Color(0xff272727), child: Padding(padding: EdgeInsets.all(10), child: Text('WORKOUTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 28)))),
            //     // ),
            //   // Expanded(child:Align( child:AspectRatio(child:WorkoutList(),aspectRatio: 1,)))
            //   AspectRatio(child:WorkoutList(),aspectRatio: 1,)
            //   ],
            // ),
            
          ],
        ),
      ) // This trailing comma makes auto-formatting nicer for build methods.
    )
    );
  }
}

class WorkoutList extends StatefulWidget {
    @override
  State<StatefulWidget> createState() {
    return new WorkoutListState();
  }
}
class WorkoutListState extends State<WorkoutList> {
    final someStuff = ['Hi','Nah','You'];
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Color(0xff272727),
      appBar: AppBar(
        title: Text('WORKOUTS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 28)),
        backgroundColor: Color(0xff272727)
      ),
      body:buildList(),
    );
  }
  Widget buildList() {
  return new Padding(padding:EdgeInsets.all(10),child:  GridView.count( 
    crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
      children: List.generate(3, (i) {
      print(i);
      var index = i~/2;
      // if (i.isOdd) return Divider();
      // If you've reached at the end of the available word pairs...
      // if (index >= _suggestions.length) {
      //   // ...then generate 10 more and add them to the suggestions list.
      //   _suggestions.addAll(generateWordPairs().take(10));
      // }
      return _buildRow(someStuff[index]);
    },
  ),
  ),
  );
}
Widget _buildRow(pair) {
  return new Center(
    child: Card(child:
    AspectRatio(aspectRatio: 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        
        children: <Widget>[
          const ListTile(
            
            title: Text('The Enchanted Nightingale'),
            // subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
        ],
      ),
    )
    ),
  );
}
}