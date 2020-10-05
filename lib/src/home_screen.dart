import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salary/src/components/breakDownGroup.dart';
import 'components/takeHomeDisplay.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FocusNode myFocusNode;

  double _exempt = 3300;
  String _takehome = '0.00';
  String _pension = '0.00';
  String _medical = '0.00';
  String _duesPayable = '0.00';
  List<double> _dues = new List(3);
  String _taxable = '0.00';
  var _bands = [800, 2100];
  var _rates = [0.25, 0.3, 0.37];

  void _changeNumber(salary) {
    salary = double.parse(salary);
    setState(() {
      double pensionDue = _calcNapsaContrib(salary);
      double medicalDue = salary * 0.01;
      _pension = pensionDue.toStringAsFixed(2);
      _medical = medicalDue.toStringAsFixed(2);

      if (_isTaxable(salary)) {
        double taxable = _getTaxableIncome(salary);
        _taxable = taxable.toStringAsFixed(2);
        double duesPayable = _calcTaxes(taxable);
        _duesPayable = duesPayable.toStringAsFixed(2);
        _takehome = (salary - (duesPayable + medicalDue + pensionDue))
            .toStringAsFixed(2);
      } else {
        _taxable = '0.00';
        _duesPayable = '0.00';
        _takehome = (salary - (pensionDue + medicalDue)).toStringAsFixed(2);
      }
    });
  }

  double _getTaxableIncome(amount) {
    return amount - _exempt;
  }

  bool _isTaxable(amount) {
    return (amount > 3300) ? true : false;
  }

  double _calcNapsaContrib(amount) {
    double contrib = amount * 0.05;
    return contrib > 1149.60 ? 1149.60 : contrib;
  }

  double _calcTaxes(tsal) {
    if (tsal <= _bands[0]) {
      _dues[0] = tsal * _rates[0];
      return _dues[0];
    }
    if (tsal <= _bands[1]) {
      _dues[0] = _bands[0] * _rates[0];
      _dues[1] = (tsal - _bands[0]) * _rates[1];
      return _dues[0] + _dues[1];
    }
    if (tsal > (_bands[0] + _bands[1])) {
      _dues[0] = _bands[0] * _rates[0];
      _dues[1] = _bands[1] * _rates[1];
      _dues[2] = (tsal - (_bands[0] + _bands[1])) * _rates[2];
      return _dues[0] + _dues[1] + _dues[2];
    }
    return _dues[0] + _dues[1] + _dues[2];
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        _changeNumber(text);
                      },
                      decoration: InputDecoration(
                          labelText: 'Salary',
                          prefixText: 'ZMW ',
                          helperText: "enter your monthly salary"),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      // autofocus: true,
                      focusNode: myFocusNode,
                      style: TextStyle(fontSize: 35),
                      maxLength: 8,
                    ),
                  ),
                ],
              ),
              Center(
                child: TakeHomeDisplay(
                  takehome: _takehome,
                ),
              ),
              BreakDownGroup(
                exempt: _exempt.toStringAsFixed(2),
                taxable: _taxable,
                pension: _pension,
                medical: _medical,
                payable: _duesPayable,
              )
            ],
          ),
        ),
      ),
    );
  }
}
