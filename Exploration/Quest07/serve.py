import os
import tensorflow as tf
from tensorflow.keras.models import load_model
from flask import Flask, request, jsonify
import numpy as np

app = Flask(__name__)

# 모델 경로
MODEL_DIR = '/models/model'

# 모델 로드
print(f"모델 디렉토리 경로: {MODEL_DIR}")
print(f"디렉토리 내용: {os.listdir(MODEL_DIR)}")

try:
    model = tf.saved_model.load(MODEL_DIR)
    print("모델 로드 성공!")
    
    # 모델의 서명 확인
    print("모델 서명:", list(model.signatures.keys()))
    
    # 기본 서명 함수 가져오기
    serving_fn = model.signatures['serving_default']
    print("입력 텐서:", serving_fn.structured_input_signature)
    print("출력 텐서:", serving_fn.structured_outputs)
    
except Exception as e:
    print(f"모델 로드 중 오류 발생: {str(e)}")

@app.route('/v1/models/model:predict', methods=['POST'])
def predict():
    try:
        # 요청에서 JSON 데이터 가져오기
        input_data = request.json
        
        # 입력 검증
        if 'instances' not in input_data:
            return jsonify({"error": "요청에 'instances' 필드가 없습니다"}), 400
        
        # 입력 데이터 준비
        instances = input_data['instances']
        
        # 각 입력에 대해 예측 수행
        results = []
        for instance in instances:
            # 입력 형식에 맞게 변환
            tensor_input = {}
            for key, value in instance.items():
                tensor_input[key] = tf.convert_to_tensor([value])
            
            # 예측 실행
            prediction = serving_fn(**tensor_input)
            
            # 결과 변환 (텐서 -> 리스트)
            prediction_dict = {}
            for out_key, out_tensor in prediction.items():
                prediction_dict[out_key] = out_tensor.numpy().tolist()
            
            results.append(prediction_dict)
        
        # 결과 반환
        return jsonify({"predictions": results})
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # 서버 시작
    print("TensorFlow Serving REST API 시작 (포트: 8501)")
    app.run(host='0.0.0.0', port=8501) 