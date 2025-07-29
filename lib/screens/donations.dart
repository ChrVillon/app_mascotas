import 'package:app_mascotas/Components/app_bar.dart';
import 'package:app_mascotas/styles/app_colors.dart';
import 'package:flutter/material.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  double? selectedAmount;
  bool showCustomField = false;

  void _handleAmountSelect(double? amount) {
    setState(() {
      selectedAmount = amount;
      showCustomField = amount == null;
    });
  }

  void _submitDonation() {
    final double? finalAmount = showCustomField
        ? double.tryParse(_customAmountController.text)
        : selectedAmount;

    if (finalAmount == null || finalAmount <= 0) {
      _showMessage('Por favor ingresa un monto válido.');
      return;
    }

    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      _showMessage('Por favor completa tu nombre y correo.');
      return;
    }

    // Aquí podrías enviar los datos a Firebase, email o servicio de pago
    _showMessage('¡Gracias por tu donación de \$${finalAmount.toStringAsFixed(2)}!');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        showLeading: false,
        title: 'Donaciones',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Tu apoyo ayuda a reunir mascotas perdidas con sus dueños.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            const Text('Selecciona un monto:'),
            Wrap(
              spacing: 10,
              children: [
                _amountButton(1),
                _amountButton(5),
                _amountButton(10),
                _customButton(),
              ],
            ),

            if (showCustomField)
              TextField(
                controller: _customAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Otro monto (\$)',
                ),
              ),

            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tu nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 87.0, right: 87.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimColor,
                ),
                onPressed: _submitDonation,
                child: const Text('Donar ahora',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountButton(double amount) {
    final isSelected = selectedAmount == amount && !showCustomField;
    return ChoiceChip(
      selectedColor: AppColors.selectedColor,
      label: Text('\$$amount'),
      selected: isSelected,
      onSelected: (_) => _handleAmountSelect(amount),
    );
  }

  Widget _customButton() {
    final isSelected = showCustomField;
    return ChoiceChip(
      selectedColor: AppColors.selectedColor,
      label: const Text('Otro'),
      selected: isSelected,
      onSelected: (_) => _handleAmountSelect(null),
    );
  }
}
