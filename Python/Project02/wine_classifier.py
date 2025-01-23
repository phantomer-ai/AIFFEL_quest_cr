from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from sklearn.tree import DecisionTreeClassifier          # Decision Tree
from sklearn.ensemble import RandomForestClassifier      # Random Forest
from sklearn.svm import SVC                             # SVM
from sklearn.linear_model import SGDClassifier          # SGD
from sklearn.linear_model import LogisticRegression     # Logistic Regression

# 1. 데이터 준비
wine = load_wine()
X = wine.data
y = wine.target

# 2. 데이터 이해하기
print("\n=== 와인 데이터 정보 ===")
print(f"데이터 크기: {X.shape}")
print(f"레이블 크기: {y.shape}")
print(f"와인 종류: {wine.target_names}")
print("\n특성(feature) 이름:")
for i, feature in enumerate(wine.feature_names):
    print(f"{i+1}. {feature}")

# 3. 데이터 분리
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. 각 모델 학습 및 평가
# Decision Tree
dt = DecisionTreeClassifier()
dt.fit(X_train, y_train)
dt_pred = dt.predict(X_test)
print("\n=== Decision Tree 성능 ===")
print(classification_report(y_test, dt_pred))

# Random Forest
rf = RandomForestClassifier()
rf.fit(X_train, y_train)
rf_pred = rf.predict(X_test)
print("\n=== Random Forest 성능 ===")
print(classification_report(y_test, rf_pred))

# SVM
svm = SVC()
svm.fit(X_train, y_train)
svm_pred = svm.predict(X_test)
print("\n=== SVM 성능 ===")
print(classification_report(y_test, svm_pred))

# SGD Classifier
sgd = SGDClassifier()
sgd.fit(X_train, y_train)
sgd_pred = sgd.predict(X_test)
print("\n=== SGD Classifier 성능 ===")
print(classification_report(y_test, sgd_pred))

# Logistic Regression
lr = LogisticRegression()
lr.fit(X_train, y_train)
lr_pred = lr.predict(X_test)
print("\n=== Logistic Regression 성능 ===")
print(classification_report(y_test, lr_pred))

#(6) 모델을 평가해 보기
# 와인 분류의 경우 다음 지표들이 중요합니다:

# 1. 정확도(Accuracy)
# - 전체 와인 중에서 올바르게 분류한 비율
# - 와인 분류는 잘못 분류해도 치명적이지 않아서 전반적인 정확도가 중요

# 2. 정밀도(Precision)
# - "이 와인은 레드와인이다"라고 했을 때 실제로 맞은 비율
# - 와인 종류별로 얼마나 정확하게 분류했는지 확인 가능

# 3. 재현율(Recall)
# - 실제 레드와인들 중에서 제대로 찾아낸 비율
# - 특정 종류의 와인을 얼마나 잘 찾아내는지 확인 가능

# 와인 분류에서는 정확도(Accuracy)가 가장 중요한 지표입니다.
# 이유: 와인 종류를 잘못 분류하더라도 심각한 문제가 발생하지 않으므로,
# 전체적으로 얼마나 많은 와인을 제대로 분류했는지가 중요합니다.