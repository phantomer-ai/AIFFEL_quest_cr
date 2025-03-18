import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ✅ 챌린지 데이터 모델
class Challenge {
  final String title;
  final int seconds;

  Challenge({required this.title, required this.seconds});
}

// ✅ 챌린지 서비스 (API 요청 & 로컬 데이터)
class ChallengeService {
  late final GenerativeModel model;
  final List<Challenge> localChallenges = [
    Challenge(title: '발가락으로 코파기', seconds: 30),
  ];

  ChallengeService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  // ✅ 랜덤 챌린지 생성 (API 요청)
  Future<Challenge> getRandomChallenge() async {
    try {
      final prompt = '''
당신은 JSON 형식의 데이터만 반환하는 AI입니다.
30초 이내에 할 수 있는 재미있는 챌린지나 벌칙 게임을 하나 추천해주세요.

반드시 아래 형식으로만 응답하세요:
{
  "title": "챌린지 설명",
  "seconds": 30
}

''';

      final response = await model.generateContent([Content.text(prompt)]);
      print('API 응답: ${response.text}'); // 응답 확인

      final responseText = response.text;
      if (responseText == null) throw Exception('API 응답 없음');
      String cleanJson = responseText.trim();
      cleanJson =
          cleanJson
              .replaceAll("```json", "")
              .replaceAll("```", "")
              .trim(); // 불필요한 문자 제거

      try {
        final jsonResponse = jsonDecode(cleanJson); // 공백 제거 후 파싱
        return Challenge(
          title: jsonResponse['title'] as String,
          seconds: jsonResponse['seconds'] as int,
        );
      } catch (e) {
        print('JSON 파싱 오류: $e');
        throw Exception('응답이 JSON 형식이 아닙니다');
      }
    } catch (e) {
      print('API 오류 발생: $e');
      return localChallenges[Random().nextInt(localChallenges.length)];
    }
  }

  // ✅ 랜덤 벌칙 목록 (로컬 데이터)
  final List<String> punishments = [
    '제자리 점프 20회 하기',
    '30초 동안 한 발로 서있기',
    '10초 동안 혀 내밀고 있기',
    '벽에 손으로 물구나무서기',
    '개구리처럼 5번 점프하기',
    '15초 동안 춤추기',
    '눈 감고 코 터치하기 10회',
    '20초 동안 웃지 않고 있기',
    '손으로 알파벳 모양 만들기',
    '동물 소리 3가지 내기',
    '거꾸로 말하기 도전',
    '손가락으로 코 만지고 뱅글뱅글 돌기',
  ];

  // ✅ 랜덤 벌칙 가져오기 (로컬 데이터)
  Future<String> getRandomPunishment() async {
    return punishments[Random().nextInt(punishments.length)];
  }
}
