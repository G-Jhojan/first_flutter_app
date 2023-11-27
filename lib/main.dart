import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Advice Generator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

   void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

    var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
 }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {           // ← 1
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

      // ↓ Add this.
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
      // ← 2
    return Scaffold(                             // ← 3
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,                         // ← 4
          children: [
           //const Text('A random AWESOME idea:'),        // ← 5
            BigCard(pair: pair),
            const SizedBox(height: 15,),// ← 6
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //ElevatedButton(
                //  onPressed: () {
                //    print('button pressed!');
                //  },
                //  child: const Row(
                //    children: [
                //       Icon(Icons.heart_broken_sharp),
                //       SizedBox(width: 10,),
                //       Text('Like'),
                //    ],
                //  ),
                //),
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                const SizedBox(width: 15,),
                ElevatedButton(
                  onPressed: () {
                  appState.getNext();  // ← This instead of print().
                },
                child: const Text('Next'),
                ),
              ],
            ),

          ],                                      // ← 7
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      shadows: theme.textTheme.displayMedium!.shadows,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
         child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
