import 'package:flutter/material.dart';
import 'dart:async'; // 타이머를 위한 import 추가
import 'dart:math'; // 랜덤 기능을 위한 import
import 'challenge_service.dart'; // Challenge 클래스와 challenges 리스트를 여기서 가져옴

// 챌린지 목록 삭제 - 이미 challenge_service.dart에 있음

// StatelessWidget을 StatefulWidget으로 변경
class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final ChallengeService _challengeService = ChallengeService();

  // 초기값 설정
  late Challenge _currentChallenge =
      _challengeService.localChallenges.first; // 기본값 설정
  late int _timeLeft = _currentChallenge.seconds;
  late Timer _timer;
  bool _isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _initializeChallenge();
  }

  Future<void> _initializeChallenge() async {
    await _selectRandomChallenge();
    setState(() {
      _isLoading = false;
      _startTimer();
    });
  }

  Future<void> _selectRandomChallenge() async {
    try {
      _currentChallenge = await _challengeService.getRandomChallenge();
      _timeLeft = _currentChallenge.seconds;
    } catch (e) {
      // API 호출 실패시 로컬 챌린지 사용
      final random = Random();
      _currentChallenge =
          _challengeService.localChallenges[random.nextInt(
            _challengeService.localChallenges.length,
          )];
      _timeLeft = _currentChallenge.seconds;
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // 페이지가 종료될 때 타이머 취소
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // New Jump 버튼을 위한 메서드
  Future<void> _newChallenge() async {
    _timer.cancel();
    await _selectRandomChallenge();
    setState(() {
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // 원형 챌린지 타이머 영역
            Container(
              margin: const EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 8),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Challenge',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentChallenge.title, // 랜덤 챌린지 제목
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '${_currentChallenge.seconds} seconds',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _formatTime(_timeLeft), // '00:30' 대신 실제 타이머 값 사용
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // 버튼 그리드
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        text: 'Success',
                        color: const Color(0xFF22C55E),
                        onPressed: () {
                          _timer.cancel(); // 타이머 정지
                          Navigator.pushNamed(context, '/result');
                        },
                      ),
                      _buildButton(
                        text: 'Fail',
                        color: const Color(0xFFEF4444),
                        onPressed: () {
                          _timer.cancel();
                          Navigator.pushNamed(context, '/fail');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        text: 'New Jump',
                        color: Colors.black,
                        onPressed: _newChallenge, // New Jump 버튼 기능 추가
                      ),
                      _buildButton(
                        text: 'Penalty',
                        color: const Color(0xFFEAB308),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 163.5,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 8,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
