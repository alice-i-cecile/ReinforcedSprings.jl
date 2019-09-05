import 'package:flutter/material.dart';

String numValidator(String input, num minValue, num maxValue){
  if (input == null){
    return null;
  }

  int x = int.tryParse(input);
  if (x == null){
    return null;
  }

  if (x < minValue){
    x = minValue;
  } else if (x > maxValue){
    x = maxValue;
  }

  String value = x.toString();

  return value;
}

String rangeValidator(String value, num minValue, num maxValue){
  if (value.isEmpty) {
    return 'Please enter a valid number between $minValue and $maxValue';
  }

  int x = int.tryParse(value);
  if (x == null){
    return 'Not a valid number';
  }

  if ((x < minValue) || x > maxValue){
    return 'The number entered must be between $minValue and $maxValue';
  }

  return null;
}

// TODO: add better displayed values
class NumInput extends StatelessWidget{
  final String fieldName;
  final num minValue;
  final num shownValue;
  final num maxValue;
  final updateFunction;
  
  const NumInput({
    @required this.fieldName, 
    @required this.minValue, 
    @required this.shownValue, 
    @required this.maxValue, 
    @required this.updateFunction
  });

  @override
  @override
  Widget build(BuildContext context){
    return(
      Row(children: <Widget>[
        Container(child:
          TextField(
            decoration: InputDecoration(
              labelText: fieldName,
            ),
            keyboardType: TextInputType.number, 
            textAlign: TextAlign.right,
            onChanged: (String input) => updateFunction(num.parse(numValidator(input, minValue, maxValue)))
          ),
          width: 150),
        Text(shownValue.toString())
      ]) 
    );
  }
}