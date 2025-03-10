import 'package:flutter/material.dart';
import '../models/gecko.dart';
import '../pages/add_gecko_page.dart';
import '../pages/gecko_detail_page.dart';

class GeckoListPage extends StatefulWidget {
  const GeckoListPage({super.key});

  @override
  State<GeckoListPage> createState() => _GeckoListPageState();
}

class _GeckoListPageState extends State<GeckoListPage> {
  final List<Gecko> _geckos = []; // 나중에 데이터베이스로 교체 예정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _geckos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.spa, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      '아직 등록된 게코가 없습니다',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _geckos.length,
                itemBuilder: (context, index) {
                  final gecko = _geckos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            gecko.imageUrl != null
                                ? NetworkImage(gecko.imageUrl!)
                                : null,
                        child:
                            gecko.imageUrl == null
                                ? const Icon(Icons.spa)
                                : null,
                      ),
                      title: Text(gecko.name),
                      subtitle: Text('${gecko.morph} • ${gecko.gender}'),
                      trailing: Text(
                        '${DateTime.now().difference(gecko.birthDate).inDays ~/ 365}세',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeckoDetailPage(gecko: gecko),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Gecko>(
            context,
            MaterialPageRoute(builder: (context) => const AddGeckoPage()),
          );

          if (result != null) {
            setState(() {
              _geckos.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
