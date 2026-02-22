import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const VangtiChaiHome(),
    );
  }
}

class VangtiChaiHome extends StatefulWidget {
  const VangtiChaiHome({super.key});

  @override
  State<VangtiChaiHome> createState() => _VangtiChaiHomeState();
}

class _VangtiChaiHomeState extends State<VangtiChaiHome> {
  int _amount = 0;

  /// Appends a digit to the current amount from the right.
  void _onDigitPressed(int digit) {
    setState(() {
      // Prevent overflow: cap at 9 digits
      if (_amount < 100000000) {
        _amount = _amount * 10 + digit;
      }
    });
  }

  /// Resets the amount to 0.
  void _onClearPressed() {
    setState(() {
      _amount = 0;
    });
  }

  /// Calculates the change breakdown for the given amount.
  Map<int, int> _calculateChange(int amount) {
    final denominations = [500, 100, 50, 20, 10, 5, 2, 1];
    final Map<int, int> change = {};
    int remaining = amount;
    for (final note in denominations) {
      change[note] = remaining ~/ note;
      remaining = remaining % note;
    }
    return change;
  }

  @override
  Widget build(BuildContext context) {
    final change = _calculateChange(_amount);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    // Consider tablet if shortest side >= 600dp
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide >= 600;

    // Responsive font/size scaling
    final double scaleFactor = isTablet ? 1.5 : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VangtiChai',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22 * scaleFactor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Amount display at the top
            AmountDisplay(amount: _amount, scaleFactor: scaleFactor),
            const Divider(height: 1),
            // Main content: change table + keypad
            Expanded(
              child: _buildMainContent(
                change: change,
                isLandscape: isLandscape,
                isTablet: isTablet,
                scaleFactor: scaleFactor,
                screenWidth: screenWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent({
    required Map<int, int> change,
    required bool isLandscape,
    required bool isTablet,
    required double scaleFactor,
    required double screenWidth,
  }) {
    // In both portrait and landscape, we show table on the left
    // and keypad on the right. The flex ratio differs.
    final int tableFlex;
    final int keypadFlex;

    if (isLandscape) {
      tableFlex = 3;
      keypadFlex = 2;
    } else {
      tableFlex = 1;
      keypadFlex = 1;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Change notes table
        Expanded(
          flex: tableFlex,
          child: ChangeTable(change: change, scaleFactor: scaleFactor),
        ),
        VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
        // Numeric keypad
        Expanded(
          flex: keypadFlex,
          child: NumericKeypad(
            onDigitPressed: _onDigitPressed,
            onClearPressed: _onClearPressed,
            scaleFactor: scaleFactor,
          ),
        ),
      ],
    );
  }
}

/// Displays the current entered amount with a "Taka:" label.
class AmountDisplay extends StatelessWidget {
  final int amount;
  final double scaleFactor;

  const AmountDisplay({
    super.key,
    required this.amount,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24 * scaleFactor,
        vertical: 16 * scaleFactor,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Taka: ',
            style: TextStyle(
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            '$amount',
            style: TextStyle(
              fontSize: 36 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the change breakdown as a table of note denominations.
class ChangeTable extends StatelessWidget {
  final Map<int, int> change;
  final double scaleFactor;

  const ChangeTable({
    super.key,
    required this.change,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    final denominations = [500, 100, 50, 20, 10, 5, 2, 1];

    return Padding(
      padding: EdgeInsets.all(8 * scaleFactor),
      child: Column(
        children: [
          // Table header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 * scaleFactor,
              vertical: 8 * scaleFactor,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Note',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * scaleFactor,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Count',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * scaleFactor,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4 * scaleFactor),
          // Table rows
          Expanded(
            child: ListView.builder(
              itemCount: denominations.length,
              itemBuilder: (context, index) {
                final note = denominations[index];
                final count = change[note] ?? 0;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * scaleFactor,
                    vertical: 6 * scaleFactor,
                  ),
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Theme.of(context).colorScheme.surfaceContainerLow
                        : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '৳$note',
                          style: TextStyle(
                            fontSize: 15 * scaleFactor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 15 * scaleFactor,
                            fontWeight: count > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: count > 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom numeric keypad with digits 0-9 and a Clear button.
class NumericKeypad extends StatelessWidget {
  final void Function(int digit) onDigitPressed;
  final VoidCallback onClearPressed;
  final double scaleFactor;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onClearPressed,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    // Layout: 4 rows x 3 columns
    // Row 1: 1, 2, 3
    // Row 2: 4, 5, 6
    // Row 3: 7, 8, 9
    // Row 4: C, 0, (empty)
    return Padding(
      padding: EdgeInsets.all(8 * scaleFactor),
      child: Column(
        children: [
          _buildRow(context, [1, 2, 3]),
          SizedBox(height: 6 * scaleFactor),
          _buildRow(context, [4, 5, 6]),
          SizedBox(height: 6 * scaleFactor),
          _buildRow(context, [7, 8, 9]),
          SizedBox(height: 6 * scaleFactor),
          _buildSpecialRow(context),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<int> digits) {
    return Expanded(
      child: Row(
        children: digits.map((digit) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3 * scaleFactor),
              child: _DigitButton(
                digit: digit,
                onPressed: () => onDigitPressed(digit),
                scaleFactor: scaleFactor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecialRow(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          // Clear button
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3 * scaleFactor),
              child: SizedBox.expand(
                child: ElevatedButton(
                  onPressed: onClearPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onErrorContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'C',
                    style: TextStyle(
                      fontSize: 22 * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 0 button
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3 * scaleFactor),
              child: _DigitButton(
                digit: 0,
                onPressed: () => onDigitPressed(0),
                scaleFactor: scaleFactor,
              ),
            ),
          ),
          // Empty space
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

/// A single digit button for the numeric keypad.
class _DigitButton extends StatelessWidget {
  final int digit;
  final VoidCallback onPressed;
  final double scaleFactor;

  const _DigitButton({
    required this.digit,
    required this.onPressed,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        child: Text(
          '$digit',
          style: TextStyle(
            fontSize: 24 * scaleFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
