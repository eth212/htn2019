import 'package:flutter/material.dart';
import 'package:squat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutSelectionPage extends StatefulWidget {
  WorkoutSelectionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff272727),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
                centerTitle: true,
                title: new Text('JUMPY',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 45)),
                backgroundColor: SquatApp().squatPrimary)),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 0,
          // icon: const Icon(Icons.add),
          label: const Text('Workout',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: WorkoutList(),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value){
                    Navigator.of(context).pop();
                  });
                },
              ),
              Expanded(
                child: Text(''),
              )
            ],
          ),
        color:SquatApp().squatPrimary));
  }
}

class WorkoutList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WorkoutListState();
  }
}

class WorkoutListState extends State<WorkoutList> {
  static var size = Size(0, 0);
  final imageLinks = ['Hi', 'Nah', 'You','Right?'];
  final headerText = ['Squats','Pullups','Running','Wow'];
  final contentText = ['Time for your glutes.','You think you got form?','Great','New apartment!'];

  /*24 is for notification bar on Android*/
  static double itemHeight = (size.height - kToolbarHeight - 24) / 2;
  static double itemWidth = size.width / 2;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    itemHeight = (size.height - kToolbarHeight - 24) / 2;
    itemWidth = size.width / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 7.5, right: 15, top: 15),
            child: Text('WORKOUTS',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.normal,
                    height: 1.2,
                    fontSize: 28))),
        Expanded(child: buildList()),
      ],
    );
  }

  Widget buildList() {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 2, childAspectRatio: 6.5 / 8,

        // Generate 100 widgets that display their index in the List.
        children: List.generate(
          imageLinks.length,
          (i) {
            print(i);
            
            // if (i.isOdd) return Divider();
            // If you've reached at the end of the available word pairs...
            // if (index >= _suggestions.length) {
            //   // ...then generate 10 more and add them to the suggestions list.
            //   _suggestions.addAll(generateWordPairs().take(10));
            // }
            return buildCard(i);
          },
        ),
      ),
    );
  }

  Widget buildCard(index) {
    return new Center(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(children: [
          Image.network(
            'https://placeimg.com/640/480/any',
            fit: BoxFit.fill,
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
              child: Text(headerText[index],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20, height: 1.1)),
            ),
          ]),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
              child: Text(contentText[index],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, height: 1.1)),
            ),
          ])
        ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        // elevation: 5,
        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20, top: 4),
      ),
    );
  }
}
