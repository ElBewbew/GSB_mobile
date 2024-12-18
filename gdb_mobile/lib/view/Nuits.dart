import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NuitsPage extends StatefulWidget {
  const NuitsPage({super.key});

  @override
  _NuitsPageState createState() => _NuitsPageState();
}

class _NuitsPageState extends State<NuitsPage> {
  DateTime selectedDate = DateTime.now();
  int nuits = 0;

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

  Future<void> _saveNuitsToFirebase() async {
    String date = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    DateTime dateTimeNow = DateTime.now();
    String heure = "${dateTimeNow.year}-${dateTimeNow.month.toString().padLeft(2, '0')}-${dateTimeNow.day.toString().padLeft(2, '0')}/${dateTimeNow.hour.toString().padLeft(2, '0')}:${dateTimeNow.minute.toString().padLeft(2, '0')}";
    String montant = (nuits * 47.5).toStringAsFixed(2);

    try {
      await FirebaseFirestore.instance.collection('noteFrais').add({
        'type': 'Nuits',
        'dateHeureValidation': date,
        'heureValidation': heure,
        'montant': montant,
        'nuits': nuits.toString(),
      });
      print("Nuits updated successfully!");
    } catch (e) {
      print("Error updating nuits: $e");
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
            'Nuits',
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
                            nuits++;
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
                          '$nuits Nuits',
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
                            if (nuits > 0) nuits--;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 48),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveNuitsToFirebase,
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