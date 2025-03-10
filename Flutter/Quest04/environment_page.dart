import 'package:flutter/material.dart';
import '../models/environment_record.dart';
import '../models/gecko.dart';

class EnvironmentPage extends StatefulWidget {
  const EnvironmentPage({super.key});

  @override
  State<EnvironmentPage> createState() => _EnvironmentPageState();
}

class _EnvironmentPageState extends State<EnvironmentPage> {
  final List<EnvironmentRecord> _records = []; // 나중에 데이터베이스로 교체
  final List<Gecko> _geckos = []; // 나중에 데이터베이스로 교체

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('환경 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '온습도 기록'),
              Tab(text: '가이드'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecordList(),
            _buildGuide(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddRecordDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildRecordList() {
    if (_records.isEmpty) {
      return const Center(child: Text('아직 기록이 없습니다'));
    }

    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        final gecko = _geckos.firstWhere(
          (g) => g.id == record.geckoId,
          orElse: () => Gecko(
            id: 'unknown',
            name: '삭제된 게코',
            birthDate: DateTime.now(),
            gender: '미확인',
            morph: '미확인',
            adoptionDate: DateTime.now(),
            weight: 0,
          ),
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(gecko.name),
            subtitle: Text('온도: ${record.temperature}°C  습도: ${record.humidity}%'),
            trailing: Text(
              _formatDate(record.date),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuide() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '권장 온도',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 주간: 22-26°C'),
                Text('• 야간: 20-24°C'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '권장 습도',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 주간: 50-70%'),
                Text('• 야간: 60-80%'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '관리 팁',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 하루 2회 분무 권장'),
                Text('• 주 1회 청소 필요'),
                Text('• 온습도계 정기적 점검'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddRecordDialog(BuildContext context) async {
    if (_geckos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 게코를 등록해주세요')),
      );
      return;
    }

    String selectedGeckoId = _geckos.first.id;
    final temperatureController = TextEditingController();
    final humidityController = TextEditingController();
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('환경 기록 추가'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedGeckoId,
                decoration: const InputDecoration(labelText: '게코'),
                items: _geckos.map((gecko) {
                  return DropdownMenuItem(
                    value: gecko.id,
                    child: Text(gecko.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedGeckoId = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: temperatureController,
                decoration: const InputDecoration(
                  labelText: '온도',
                  suffixText: '°C',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: humidityController,
                decoration: const InputDecoration(
                  labelText: '습도',
                  suffixText: '%',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: '특이사항'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (temperatureController.text.isEmpty ||
                  humidityController.text.isEmpty) {
                return;
              }

              final newRecord = EnvironmentRecord(
                id: DateTime.now().toString(),
                geckoId: selectedGeckoId,
                date: DateTime.now(),
                temperature: double.parse(temperatureController.text),
                humidity: double.parse(humidityController.text),
                notes: notesController.text.isEmpty ? null : notesController.text,
              );

              setState(() {
                _records.add(newRecord);
              });

              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );

    temperatureController.dispose();
    humidityController.dispose();
    notesController.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일 ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
} 