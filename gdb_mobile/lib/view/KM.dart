import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class KmPage extends StatefulWidget {
  const KmPage({super.key});

  @override
  _KmPageState createState() => _KmPageState();
}

class _KmPageState extends State<KmPage> {
  DateTime selectedDate = DateTime.now();
  int kilometers = 0;
  final List<String> addedValues = [];
  bool showCustomFields = false;
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // This will change to dark theme.
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addValue(String value) {
    setState(() {
      addedValues.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Kilomètres',
            style: TextStyle(
              color: Colors.white, // La couleur de base sera masquée par le ShaderMask
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(133, 226, 226, 226),
                offset: Offset(0, 3),
                blurRadius: 5,
              ),
            ],
          ),
        ),
      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 0, 0, 0)),
                        onPressed: () => _selectDate(context),
                      ),
                      Text(
                        "Date : ${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
         
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: showCustomFields ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.blue, Colors.green],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Text(
                            'En forfait (1.10 euros par km).',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  kilometers++;
                                });
                              },
                              icon: const Icon(Icons.arrow_drop_up, color: Colors.black, size: 48),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.blue, Colors.green],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                '$kilometers Km',
                                style: const TextStyle(
                                  color: Colors.white, // La couleur de base sera masquée par le ShaderMask
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (kilometers > 0) kilometers--;
                                });
                              },
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 48),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        showCustomFields
                            ? "Passer en forfait"
                            : "Passer en hors forfait",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black, // Vous pouvez personnaliser la couleur
                        ),
                      ),
                      Switch(
                        value: showCustomFields,
                        onChanged: (bool value) {
                          setState(() {
                            showCustomFields = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                  AnimatedOpacity(
                    opacity: showCustomFields ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        TextField(
                          controller: _kmController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Entrez les kilomètres parcourus',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Entrez le prix total payé',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      bool insertValue = true;
                      String prix = "vide";
                      int km = 0;

                      if (showCustomFields) {km = kilometers;


                        if (_kmController.text.isNotEmpty) {
                          
                          km = int.tryParse(_kmController.text) ?? 0;

                        } else {

                          insertValue = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Veuillez entrer un nombre de kilomètres valide."),
                              duration: Duration(seconds: 2), // Durée du SnackBar
                            ),
                          );
                        }

                        if (_priceController.text.isNotEmpty) {
                          
                          prix = _priceController.text;

                        } else {

                          insertValue = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Veuillez entrer un prix valide."),
                              duration: Duration(seconds: 2), // Durée du SnackBar
                            ),
                          );
                        }
                      } else {
                        if (kilometers == 0) {
                          insertValue = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Veuillez entrer un nombre de kilomètres valide."),
                              duration: Duration(seconds: 2), // Durée du SnackBar
                            ),
                          );
                        } else {km = kilometers;}
                        
                      }

                      if (insertValue) {
                        insertKm(selectedDate, showCustomFields, km, prix);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Valider",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Valeurs ajoutées :",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...addedValues.map((value) => Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> insertKm(DateTime  dateTime, bool showCustomFields, int km, String prix) async {
  CollectionReference noteFrais = FirebaseFirestore.instance.collection('noteFrais');
  
  String date = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  
  DateTime dateTimeNow = DateTime.now();
  String heure = "${dateTimeNow.hour.toString().padLeft(2, '0')}:${dateTimeNow.minute.toString().padLeft(2, '0')}:${dateTimeNow.second.toString().padLeft(2, '0')}";
  String montant = "0";
  
  // Données à insérer
  try {
    if (showCustomFields) {

      montant = prix;

    } else { montant = (km * 1.10).toStringAsFixed(2);}

    await noteFrais.add({
        'type': 'Trajet',
        'dateOperation': date,
        'heureValidation': heure,
        'montant': montant,
        'kilometres': km.toString(),
      });

  } catch (e) {}
}