import 'package:flutter/material.dart';
import '../models/breeding_record.dart';
import '../models/gecko.dart';

class BreedingPage extends StatefulWidget {
  const BreedingPage({super.key});

  @override
  State<BreedingPage> createState() => _BreedingPageState();
}

class _BreedingPageState extends State<BreedingPage> {
  final List<BreedingRecord> _records = [];
  final List<Gecko> _geckos = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('번식 관리'),
          bottom: const TabBar(tabs: [Tab(text: '번식 기록'), Tab(text: '가이드')]),
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
        final female = _geckos.firstWhere(
          (g) => g.id == record.femaleGeckoId,
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
            title: Text('${female.name} - ${record.status}'),
            subtitle: Text(
              '교배일: ${_formatDate(record.matingDate)}\n'
              '${record.layingDate != null ? '산란일: ${_formatDate(record.layingDate!)}' : ''}',
            ),
            isThreeLine: true,
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
                  '번식 조건',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 암컷: 최소 40g 이상'),
                Text('• 수컷: 최소 35g 이상'),
                Text('• 나이: 18개월 이상'),
                Text('• 건강 상태: 양호'),
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
                  '알 관리',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• 부화 기간: 60-90일'),
                Text('• 온도: 24-26°C'),
                Text('• 습도: 70-80%'),
                Text('• 기질: 버미큘라이트 등'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddRecordDialog(BuildContext context) async {
    final femaleGeckos = _geckos.where((g) => g.gender == '암컷').toList();
    final maleGeckos = _geckos.where((g) => g.gender == '수컷').toList();

    if (femaleGeckos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('암컷 게코를 먼저 등록해주세요')));
      return;
    }

    String selectedFemaleId = femaleGeckos.first.id;
    String? selectedMaleId = maleGeckos.isEmpty ? null : maleGeckos.first.id;
    String selectedStatus = '교배 중';
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('번식 기록 추가'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedFemaleId,
                    decoration: const InputDecoration(labelText: '암컷'),
                    items:
                        femaleGeckos.map((gecko) {
                          return DropdownMenuItem(
                            value: gecko.id,
                            child: Text(gecko.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedFemaleId = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (maleGeckos.isNotEmpty)
                    DropdownButtonFormField<String?>(
                      value: selectedMaleId,
                      decoration: const InputDecoration(labelText: '수컷'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('선택 안함'),
                        ),
                        ...maleGeckos.map((gecko) {
                          return DropdownMenuItem(
                            value: gecko.id,
                            child: Text(gecko.name),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        selectedMaleId = value;
                      },
                    ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(labelText: '상태'),
                    items:
                        ['교배 중', '산란 완료', '부화 완료'].map((status) {
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
                  final newRecord = BreedingRecord(
                    id: DateTime.now().toString(),
                    femaleGeckoId: selectedFemaleId,
                    maleGeckoId: selectedMaleId,
                    matingDate: DateTime.now(),
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
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
