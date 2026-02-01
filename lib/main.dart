import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

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
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF1A1A1A),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF424242),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

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
      } else if (buttonText == 'x²') {
        _squareNumber();
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

  void _squareNumber() {
    try {
      if (_expression.isEmpty) return;

      // Get the last number in the expression
      String expr = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      Expression exp = Expression.parse(expr);
      const evaluator = ExpressionEvaluator();
      var result = evaluator.eval(exp, {});

      if (result.isInfinite || result.isNaN) {
        _hasError = true;
        _display = 'Error: Invalid value';
        return;
      }

      var squared = result * result;
      
      if (squared == squared.toInt()) {
        _result = squared.toInt().toString();
      } else {
        _result = squared.toStringAsFixed(8);
        _result = _result.replaceAll(RegExp(r'\.?0+$'), '');
      }
      
      _expression = _result;
      _display = '($_expression)² = $_result';
    } catch (e) {
      _hasError = true;
      _display = 'Error: Invalid expression';
      _result = '';
    }
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
    final isDark = widget.isDarkMode;
    final borderColor = isDark ? const Color(0xFF424242) : const Color(0xFFFFD700);
    
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
              side: BorderSide(color: borderColor, width: 2),
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
    final isDark = widget.isDarkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF9FBE7);
    final displayBgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF59D);
    final buttonBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFFEB3B);
    final operatorColor = isDark ? const Color(0xFF424242) : const Color(0xFFFFD54F);
    final borderColor = isDark ? const Color(0xFF424242) : const Color(0xFFFFD700);
    final textColor = isDark ? Colors.white : Colors.black87;
    final appBarColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Minion Calculator',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        backgroundColor: appBarColor,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: widget.onThemeToggle,
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: displayBgColor,
                border: Border.all(color: borderColor, width: 3),
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
                    color: _hasError ? Colors.red[700] : textColor,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                    ? [const Color(0xFF1A1A1A), const Color(0xFF121212)]
                    : [const Color(0xFFFFF9C4), const Color(0xFFFFF59D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('7', color: buttonBgColor, textColor: textColor),
                        _buildButton('8', color: buttonBgColor, textColor: textColor),
                        _buildButton('9', color: buttonBgColor, textColor: textColor),
                        _buildButton('/', color: operatorColor, textColor: textColor),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('4', color: buttonBgColor, textColor: textColor),
                        _buildButton('5', color: buttonBgColor, textColor: textColor),
                        _buildButton('6', color: buttonBgColor, textColor: textColor),
                        _buildButton('*', color: operatorColor, textColor: textColor),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton('1', color: buttonBgColor, textColor: textColor),
                        _buildButton('2', color: buttonBgColor, textColor: textColor),
                        _buildButton('3', color: buttonBgColor, textColor: textColor),
                        _buildButton('-', color: operatorColor, textColor: textColor),
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
                        _buildButton('0', color: buttonBgColor, textColor: textColor),
                        _buildButton(
                          '=',
                          color: const Color(0xFF4CAF50),
                          textColor: Colors.white,
                        ),
                        _buildButton('+', color: operatorColor, textColor: textColor),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          'x²',
                          color: isDark ? const Color(0xFF5C6BC0) : const Color(0xFF9C27B0),
                          textColor: Colors.white,
                        ),
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
