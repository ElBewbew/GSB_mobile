import 'package:flutter/material.dart';
import 'view/repas.dart';
import 'view/nuits.dart';
import 'view/etapes.dart';
import 'view/horsf.dart';
import 'view/recap.dart';
import 'view/km.dart';
import 'view/login.dart'; // Assurez-vous d'importer la page de connexion

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      darkTheme: ThemeData.dark(),
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
  double _opacity = 0.0;

  final List<String> titles = [
    'Kilomètres',
    'Repas',
    'Nuits',
    'Étapes',
    'Hors Forfait',
    'Récapitulatif'
  ];

  final List<Widget> pages = [
    const KmPage(),
    const RepasPage(),
    const NuitsPage(),
    const EtapesPage(),
    const HorsFPage(),
    const RecapPage(),
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 18, 18, 18), Color.fromARGB(255, 45, 45, 45)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo en haut
                    Image.asset(
                      'assets/images/logo.png', // Chemin du logo
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    // Texte sous le logo avec ShaderMask
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        "Suivre vos frais n'a jamais été aussi simple !",
                        style: TextStyle(
                          color: Colors.white, // La couleur de base sera masquée par le ShaderMask
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Blocs gris foncé avec effet d'ombre
                    ...List.generate(6, (index) {
                      return AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(seconds: 1),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => pages[index]),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9, // 90% de la largeur de l'écran
                            height: 100, // Hauteur des blocs
                            margin: const EdgeInsets.symmetric(vertical: 5), // Réduire l'espace entre les blocs
                            decoration: BoxDecoration(
                              color: Colors.grey[850], // Couleur gris foncé
                              border: Border.all(
                                color: Colors.white, // Couleur de la bordure
                                width: 2, // Largeur de la bordure
                              ),
                              borderRadius: BorderRadius.circular(10), // Rayon des coins du bloc
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5), // Couleur de l'ombre
                                  spreadRadius: 2, // Rayon de diffusion
                                  blurRadius: 5, // Rayon de flou
                                  offset: const Offset(0, 3), // Décalage de l'ombre
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10), // Espacement entre l'image et l'extrémité du bloc
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/${['km', 'repas', 'nuits', 'etapes', 'horsf', 'recap'][index]}.png', // Chemin de l'image
                                  fit: BoxFit.cover,
                                ),
                                const VerticalDivider(
                                  color: Colors.white, // Couleur de la barre
                                  thickness: 2, // Épaisseur de la barre
                                  width: 20, // Largeur de l'espace entre l'image et la barre
                                ),
                                Expanded(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Colors.blue, Colors.green],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: Text(
                                      titles[index],
                                      style: const TextStyle(
                                        color: Colors.white, // La couleur de base sera masquée par le ShaderMask
                                        fontSize: 24, // Augmenter la taille de la police
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                // Bouton de déconnexion en bas
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Déconnexion"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}