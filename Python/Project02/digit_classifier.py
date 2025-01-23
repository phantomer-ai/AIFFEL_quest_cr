from sklearn.datasets import load_digits
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.linear_model import SGDClassifier, LogisticRegression
import sklearn
import matplotlib.pyplot as plt

# 버전 확인
print(f"scikit-learn 버전: {sklearn.__version__}")

# 1. 데이터 준비
digits = load_digits()
X = digits.data
y = digits.target

# 2. 데이터 이해하기
print("\n=== 데이터 정보 ===")
print(f"데이터 크기: {X.shape}")
print(f"레이블 크기: {y.shape}")
print(f"클래스 종류: {digits.target_names}")

# 샘플 이미지 시각화
plt.figure(figsize=(10, 4))
for i in range(10):
    plt.subplot(2, 5, i+1)
    plt.imshow(digits.images[i], cmap='gray')
    plt.title(f'Label: {y[i]}')
plt.tight_layout()
plt.show()

# 3. 데이터 분리
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. 다양한 모델 학습 및 평가
models = {
    'Decision Tree': DecisionTreeClassifier(random_state=42),
    'Random Forest': RandomForestClassifier(random_state=42),
    'SVM': SVC(random_state=42),
    'SGD Classifier': SGDClassifier(random_state=42),
    'Logistic Regression': LogisticRegression(random_state=42)
}

# 각 모델 학습 및 평가
print("\n=== 모델 성능 평가 ===")
for name, model in models.items():
    print(f"\n{name} 모델:")
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    print(classification_report(y_test, y_pred))

# 5. 모델 성능 비교
scores = {name: model.score(X_test, y_test) for name, model in models.items()}

plt.figure(figsize=(10, 5))
plt.bar(scores.keys(), scores.values())
plt.title('모델별 정확도 비교')
plt.xticks(rotation=45)
plt.ylim(0, 1)
for i, v in enumerate(scores.values()):
    plt.text(i, v, f'{v:.3f}', ha='center')
plt.tight_layout()
plt.show()

#(6) 모델을 평가해 보기
# 손글씨 숫자 분류의 경우 다음 지표들이 중요합니다:

# 1. 정확도(Accuracy)
# - 전체 숫자 중에서 올바르게 분류한 비율
# - 모든 숫자가 동일하게 중요하므로 전체 정확도가 중요

# 2. 정밀도(Precision)
# - "이 숫자는 7이다"라고 했을 때 실제로 7인 비율
# - 각 숫자별로 얼마나 정확하게 분류했는지 확인 가능

# 3. 재현율(Recall)
# - 실제 7인 숫자들 중에서 제대로 찾아낸 비율
# - 특정 숫자를 얼마나 잘 인식하는지 확인 가능

# 손글씨 숫자 분류에서는 모든 숫자가 동등하게 중요하므로,
# 정확도(Accuracy)와 각 숫자별 F1-score를 균형있게 보는 것이 좋습니다.
# 이유: 
# 1. 특정 숫자를 다른 숫자로 잘못 인식하는 것이 특별히 치명적이지 않음
# 2. 모든 숫자를 골고루 잘 인식하는 것이 중요
# 3. 실생활에서 모든 숫자가 비슷한 빈도로 사용됨 