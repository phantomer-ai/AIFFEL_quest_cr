from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import LogisticRegression

# 1. 데이터 준비
cancer = load_breast_cancer()
X = cancer.data
y = cancer.target

# 2. 데이터 이해하기
print("\n=== 유방암 데이터 정보 ===")
print(f"데이터 크기: {X.shape}")
print(f"레이블 크기: {y.shape}")
print(f"클래스: {cancer.target_names}")  # malignant(악성), benign(양성)
print("\n특성(feature) 이름:")
for i, feature in enumerate(cancer.feature_names):
    print(f"{i+1}. {feature}")

# 3. 데이터 분리
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. 각 모델 학습 및 평가
# Decision Tree
dt = DecisionTreeClassifier()
dt.fit(X_train, y_train)
dt_pred = dt.predict(X_test)
print("\n=== Decision Tree 성능 ===")
print(classification_report(y_test, dt_pred, target_names=cancer.target_names))

# Random Forest
rf = RandomForestClassifier()
rf.fit(X_train, y_train)
rf_pred = rf.predict(X_test)
print("\n=== Random Forest 성능 ===")
print(classification_report(y_test, rf_pred, target_names=cancer.target_names))

# SVM
svm = SVC()
svm.fit(X_train, y_train)
svm_pred = svm.predict(X_test)
print("\n=== SVM 성능 ===")
print(classification_report(y_test, svm_pred, target_names=cancer.target_names))

# SGD Classifier
sgd = SGDClassifier()
sgd.fit(X_train, y_train)
sgd_pred = sgd.predict(X_test)
print("\n=== SGD Classifier 성능 ===")
print(classification_report(y_test, sgd_pred, target_names=cancer.target_names))

# Logistic Regression
lr = LogisticRegression()
lr.fit(X_train, y_train)
lr_pred = lr.predict(X_test)
print("\n=== Logistic Regression 성능 ===")
print(classification_report(y_test, lr_pred, target_names=cancer.target_names)) 