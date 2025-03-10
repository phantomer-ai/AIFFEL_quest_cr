import 'package:flutter/material.dart';
import '../models/feeding.dart';
import '../models/gecko.dart';

class FeedingPage extends StatefulWidget {
  const FeedingPage({super.key});

  @override
  State<FeedingPage> createState() => _FeedingPageState();
}

class _FeedingPageState extends State<FeedingPage> {
  final List<Feeding> _feedings = []; // 나중에 데이터베이스로 교체
  final List<Gecko> _geckos = []; // 나중에 데이터베이스로 교체

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('먹이 급여'),
          bottom: const TabBar(tabs: [Tab(text: '급여 기록'), Tab(text: '급여 일정')]),
        ),
        body: TabBarView(
          children: [_buildFeedingHistory(), _buildFeedingSchedule()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddFeedingDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildFeedingHistory() {
    if (_feedings.isEmpty) {
      return const Center(child: Text('아직 급여 기록이 없습니다'));
    }

    return ListView.builder(
      itemCount: _feedings.length,
      itemBuilder: (context, index) {
        final feeding = _feedings[index];
        final gecko = _geckos.firstWhere(
          (g) => g.id == feeding.geckoId,
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
            subtitle: Text(
              '${feeding.foodType} ${feeding.amount}${feeding.foodType == "파우더" ? "g" : "마리"}',
            ),
            trailing: Text(
              _formatDate(feeding.date),
              style: const TextStyle(color: Colors.grey),
            ),
            leading: const Icon(Icons.spa),
          ),
        );
      },
    );
  }

  Widget _buildFeedingSchedule() {
    // TODO: 급여 일정 구현
    return const Center(child: Text('준비 중입니다'));
  }

  Future<void> _showAddFeedingDialog(BuildContext context) async {
    if (_geckos.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('먼저 게코를 등록해주세요')));
      return;
    }

    String selectedGeckoId = _geckos.first.id;
    String selectedFoodType = '파우더';
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('급여 기록 추가'),
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
                    value: selectedFoodType,
                    decoration: const InputDecoration(labelText: '먹이 종류'),
                    items:
                        ['파우더', '귀뚜라미', '밀웜'].map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedFoodType = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: '양',
                      suffixText: selectedFoodType == '파우더' ? 'g' : '마리',
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
                  if (amountController.text.isEmpty) {
                    return;
                  }

                  final newFeeding = Feeding(
                    id: DateTime.now().toString(),
                    geckoId: selectedGeckoId,
                    date: DateTime.now(),
                    foodType: selectedFoodType,
                    amount: double.parse(amountController.text),
                    notes:
                        notesController.text.isEmpty
                            ? null
                            : notesController.text,
                  );

                  setState(() {
                    _feedings.add(newFeeding);
                  });

                  Navigator.pop(context);
                },
                child: const Text('추가'),
              ),
            ],
          ),
    );

    amountController.dispose();
    notesController.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일 ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
