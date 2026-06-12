import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String initialName;
  final String initialAccountNumber;
  final String initialBalance;

  const SettingsPage({
    Key? key,
    required this.initialName,
    required this.initialAccountNumber,
    required this.initialBalance,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _accountNumberController =
        TextEditingController(text: widget.initialAccountNumber);
    _balanceController = TextEditingController(text: widget.initialBalance);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF005BAC),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _accountNumberController,
              decoration: const InputDecoration(
                labelText: 'Nomor Rekening',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Saldo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'accountNumber': _accountNumberController.text,
                    'balance': _balanceController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005BAC),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
