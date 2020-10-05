import 'package:flutter/material.dart';
import 'breakDownDisplay.dart';

class BreakDownGroup extends StatelessWidget {
  final String exempt;
  final String taxable;
  final String pension;
  final String medical;
  final String payable;

  BreakDownGroup({
    this.exempt,
    this.taxable,
    this.pension,
    this.medical,
    this.payable,
  });

  Widget build(context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: BreakDownDisplay(
                  amount: exempt,
                  title: 'Exempt',
                  icon: 'assets/icons/vault.png',
                  iconLabel: 'exempt icon',
                ),
              ),
              Expanded(
                child: BreakDownDisplay(
                  amount: taxable,
                  title: 'Taxable Income',
                  icon: 'assets/icons/taxable.png',
                  iconLabel: 'money cut icon',
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            ),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: BreakDownDisplay(
                  amount: pension,
                  title: 'Pension at 5%',
                  icon: 'assets/icons/money.png',
                  iconLabel: 'pension icon',
                ),
              ),
              Expanded(
                child: BreakDownDisplay(
                  amount: medical,
                  title: 'Medical at 1%',
                  icon: 'assets/icons/heart.png',
                  iconLabel: 'medical icon',
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            ),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: BreakDownDisplay(
                  amount: payable,
                  title: 'Tax',
                  icon: 'assets/icons/tax.png',
                  iconLabel: 'tax icon',
                ),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            ),
          ),
        ),
      ],
    );
  }
}
