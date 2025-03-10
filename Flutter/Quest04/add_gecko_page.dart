import 'package:flutter/material.dart';
import '../models/gecko.dart';

class AddGeckoPage extends StatefulWidget {
  const AddGeckoPage({super.key});

  @override
  State<AddGeckoPage> createState() => _AddGeckoPageState();
}

class _AddGeckoPageState extends State<AddGeckoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedGender = '암컷';
  final _morphController = TextEditingController();
  DateTime _birthDate = DateTime.now();
  DateTime _adoptionDate = DateTime.now();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _morphController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthDate ? _birthDate : _adoptionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _birthDate = picked;
        } else {
          _adoptionDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 게코 등록'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: '성별',
                border: OutlineInputBorder(),
              ),
              items:
                  ['암컷', '수컷', '미확인'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _morphController,
              decoration: const InputDecoration(
                labelText: '모프',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '모프를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('출생일'),
              subtitle: Text(
                '${_birthDate.year}년 ${_birthDate.month}월 ${_birthDate.day}일',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('입양일'),
              subtitle: Text(
                '${_adoptionDate.year}년 ${_adoptionDate.month}월 ${_adoptionDate.day}일',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: '체중 (g)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '체중을 입력해주세요';
                }
                if (double.tryParse(value) == null) {
                  return '올바른 숫자를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: 데이터베이스에 저장
                  final newGecko = Gecko(
                    id: DateTime.now().toString(), // 임시 ID
                    name: _nameController.text,
                    birthDate: _birthDate,
                    gender: _selectedGender,
                    morph: _morphController.text,
                    adoptionDate: _adoptionDate,
                    weight: double.parse(_weightController.text),
                  );
                  Navigator.pop(context, newGecko);
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('등록하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
