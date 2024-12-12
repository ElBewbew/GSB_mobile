import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
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
                      "Bienvenue !",
                      style: TextStyle(
                        color: Colors.white, // La couleur de base sera masquée par le ShaderMask
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Champ de texte pour le nom d'utilisateur
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Nom d\'utilisateur',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 190, 190, 190),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(color: Color.fromARGB(137, 255, 255, 255)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  // Champ de texte pour le mot de passe
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 190, 190, 190),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(color: Colors.white54),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  // Bouton de connexion
                  ElevatedButton(
                    onPressed: () async {
                      // Logique de connexion


                      checkIfEmailMdpExists(context, _usernameController.text, _passwordController.text);

                      print("Nom d'utilisateur: ${_usernameController.text}, Mot de passe: ${_passwordController.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 204, 204, 204),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Connexion"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> checkIfEmailMdpExists(BuildContext context, String email, String mdp) async {
  try {
    // Référence à la collection 'users' dans Firestore
    CollectionReference users = FirebaseFirestore.instance.collection('utilisateur');
    
    // Recherche l'utilisateur avec l'email spécifié
    QuerySnapshot querySnapshot = await users.where('Email', isEqualTo: email).get();

    // Si on trouve des résultats, on retourne le premier document
    if (querySnapshot.docs.isNotEmpty) {
      
      var user = querySnapshot.docs.first;  // Retourne le premier utilisateur trouvé
    
      // Comparaison du mot de passe
      String storedPassword = user['mdp'];  // On récupère le mot de passe de Firestore
      if (storedPassword == mdp) {

        // Si le mot de passe est correct, on redirige vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()), // Remplace avec la page principale
        );
        return true;  // Le mot de passe correspond
      
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Le mot de passe ne correspond pas"),
            duration: Duration(seconds: 2), // Durée du SnackBar
          ),
        );

        return false; // Le mot de passe ne correspond pas
      }

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aucun utilisateur trouvé"),
          duration: Duration(seconds: 2), // Durée du SnackBar
        ),
      );
      return false;  // Aucun utilisateur trouvé
    }
  } catch (e) {
    print('Erreur de recherche dans Firestore : $e');
    return false;
  }
}