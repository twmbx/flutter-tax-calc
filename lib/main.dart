import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(SalaryApp());

class SalaryApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zambian Salary Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Zambian Salary Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FocusNode myFocusNode;

  double _salary = 0;
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
    // print(salary);
    salary = double.parse(salary);
    setState(() {
      if (_isTaxable(salary)) {
        _pension = (salary * 0.05).toStringAsFixed(2);
        _medical = (salary * 0.01).toStringAsFixed(2);

        double taxable = _getTaxableIncome(salary);
        _taxable = taxable.toStringAsFixed(2);
        double duesPayable = _calcTaxes(taxable);
        _duesPayable = duesPayable.toStringAsFixed(2);
        _takehome =
            ((salary - duesPayable) - (salary * 0.05) - (salary * 0.01))
        .toStringAsFixed(2);
      } else {
        _taxable = '0.00';
        _pension = '0.00';
        _medical = '0.00';
        _takehome = '0.00';
        _duesPayable = '0.00';
      }
    });
  }

  double _getTaxableIncome(amount) {
    return amount - _exempt;
  }

  bool _isTaxable(amount) {
    return (amount > 3300) ? true : false;
  }

  double _getTaxPercentage(amount) {
    return amount;
  }

  double calcNapsaContrib(amount) {
    return amount * 0.05;
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
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _amountValidator = RegExInputFormatter.withRegex(
        '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
    final exemptDisplay = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage('assets/icons/payment.png'),
              color: Colors.deepPurple,
              size: 26.0,
              semanticLabel: 'Exempt icon',
            ),
            SizedBox(width: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Exempt',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0 ),
            child: Text(
              'ZMW ' + _exempt.toStringAsFixed(2),
              style: TextStyle(fontFamily: 'Assistant', fontWeight: FontWeight.w400, fontSize: 25),
            ),
          ),
        ),
      ],
    );
    final takeHomeDisplay = Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Take Home',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'ZMW $_takehome',
            style: TextStyle(fontFamily: 'Assistant', fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),
      ],
    );
    final taxableIncomeDisplay = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage('assets/icons/diamond.png'),
              color: Colors.deepPurple,
              size: 26.0,
              semanticLabel: 'diamond icon',
            ),
            SizedBox(width: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Taxable Income',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: Text(
              'ZMW $_taxable',
              style: TextStyle(fontFamily: 'Assistant', fontWeight: FontWeight.w400, fontSize: 25),
            ),
          ),
        ),
      ],
    );
    final pensionContributionDisplay = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage('assets/icons/money.png'),
              color: Colors.deepPurple,
              size: 26.0,
              semanticLabel: 'Pension icon',
            ),
            SizedBox(width: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pension at 5%',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: Text(
              'ZMW $_pension',
              style: TextStyle(fontFamily: 'Assistant', fontWeight: FontWeight.w400, fontSize: 25),
            ),
          ),
        ),
      ],
    );
    final medicalContributionDisplay = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ImageIcon(
              AssetImage('assets/icons/heart.png'),
              color: Colors.deepPurple,
              size: 26.0,
              semanticLabel: 'NHI icon',
            ),
            SizedBox(width: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Medical at 1%',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: Text(
              'ZMW $_medical',
              style: TextStyle(fontFamily: 'Assistant', fontWeight: FontWeight.w400, fontSize: 25),
            ),
          ),
        ),
      ],
    );
    final taxesDueDisplay = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage('assets/icons/tax.png'),
              color: Colors.deepPurple,
              size: 26.0,
              semanticLabel: 'Tax icon',
            ),
            SizedBox(width: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tax',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: Text(
              'ZMW $_duesPayable',
              style: TextStyle(fontFamily: 'Assistant', fontWeight: FontWeight.w400, fontSize: 25),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        // print(text);
                        _changeNumber(text);
                      },
                      decoration: InputDecoration(
                        labelText: 'Salary',
                        prefixText: 'ZMW ',
                        helperText: "enter your monthly salary"
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      inputFormatters: [_amountValidator],
                      // autofocus: true,
                      focusNode: myFocusNode,
                      style: TextStyle(fontSize: 35),
                      maxLength: 8,
                    ),
                  ),
                ],
              ),
              Center(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 24.0),
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Take Home Amount',
                            style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ZMW $_takehome',
                            style: TextStyle(
                              fontFamily: 'Assistant', 
                              fontWeight: FontWeight.w600, 
                              fontSize: 37,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Column(
              //   children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(child: exemptDisplay),
                    Expanded(child: taxableIncomeDisplay),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical:16.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(child: pensionContributionDisplay),
                    Expanded(child: medicalContributionDisplay),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical:16.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(child: taxesDueDisplay),
                    // Expanded(child: takeHomeDisplay),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical:16.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                ),
              ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}
