import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RepasPage extends StatefulWidget {
  const RepasPage({super.key});

  @override
  _RepasPageState createState() => _RepasPageState();
}

class _RepasPageState extends State<RepasPage> {
  DateTime selectedDate = DateTime.now();
  int repas = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
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

  Future<void> _saveRepasToFirebase() async {
    String date = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    DateTime dateTimeNow = DateTime.now();
    String heure = "${dateTimeNow.year}-${dateTimeNow.month.toString().padLeft(2, '0')}-${dateTimeNow.day.toString().padLeft(2, '0')}/${dateTimeNow.hour.toString().padLeft(2, '0')}:${dateTimeNow.minute.toString().padLeft(2, '0')}";
    String montant = (repas * 15.0).toStringAsFixed(2);

    try {
      await FirebaseFirestore.instance.collection('noteFrais').add({
        'type': 'Repas',
        'dateOperation': date,
        'dateHeureValidation': heure,
        'montant': montant,
        'repas': repas.toString(),
      });
      print("Repas updated successfully!");
    } catch (e) {
      print("Error updating repas: $e");
    }
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
            'Repas',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            repas++;
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
                          '$repas Repas',
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
                            if (repas > 0) repas--;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 48),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveRepasToFirebase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Valider",
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
          ),
        ),
      ),
    );
  }
}