import 'package:flutter/material.dart';
import 'challenge_service.dart';

class FailPage extends StatefulWidget {
  const FailPage({super.key});

  @override
  State<FailPage> createState() => _FailPageState();
}

class _FailPageState extends State<FailPage> {
  final ChallengeService _challengeService = ChallengeService();
  String _punishment = '벌칙을 생성중입니다...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPunishment();
  }

  Future<void> _loadPunishment() async {
    final punishment = await _challengeService.getRandomPunishment();
    setState(() {
      _punishment = punishment;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF111827),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // 실패 메시지 섹션
              Column(
                children: [
                  const Icon(Icons.error_outline, size: 96, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Challenge Failed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The multiverse rejects your attempt!',
                    style: TextStyle(color: Colors.grey[300], fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 벌칙 카드
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 벌칙 헤더
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber,
                          size: 48,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Punishment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Random challenge selected',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 벌칙 내용
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(31, 41, 55, 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                _punishment,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 버튼들
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          () => Navigator.pushNamed(context, '/challenge'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Accept Punishment'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View Progress (3/10)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
