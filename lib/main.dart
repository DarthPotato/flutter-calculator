import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minion Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFFD700),
        scaffoldBackgroundColor: const Color(0xFFFFF9C4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          brightness: Brightness.light,
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  String _result = '';
  bool _hasError = false;

  void _onButtonPressed(String buttonText) {
    setState(() {
      _hasError = false;

      if (buttonText == 'C') {
        _display = '0';
        _expression = '';
        _result = '';
      } else if (buttonText == '=') {
        _calculateResult();
      } else if (_isOperator(buttonText)) {
        if (_expression.isEmpty && _display == '0') {
          return;
        }

        if (_expression.isNotEmpty &&
            _isOperator(_expression[_expression.length - 1])) {
          _expression =
              _expression.substring(0, _expression.length - 1) + buttonText;
          _display = _expression;
        } else {
          _expression += buttonText;
          _display = _expression;
        }
      } else {
        if (_display == '0' || _display == _result) {
          _display = buttonText;
          _expression = buttonText;
        } else {
          _display += buttonText;
          _expression += buttonText;
        }
      }
    });
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '*' || char == '/';
  }

  void _calculateResult() {
    try {
      if (_expression.isEmpty) return;

      if (_isOperator(_expression[_expression.length - 1])) {
        _hasError = true;
        _display = 'Error: Invalid expression';
        return;
      }

      String expr = _expression.replaceAll('×', '*').replaceAll('÷', '/');

      Expression exp = Expression.parse(expr);
      const evaluator = ExpressionEvaluator();
      var result = evaluator.eval(exp, {});

      if (result.isInfinite || result.isNaN) {
        _hasError = true;
        _display = 'Error: Division by zero';
        _result = '';
      } else {
        if (result == result.toInt()) {
          _result = result.toInt().toString();
        } else {
          _result = result.toStringAsFixed(8);
          _result = _result.replaceAll(RegExp(r'\.?0+$'), '');
        }
        _display = '$_expression = $_result';
      }
    } catch (e) {
      _hasError = true;
      _display = 'Error: Invalid expression';
      _result = '';
    }
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFFFFEB3B),
            foregroundColor: textColor ?? Colors.black87,
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: Color(0xFFFFD700), width: 2),
            ),
            elevation: 4,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      appBar: AppBar(
        title: const Text(
          'Minion Calculator',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: const Color(0xFFFFD700),
        elevation: 4,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF59D),
                border: Border.all(color: const Color(0xFFFFD700), width: 3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _display,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: _hasError ? Colors.red[700] : Colors.black87,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('/', color: const Color(0xFFFFD54F)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('*', color: const Color(0xFFFFD54F)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('-', color: const Color(0xFFFFD54F)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          'C',
                          color: const Color(0xFFFF6F00),
                          textColor: Colors.white,
                        ),
                        _buildButton('0'),
                        _buildButton(
                          '=',
                          color: const Color(0xFF4CAF50),
                          textColor: Colors.white,
                        ),
                        _buildButton('+', color: const Color(0xFFFFD54F)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
