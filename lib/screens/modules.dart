import 'package:flutter/material.dart';
import 'package:quran_app/screens/exchange.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Hub App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ModulesScreen(),
    );
  }
}

class ModulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trade Hub"),
        centerTitle: true,
      ),
      body: PageView(
        children: [
          ModuleCard(
            moduleName: 'Exchange Item',
            screen: ExchangeItemDetailScreen(),
          ),
          // ModuleCard(
          //   moduleName: 'Auction',
          //   // screen: AuctionScreen(),
          // ),
          // ModuleCard(
          //   moduleName: 'Giveaway',
          //   screen: GiveawayScreen(),
          // ),
        ],
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String moduleName;
  final Widget screen;

  ModuleCard({required this.moduleName, required this.screen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleDetailScreen(
              moduleName: moduleName,
              screen: screen,
            ),
          ),
        );
      },
      child: Hero(
        tag: moduleName,
        child: Card(
          margin: EdgeInsets.all(16),
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                moduleName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModuleDetailScreen extends StatelessWidget {
  final String moduleName;
  final Widget screen;

  ModuleDetailScreen({required this.moduleName, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleName),
        centerTitle: true,
      ),
      body: screen,
    );
  }
}

// The ExchangeItemDetailScreen, AuctionScreen, and GiveawayScreen classes remain unchanged.
