import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CovidTrackerPage extends StatefulWidget {
  @override
  _CovidTrackerPageState createState() => _CovidTrackerPageState();
}

class _CovidTrackerPageState extends State<CovidTrackerPage> {
  final TextEditingController _countryController = TextEditingController();
  Map<String, dynamic> _covidData = {};
  bool _loading = false;
  String _errorMessage = '';
  Future<void> _fetchCovidData(String countryName) async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    String url = 'https://disease.sh/v3/covid-19/countries/$countryName';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _covidData = json.decode(response.body);
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _errorMessage =
              'Failed to load COVID-19 data (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('COVID-19 Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Enter Country',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _fetchCovidData(_countryController.text);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text('Get COVID-19 Data'),
              ),
              SizedBox(height: 20),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : _covidData.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Cases: ${_covidData['cases']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Deaths: ${_covidData['deaths']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Recovered: ${_covidData['recovered']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Active Cases: ${_covidData['active']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Critical Cases: ${_covidData['critical']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Cases Per Million: ${_covidData['casesPerOneMillion']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Deaths Per Million: ${_covidData['deathsPerOneMillion']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Total Tests: ${_covidData['tests']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Tests Per Million: ${_covidData['testsPerOneMillion']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Population: ${_covidData['population']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
