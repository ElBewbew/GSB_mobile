import 'package:flutter/material.dart';

class HorsFPage extends StatefulWidget {
  const HorsFPage({super.key});

  @override
  _HorsFPageState createState() => _HorsFPageState();
}

class _HorsFPageState extends State<HorsFPage> {
  DateTime selectedDate = DateTime.now();
  int horsf = 0;
  final List<String> addedValues = [];

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
            'Hors Forfait',
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sélection de la date
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Card(
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Sélection des hors forfaits
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          horsf++;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_up, color: Color.fromARGB(255, 0, 0, 0), size: 48),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.blue, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        '$horsf Hors Forfait',
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
                          if (horsf > 0) horsf--;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 0, 0, 0), size: 48),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Logique du bouton Valider
                    _addValue("Date: ${selectedDate.toLocal()}, Hors Forfait: $horsf");
                    print("Date: ${selectedDate.toLocal()}, Hors Forfait: $horsf");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    "Valeurs ajoutées :",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                // Tableau des valeurs ajoutées
                const Text(
                  "Valeurs ajoutées :",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: addedValues.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          addedValues[index],
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}