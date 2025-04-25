import requests
import numpy as np
import json
import matplotlib.pyplot as plt

# TF Serving 서버 URL
SERVER_URL = 'http://localhost:8501/v1/models/model:predict'

# 테스트용 더미 데이터 생성 (28x28 크기의 0으로 채워진 이미지)
# 실제 테스트에서는 적절한 이미지 데이터를 사용해야 합니다
test_image = np.zeros((28, 28, 1), dtype=np.float32)
# 간단한 패턴 추가 (숫자 1과 비슷한 패턴)
test_image[5:23, 13:15, 0] = 1.0

# 이미지 데이터를 리스트로 변환 (JSON 직렬화 가능)
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
    print("예측 요청 전송 중...")
    response = requests.post(SERVER_URL, json=payload)
    
    if response.status_code == 200:
        print("성공적으로 응답을 받았습니다.")
        result = response.json()
        print("응답 데이터:", json.dumps(result, indent=2))
        
        # 예측 결과 확인
        if 'predictions' in result:
            # 응답 구조에 맞게 수정: [0]['output_0'][0]
            predictions = result['predictions'][0]['output_0'][0]
            predicted_class = np.argmax(predictions)
            confidence = predictions[predicted_class]
            print(f"예측된 클래스: {predicted_class}, 신뢰도: {confidence:.4f}")
            
            # 예측 확률 시각화
            plt.figure(figsize=(10, 4))
            plt.subplot(1, 2, 1)
            plt.imshow(test_image[:, :, 0], cmap='gray')
            plt.title('테스트 이미지')
            plt.axis('off')
            
            plt.subplot(1, 2, 2)
            plt.bar(range(10), predictions)
            plt.xlabel('클래스')
            plt.ylabel('확률')
            plt.title('예측 확률 분포')
            plt.xticks(range(10))
            plt.savefig('prediction_result.png')
            print("'prediction_result.png' 파일에 시각화 결과가 저장되었습니다.")
        else:
            print("예측 결과를 찾을 수 없습니다:", result)
    else:
        print(f"오류 발생: {response.status_code}, {response.text}")
except Exception as e:
    print(f"요청 중 오류 발생: {str(e)}") 