import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/gecko.dart';
import './edit_gecko_page.dart';

class GeckoDetailPage extends StatefulWidget {
  final Gecko gecko;

  const GeckoDetailPage({super.key, required this.gecko});

  @override
  State<GeckoDetailPage> createState() => _GeckoDetailPageState();
}

class _GeckoDetailPageState extends State<GeckoDetailPage> {
  late Gecko _gecko;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _gecko = widget.gecko;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // TODO: 실제로는 여기서 이미지를 서버나 로컬 저장소에 업로드하고 URL을 받아야 합니다
        setState(() {
          _gecko = _gecko.copyWith(imageUrl: image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다')));
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        // TODO: 실제로는 여기서 이미지를 서버나 로컬 저장소에 업로드하고 URL을 받아야 합니다
        setState(() {
          _gecko = _gecko.copyWith(imageUrl: photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('사진 촬영 중 오류가 발생했습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gecko.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedGecko = await Navigator.push<Gecko>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGeckoPage(gecko: _gecko),
                ),
              );

              if (updatedGecko != null) {
                setState(() {
                  _gecko = updatedGecko;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_gecko.imageUrl != null)
              Image.network(
                _gecko.imageUrl!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[200],
                child: const Icon(Icons.spa, size: 100, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('기본 정보', [
                    _buildInfoRow('이름', _gecko.name),
                    _buildInfoRow('성별', _gecko.gender),
                    _buildInfoRow('모프', _gecko.morph),
                    _buildInfoRow('체중', '${_gecko.weight}g'),
                  ]),
                  const SizedBox(height: 24),
                  _buildInfoSection('날짜 정보', [
                    _buildInfoRow('출생일', _formatDate(_gecko.birthDate)),
                    _buildInfoRow('입양일', _formatDate(_gecko.adoptionDate)),
                    _buildInfoRow(
                      '나이',
                      '${DateTime.now().difference(_gecko.birthDate).inDays ~/ 365}세',
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('갤러리에서 선택'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('사진 촬영'),
                      onTap: () {
                        Navigator.pop(context);
                        _takePhoto();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
