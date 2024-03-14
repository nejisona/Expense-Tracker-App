import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/chart/chart.dart';
import 'package:expenses_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpenses = [
    Expense(
      title: "FLutter Cource",
      amount: 499,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Cinema",
      amount: 200,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
        isScrollControlled: true,//this would be responcinle for that our expence enter app take the full screen
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerdExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerdExpenses.indexOf(expense);
    setState(() {
      _registerdExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expenses deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registerdExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = (MediaQuery.of(context).size.width);
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (_registerdExpenses.isEmpty) {
      mainContent = ExpensesList(
          expenses: _registerdExpenses, onRemoveExepense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expens Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registerdExpenses),
                Expanded(
                  child: ExpensesList(
                      expenses: _registerdExpenses,
                      onRemoveExepense: _removeExpense),
                ),
              ],
            )
          : Row(children: [
              Expanded(child: Chart(expenses: _registerdExpenses)),
              Expanded(
                child: ExpensesList(
                    expenses: _registerdExpenses,
                    onRemoveExepense: _removeExpense),
              ),
            ]),
    );
  }
}
