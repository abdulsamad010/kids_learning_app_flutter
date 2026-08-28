import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kid_app/features/parent/viewmodels/parent_viewmodel.dart';

class ParentGateScreen extends StatefulWidget {
  const ParentGateScreen({super.key});

  @override
  State<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends State<ParentGateScreen> {
  late int _num1;
  late int _num2;
  late bool _isAddition;
  late int _correctAnswer;
  late List<int> _options;
  String? _feedbackMessage;
  bool _isWrong = false;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    _num1 = random.nextInt(20) + 1;
    _num2 = random.nextInt(20) + 1;
    _isAddition = random.nextBool();

    if (!_isAddition) {
      while (_num1 < _num2) {
        _num1 = random.nextInt(20) + 1;
        _num2 = random.nextInt(20) + 1;
      }
      _correctAnswer = _num1 - _num2;
    } else {
      _correctAnswer = _num1 + _num2;
    }

    final options = <int>{_correctAnswer};
    while (options.length < 4) {
      final offset = random.nextInt(10) - 5;
      final wrong = _correctAnswer + offset;
      if (wrong >= 0 && wrong != _correctAnswer) {
        options.add(wrong);
      }
    }

    _options = options.toList()..shuffle();
    _feedbackMessage = null;
    _isWrong = false;
  }

  void _checkAnswer(int selected) {
    if (selected == _correctAnswer) {
      context.read<ParentViewmodel>().passParentGate();
      Navigator.pushReplacementNamed(context, '/parent-dashboard');
    } else {
      setState(() {
        _isWrong = true;
        _feedbackMessage = "That's not right. Try again!";
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _generateQuestion();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final operator = _isAddition ? '+' : '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Zone'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_rounded,
                size: 64,
                color: colorScheme.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 24),
              Text(
                'Parent Gate',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Solve this to continue',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'What is $_num1 $operator $_num2?',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _options.map((option) {
                  return SizedBox(
                    width: 80,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '$option',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              if (_isWrong && _feedbackMessage != null)
                Text(
                  _feedbackMessage!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
