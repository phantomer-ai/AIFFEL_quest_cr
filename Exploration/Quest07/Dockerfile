FROM arm64v8/python:3.9-slim

# 기본 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# TensorFlow 및 Flask 설치
RUN pip install tensorflow tensorflow-serving-api flask

# 작업 디렉토리 설정
WORKDIR /app

# 모델 디렉토리 생성
RUN mkdir -p /models

# Python 서빙 스크립트 복사
COPY serve.py /app/

# 포트 노출
EXPOSE 8501

# 서버 실행
CMD ["python", "serve.py"] 