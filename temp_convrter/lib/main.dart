import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Temp Converter',
    theme: ThemeData(
      primaryColor: const Color.fromARGB(
          255, 86, 141, 168), // Adjust app bar and primary elements color
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.red, // Adjust primary swatch for overall theme
      ),
      scaffoldBackgroundColor:
          Colors.grey[200], // Adjust background color of scaffold
    ),
    home: TemperatureConverter(),
  ));
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({Key? key}) : super(key: key);

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _inputController = TextEditingController();
  double? _result;
  String _conversionType = 'F to C'; // Default conversion type
  List<String> _history = [];

  void _convertTemperature() {
    if (_inputController.text.isEmpty) {
      return;
    }
    double inputValue = double.tryParse(_inputController.text) ?? 0.0;
    double convertedValue;
    if (_conversionType == 'F to C') {
      convertedValue = (inputValue - 32) * 5 / 9;
    } else {
      convertedValue = inputValue * 9 / 5 + 32;
    }
    setState(() {
      _result = double.parse(convertedValue.toStringAsFixed(2));
      String historyEntry = '$_conversionType: $inputValue => $_result';
      _history.insert(0, historyEntry); // Add to beginning of history list
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Enter temperature',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _conversionType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _conversionType = newValue!;
                    });
                  },
                  items: <String>['F to C', 'C to F']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: Text('Convert'),
            ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(
                'Result: $_result',
                style: TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            Divider(),
            const SizedBox(height: 10),
            Text(
              'Conversion History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Updated to backgroundColor
              ),
              child: Text('Clear History'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_history[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
