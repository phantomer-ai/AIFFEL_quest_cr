import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 88),
              // 이모지와 타이틀
              const Column(
                children: [
                  Text('🎉', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 20),
                  Text(
                    'Great Job!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 스코어 카드
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Challenge Complete!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreItem('42', 'Points'),
                        _buildScoreItem('7', 'Jumps'),
                        _buildScoreItem('3', 'Streak'),
                      ],
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
                      child: const Text('Next Jump'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildGlassButton('View\nAchievements')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildGlassButton('Challenge\nFriends')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String score, String label) {
    return Column(
      children: [
        Text(
          score,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
