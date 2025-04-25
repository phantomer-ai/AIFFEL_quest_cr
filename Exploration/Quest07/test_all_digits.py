import requests
import numpy as np
import json
import matplotlib.pyplot as plt

# TF Serving 서버 URL
SERVER_URL = 'http://localhost:8501/v1/models/model:predict'

# 숫자별 간단한 패턴 생성 함수
def create_digit_image(digit):
    img = np.zeros((28, 28, 1), dtype=np.float32)
    
    # 각 숫자에 맞는 간단한 패턴 생성
    if digit == 0:  # 0: 원형
        for i in range(5, 23):
            for j in range(5, 23):
                if ((i-14)**2 + (j-14)**2 <= 9**2) and ((i-14)**2 + (j-14)**2 >= 5**2):
                    img[i, j, 0] = 1.0
    
    elif digit == 1:  # 1: 수직선
        for i in range(5, 23):
            img[i, 13:15, 0] = 1.0
    
    elif digit == 2:  # 2: S자 모양
        # 윗부분 곡선
        for j in range(8, 20):
            img[5, j, 0] = 1.0
        for i in range(5, 10):
            img[i, 20, 0] = 1.0
        # 중간 대각선
        for i in range(10, 18):
            img[i, 20-i+10, 0] = 1.0
        # 아래 직선
        for j in range(8, 21):
            img[22, j, 0] = 1.0
    
    elif digit == 3:  # 3: 두 개의 원
        for j in range(8, 20):
            img[5, j, 0] = 1.0
            img[14, j, 0] = 1.0
            img[22, j, 0] = 1.0
        for i in range(5, 14):
            img[i, 20, 0] = 1.0
        for i in range(14, 23):
            img[i, 20, 0] = 1.0
    
    elif digit == 4:  # 4: 직각 패턴
        # 수직선
        for i in range(5, 23):
            img[i, 18, 0] = 1.0
        # 수평선
        for j in range(8, 19):
            img[14, j, 0] = 1.0
        # 왼쪽 수직선
        for i in range(5, 15):
            img[i, 8, 0] = 1.0
    
    elif digit == 5:  # 5: S자 반대 방향
        # 윗부분 직선
        for j in range(8, 21):
            img[5, j, 0] = 1.0
        # 왼쪽 수직선
        for i in range(5, 14):
            img[i, 8, 0] = 1.0
        # 중간 직선
        for j in range(8, 20):
            img[14, j, 0] = 1.0
        # 오른쪽 수직선
        for i in range(14, 23):
            img[i, 20, 0] = 1.0
        # 아래 직선
        for j in range(8, 20):
            img[22, j, 0] = 1.0
    
    elif digit == 6:  # 6: 왼쪽에 붙은 동그라미
        # 왼쪽 수직선
        for i in range(5, 23):
            img[i, 8, 0] = 1.0
        # 원형
        for i in range(14, 23):
            for j in range(9, 20):
                if ((i-18)**2 + (j-14)**2 <= 5**2) and ((i-18)**2 + (j-14)**2 >= 2**2):
                    img[i, j, 0] = 1.0
        # 윗 부분 직선
        for j in range(8, 18):
            img[5, j, 0] = 1.0
    
    elif digit == 7:  # 7: 상단 직선과 대각선
        # 상단 직선
        for j in range(8, 21):
            img[5, j, 0] = 1.0
        # 대각선
        for i in range(5, 23):
            j = int(20 - (i-5) * 0.5)
            if 8 <= j <= 20:
                img[i, j, 0] = 1.0
    
    elif digit == 8:  # 8: 두 개의 원 위아래로
        # 위쪽 원
        for i in range(5, 14):
            for j in range(8, 21):
                if ((i-9)**2 + (j-14)**2 <= 5**2) and ((i-9)**2 + (j-14)**2 >= 2**2):
                    img[i, j, 0] = 1.0
        # 아래쪽 원
        for i in range(14, 23):
            for j in range(8, 21):
                if ((i-18)**2 + (j-14)**2 <= 5**2) and ((i-18)**2 + (j-14)**2 >= 2**2):
                    img[i, j, 0] = 1.0
    
    elif digit == 9:  # 9: 위에 원, 아래로 직선
        # 위쪽 원
        for i in range(5, 14):
            for j in range(8, 21):
                if ((i-9)**2 + (j-14)**2 <= 5**2) and ((i-9)**2 + (j-14)**2 >= 2**2):
                    img[i, j, 0] = 1.0
        # 오른쪽 직선
        for i in range(5, 23):
            img[i, 20, 0] = 1.0
    
    return img

# 모든 숫자 테스트
results = []
for digit in range(10):
    # 테스트 이미지 생성
    test_image = create_digit_image(digit)
    
    # 이미지 데이터를 리스트로 변환
    image_data = test_image.tolist()
    
    # 요청 데이터 구성
    payload = {
        "instances": [
            {
                "inputs": image_data
            }
        ]
    }
    
    # 요청 전송 및 응답 수신
    try:
        print(f"\n숫자 {digit} 테스트 중...")
        response = requests.post(SERVER_URL, json=payload)
        
        if response.status_code == 200:
            result = response.json()
            
            # 예측 결과 확인
            if 'predictions' in result:
                predictions = result['predictions'][0]['output_0'][0]
                predicted_class = np.argmax(predictions)
                confidence = predictions[predicted_class]
                print(f"예측된 클래스: {predicted_class}, 신뢰도: {confidence:.4f}")
                
                results.append({
                    "true_digit": digit,
                    "predicted_digit": predicted_class,
                    "confidence": confidence,
                    "all_probabilities": predictions,
                    "image": test_image
                })
            else:
                print("예측 결과를 찾을 수 없습니다:", result)
        else:
            print(f"오류 발생: {response.status_code}, {response.text}")
    except Exception as e:
        print(f"요청 중 오류 발생: {str(e)}")

# 결과 시각화
plt.figure(figsize=(15, 10))

for i, result in enumerate(results):
    # 3x10 그리드에 시각화
    # 첫 번째 행: 입력 이미지
    plt.subplot(3, 10, i+1)
    plt.imshow(result["image"][:, :, 0], cmap='gray')
    plt.title(f'입력: {result["true_digit"]}')
    plt.axis('off')
    
    # 두 번째 행: 예측 결과
    plt.subplot(3, 10, i+11)
    plt.text(0.5, 0.5, f'예측: {result["predicted_digit"]}\n신뢰도: {result["confidence"]:.2f}', 
             horizontalalignment='center', verticalalignment='center')
    plt.axis('off')
    
    # 세 번째 행: 확률 분포
    plt.subplot(3, 10, i+21)
    plt.bar(range(10), result["all_probabilities"])
    plt.xticks(range(10), fontsize=8)
    plt.yticks([])

plt.tight_layout()
plt.savefig('all_digits_prediction.png')
print("\n모든 숫자에 대한 예측 결과가 'all_digits_prediction.png' 파일에 저장되었습니다.") 