import 'package:flutter/material.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  String _fromCurrency = 'MDL';
  String _toCurrency = 'USD';
  double _convertedAmount = 0.0;

  List<String> currencies = ['MDL', 'USD', 'EUR', 'GBP', 'RON'];

  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double exchangeRate = double.tryParse(_rateController.text) ?? 1.0;

    setState(() {
      // Calcul corect bazat pe direcția de conversie
      if (_fromCurrency == _toCurrency) {
        _convertedAmount = amount;
      } else if (_fromCurrency == 'MDL' && _toCurrency == 'USD') {
        _convertedAmount = amount / exchangeRate;
      } else if (_fromCurrency == 'USD' && _toCurrency == 'MDL') {
        _convertedAmount = amount * exchangeRate;
      }
      // Poți adăuga și alte condiții pentru conversii suplimentare
    });
  }

  void _swapCurrencies() {
    setState(() {
      String tempCurrency = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = tempCurrency;
      _convertCurrency(); // Recalculăm suma după schimbarea valutei.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Currency Converter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildCurrencyField('Amount', _fromCurrency, _amountController),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _swapCurrencies,
                      child: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.swap_vert, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildConvertedField('Converted Amount', _toCurrency, _convertedAmount),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Indicative Exchange Rate',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    child: TextField(
                      controller: _rateController,
                      decoration: InputDecoration(
                        labelText: 'Rate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _convertCurrency(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '$_fromCurrency = 1 $_toCurrency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertCurrency,
                child: Text('Convert'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyField(
      String label, String currency, TextEditingController controller) {
    return Row(
      children: [
        _buildCurrencyDropdown(currency, true),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => _convertCurrency(),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertedField(
      String label, String currency, double convertedAmount) {
    return Row(
      children: [
        _buildCurrencyDropdown(currency, false),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 60,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              convertedAmount.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown(String currency, bool isFromCurrency) {
    return DropdownButton<String>(
      value: currency,
      items: currencies.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          if (isFromCurrency) {
            _fromCurrency = value!;
          } else {
            _toCurrency = value!;
          }
          _convertCurrency(); // Recalculăm suma după schimbarea valutei.
        });
      },
      icon: Icon(Icons.arrow_drop_down),
      underline: SizedBox(),
    );
  }
}
