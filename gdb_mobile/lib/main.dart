import 'package:flutter/material.dart';
import 'view/repas.dart';
import 'view/nuits.dart';
import 'view/pauses.dart';
import 'view/horsf.dart';
import 'view/recap.dart';
import 'view/km.dart';
import 'view/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de Firebase avec les options générées
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Utilisation des options Firebase selon la plateforme
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Frais',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<String> titles = [
    'Kilomètres',
    'Repas',
    'Nuits',
    'Pause',
    'Hors Forfait',
    'Récapitulatif'
  ];

  final List<Widget> pages = [
    const KmPage(),
    const RepasPage(),
    const NuitsPage(),
    const PausesPage(),
    const HorsFPage(),
    const RecapPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 15),
          // Logo et Slogan
          Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 16),
              const Text(
                "Suivre vos frais n'a jamais été aussi simple !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Barre multicolore
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                height: 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.indigo,
                      Colors.purple,
                      Colors.red,
                    ],
                    stops: [
                      0.0,
                      0.14,
                      0.28,
                      0.42,
                      0.57,
                      0.71,
                      0.85,
                      1.0,
                    ],
                    begin: Alignment(-1 + 2 * _controller.value, 0),
                    end: Alignment(1 + 2 * _controller.value, 0),
                    tileMode: TileMode.repeated,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Liste des options
          Expanded(
            child: ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pages[index]),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/${['trajet', 'repas', 'nuits', 'etapes', 'horsf', 'recap'][index]}.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          titles[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bouton de déconnexion
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              "Déconnexion",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}