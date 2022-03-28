import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _updateCount({
    required DocumentReference docData,
    required int currentCount,
  }) {
    docData.update({
      'count': currentCount + 1,
    });
  }

  void _deleteCountData({
    required DocumentReference docData,
  }) {
    docData.delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('Counter').doc('CounterData').snapshots(),
        builder: (context, countData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Builder(
              builder: (context) {
                if (!countData.hasData) {
                  return const Center(
                    child: Text(
                      'Data tidak ada ...',
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'You have pushed the button this many times:',
                      ),
                      Text(
                        countData.data!.get('count').toString(),
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _deleteCountData(
                      docData: countData.data!.reference,
                    );
                  },
                  tooltip: 'Delete',
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                FloatingActionButton(
                  onPressed: () {
                    _updateCount(
                      docData: countData.data!.reference,
                      currentCount: countData.data!.get(
                        'count',
                      ),
                    );
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
        });
  }
}
