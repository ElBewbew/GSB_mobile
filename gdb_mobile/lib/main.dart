import 'package:flutter/material.dart';
import 'view/repas.dart';
import 'view/nuits.dart';
import 'view/pauses.dart';
import 'view/horsf.dart';
import 'view/recap.dart';
import 'view/km.dart';
import 'view/login.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
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

class _MyHomePageState extends State<MyHomePage> {
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
    const pausesPage(),
    const HorsFPage(),
    const RecapPage(),
  ];

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                            'assets/images/${['km', 'repas', 'nuits', 'etapes', 'horsf', 'recap'][index]}.png',
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
      ),
    );
  }
}

Future<void> insertUser() async {
  // Référence à la collection 'utilisateur'
  CollectionReference utilisateurs = FirebaseFirestore.instance.collection('utilisateur');
  
  // Données à insérer
  try {
    await utilisateurs.add({
      'nom': 'Dupont',   // Nom de l'utilisateur
      'prenom': 'Jean',  // Prénom de l'utilisateur
      'email': 'jean.dupont@example.com', // Email
      'age': 25,         // Age
    });
    print("Utilisateur ajouté avec succès !");
  } catch (e) {
    print("Erreur lors de l'ajout de l'utilisateur: $e");
  }
}
