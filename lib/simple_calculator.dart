import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SimpleCalculatorPage extends StatefulWidget {
  @override
  _SimpleCalculatorPageState createState() => _SimpleCalculatorPageState();
}

class _SimpleCalculatorPageState extends State<SimpleCalculatorPage> {
  String value = ''; // to hold the expression or its value
  String lastOperatorUsed = ''; // to identify last operation performed
  Parser p = Parser();
  Expression exp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildExpression(),
          _buildKeyPad(),
        ],
      ),
    );
  }

  _buildExpression() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: Align(
            alignment: Alignment.bottomRight,
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 20),
              style: TextStyle(fontSize: 40, color: Colors.black),
              child: Text(value),
            ),
          ),
        ),
      ),
    );
  }

  _buildKeyPad() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      color: Colors.lightBlue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                _buildKeyButton("c", true),
                _buildKeyButton("%", true),
                _buildKeyButton("<", true),
                _buildKeyButton("/", true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKeyButton("7", false),
                _buildKeyButton("8", false),
                _buildKeyButton("9", false),
                _buildKeyButton("x", true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKeyButton("4", false),
                _buildKeyButton("5", false),
                _buildKeyButton("6", false),
                _buildKeyButton("-", true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKeyButton("1", false),
                _buildKeyButton("2", false),
                _buildKeyButton("3", false),
                _buildKeyButton("+", true),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKeyButton("0", false),
                _buildKeyButton("00", false),
                _buildKeyButton(".", false),
                _buildKeyButton("=", true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildKeyButton(String text, bool isSpecial) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (text == ".") {
            if (_isDotOperatorApplicable()) {
              setState(() {
                lastOperatorUsed = '.';
              });
              _buildConcatenateFunction(".");
            }
          } else {
            if (isSpecial != null && isSpecial) {
              setState(() {
                lastOperatorUsed = text;
              });
              _handleClick(text);
            } else {
              _buildConcatenateFunction(text);
            }
          }
        },
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 35,
                color: isSpecial ? Colors.lightBlueAccent : Colors.black),
          ),
        ),
      ),
    );
  }

  _buildConcatenateFunction(String text) {
    setState(() {
      value = value + text;
    });
  }

  bool _isOperatorApplicable() {
    if (value.length > 0 &&
        value[value.length - 1] != '+' &&
        value[value.length - 1] != '-' &&
        value[value.length - 1] != 'x' &&
        value[value.length - 1] != '%' &&
        value[value.length - 1] != '/' &&
        value[value.length - 1] != '.') {
      return true;
    } else {
      return false;
    }
  }

  bool _isDotOperatorApplicable() {
    if (lastOperatorUsed == '=' && value.contains('.')) {
      return false;
    } else if (lastOperatorUsed != '.') {
      return true;
    } else {
      return false;
    }
  }

  _handleClick(String text) {
    switch (text) {
      case "<":
        if (value.length > 0) {
          setState(() {
            value = value.substring(0, value.length - 1);
          });
        }
        break;
      case "c":
        setState(() {
          value = '';
        });
        break;
      case "=":
        _evaluate();
        break;
      default:
        if (_isOperatorApplicable()) {
          _buildConcatenateFunction(text);
        }
        break;
    }
  }

  void _evaluate() {
    try {
      exp = p.parse(value.replaceAll('x',
          '*')); //For multiplication in UI we show 'x' but for operations we use '*'
      double val = exp.evaluate(EvaluationType.REAL, null);
      setState(() {
        value = val.toString();
      });
    } catch (err) {
      print(err);
    }
  }
}
