import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../models/gecko.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final List<HealthRecord> _records = [];
  final List<Gecko> _geckos = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('건강 체크'),
          bottom: const TabBar(tabs: [Tab(text: '건강 기록'), Tab(text: '가이드')]),
        ),
        body: TabBarView(children: [_buildRecordList(), _buildGuide()]),
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
          orElse:
              () => Gecko(
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
            subtitle: Text('${record.recordType} - ${record.status}'),
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
                  '탈피 관리',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 정상적인 탈피 주기: 4-8주'),
                Text('• 탈피 전: 색이 흐려지고 불투명해짐'),
                Text('• 탈피 중: 방해하지 않도록 주의'),
                Text('• 탈피 후: 습도 유지 중요'),
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
                  '이상 증상',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 식욕 부진'),
                Text('• 무기력'),
                Text('• 비정상적인 배변'),
                Text('• 피부 문제'),
                Text('• 호흡 곤란'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddRecordDialog(BuildContext context) async {
    if (_geckos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('먼저 게코를 등록해주세요')));
      return;
    }

    String selectedGeckoId = _geckos.first.id;
    String selectedRecordType = '탈피';
    String selectedStatus = '정상';
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('건강 기록 추가'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedGeckoId,
                    decoration: const InputDecoration(labelText: '게코'),
                    items:
                        _geckos.map((gecko) {
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
                  DropdownButtonFormField<String>(
                    value: selectedRecordType,
                    decoration: const InputDecoration(labelText: '기록 유형'),
                    items:
                        ['탈피', '건강 체크', '체중 변화', '식욕 상태'].map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedRecordType = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(labelText: '상태'),
                    items:
                        ['정상', '이상', '관찰 필요'].map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedStatus = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(labelText: '특이사항'),
                    maxLines: 3,
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
                  final newRecord = HealthRecord(
                    id: DateTime.now().toString(),
                    geckoId: selectedGeckoId,
                    date: DateTime.now(),
                    recordType: selectedRecordType,
                    status: selectedStatus,
                    notes:
                        notesController.text.isEmpty
                            ? null
                            : notesController.text,
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

    notesController.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일 ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
