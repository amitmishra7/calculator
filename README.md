# Calculator

A small demonstration of `math_expressions` to evaluate math expressions.

Hey guys! Today we are going to learn about how to evaluate **math functions** in flutter.


        #math_expressions
        #“A library for parsing and evaluating mathematical expressions”

`math_expression` is a very simple library that is easy to use as shown below.

```
Parser p = Parser();
Expression exp = p.parse(your_expression_here);// expression like '2+2-1/2'.
double val = exp.evaluate(EvaluationType.REAL, null);
```

We will be building a simple calculator app to perform simple functions like add, subtract, multiply, divide, mod. Just a small app only for demonstration. No high expectations please. Haha!

Lets begin!!!

## Step 1 :  Install Packages

Place the below dependencies in your `pubspec.yaml` file and run `flutter pub get`
```
  
  math_expressions: version_here
  
```

## Step 2 : Create UI

Create a new page as `simple_calculator.dart` which will be a stateful widget. This will be the default page of our app.

```
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
```

For creating the UI we will divide the UI in 2 parts. The 1st part to view the expression and 2nd part with the keypad.

For upper part which will hold the expressions and values :

```
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
```

For the lower part of the screen, it will hold the UI of the keypad.

```
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
```

## Step 3 : Build key buttons

We have created a simple method which will be called to build the numeric button.

```
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
```

## Step 4 : Add other important methods

We have created a few other methods as below to make the add validations and make the application go smoother.

`_buildConcatenateFunction()` method is used to concatenate the numbers and operations with each other.

```
_buildConcatenateFunction(String text) {
    setState(() {
      value = value + text;
    });
  }
```

`_isOperatorApplicable()` is used to validate if the operator can be applied to the expression. For example to avoid the case  `2++2`.

```
bool _isOperatorApplicable() {
    if (value.length > 0 &&
        value[value.length-1] != '+' &&
        value[value.length-1] != '-' &&
        value[value.length-1] != 'x' &&
        value[value.length-1] != '%' &&
        value[value.length-1] != '/' &&
        value[value.length-1] != '.') {
      return true;
    } else {
      return false;
    }
  }
```

`_isDotOperatorApplicable()` is used to validate if there are no multiple dot operators used together.

```
 bool _isDotOperatorApplicable() {
    if(lastOperatorUsed=='=' && value.contains('.')){
      return false;
    } else if (lastOperatorUsed != '.') {
      return true;
    } else {
      return false;
    }
  }
```

 `_handleClick()` is used to handle click operations on operators like `+` `-` `x` `/` `%` `<` `c` `.` `=`.

 ```
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
      default :
        if (_isOperatorApplicable()) {
          _buildConcatenateFunction(text);
        }
        break;
    }
  }
```

## Step 5 : Evaluate Expressions

`math_expression` is a very simple library that is easy to use. We have made the `evaluate()` method to evaluate the expression.

```
 void _evaluate() {
    try {
      exp = p.parse(value.replaceAll('x', '*'));//For multiplication in UI we show 'x' but for operations we use '*'
      double val = exp.evaluate(EvaluationType.REAL, null);
      setState(() {
        value = val.toString();
      });
    }catch(err)
    {
      print(err);
    }
  }
```

That's it folks! We're done with all the coding. Just go ahead and run your app!

Fantastic!! You have just learned how to evaluate math expressions in flutter using `math_expressions`.

## Important:

This repository is only for providing information on `math_expressions`. Please do not misuse it.

## Author:

* [Amit Mishra](https://github.com/amitmishra7)

If you like this tutorial please don't forget to add a **Star**. Also follow to get informed for upcoming tutorials.
