import random

# Q1. Account 클래스 : 은행에 가서 계좌를 개설하면 은행이름, 예금주, 계좌번호, 잔액이 설정됩니다. Account 클래스를 생성한 후 생성자(hint: 매직매서드..!!)를 구현해보세요. 생성자에서는 예금주와 초기 잔액만 입력 받습니다. 은행이름은 SC은행으로 계좌번호는 3자리-2자리-6자리 형태로 랜덤하게 생성됩니다. (은행이름: SC은행, 계좌번호: 111-11-111111)

class Account:
    # 클래스 변수로 계좌 개수 저장
    account_count = 0 #클래스 변수 정의
    bank_name = "SC은행"  # 은행이름은 SC은행으로 고정
    # 생성자 정의 기본적인 클래스의 변하지 않는 속성을 정함 
    def __init__(self, name, balance):  # 매직메서드인 생성자
        self.name = name                # 예금주
        self.balance = balance          # 초기 잔액
        self.account_num = self.generate_account_num()  # 계좌번호 자동생성
        Account.account_count += 1      # 계좌 개수 증가
        self.deposit_count = 0    # 입금 횟수를 저장할 변수 추가
        self.deposit_history = []   # 입금 내역 리스트
        self.withdraw_history = []  # 출금 내역 리스트
    # 계좌번호 생성 메서드 
    def generate_account_num(self):
        # 3자리-2자리-6자리 형태로 계좌번호 생성
        return f"{random.randint(100, 999)}-{random.randint(10, 99)}-{random.randint(100000, 999999)}"
    # 계좌 개수 조회 메서드 클래스를 활용해서 인스턴스를 생성하지 않고 클래스에서 직접 매서드 호출
    @classmethod  # 클래스 메서드 데코레이터
    def get_account_num(cls):
        return f"총 계좌 개수: {cls.account_count}개"
    # 입금 메서드 
    def deposit(self, amount):
        if amount >= 1:  # 최소 1원 이상만 입금 가능
            self.balance += amount
            self.deposit_count += 1  # 입금 횟수 증가
            self.deposit_history.append((amount, self.balance))  # (입금액, 잔액) 튜플로 저장
            
            # 5회차 입금시 이자 지급
            if self.deposit_count == 5:
                interest = int(self.balance * 0.01)  # 1% 이자 계산
                self.balance += interest
                self.deposit_history.append((interest, self.balance))  # 이자도 입금 내역에 추가
                return f"{amount:,}원이 입금되었습니다. 입금 5회차 이자 {interest:,}원이 추가되었습니다. 현재 잔액: {self.balance:,}원"
            
            return f"{amount:,}원이 입금되었습니다. 현재 잔액: {self.balance:,}원"
        else:
            return "1원 이상만 입금 가능합니다."
    # 출금 메서드 
    def withdraw(self, amount):
        if amount <= self.balance:  # 잔고 이상 출금 불가
            self.balance -= amount
            self.withdraw_history.append((amount, self.balance))  # (출금액, 잔액) 튜플로 저장
            return f"{amount:,}원이 출금되었습니다. 현재 잔액: {self.balance:,}원"
        else:
            return f"잔액이 부족합니다. 현재 잔액: {self.balance:,}원"
    # 정보 출력 메서드
    def display_info(self):
        return f"은행이름: {self.bank_name}, 예금주: {self.name}, 계좌번호: {self.account_num}, 잔고: {self.balance:,}원"
    # 입금 내역 조회 메서드
    def show_deposit_history(self):
        print(f"\n=== {self.name}님의 입금 내역 ===")
        for amount, balance in self.deposit_history:
            print(f"입금액: {amount:,}원 / 잔액: {balance:,}원")
    # 출금 내역 조회 메서드
    def show_withdraw_history(self):
        print(f"\n=== {self.name}님의 출금 내역 ===")
        for amount, balance in self.withdraw_history:
            print(f"출금액: {amount:,}원 / 잔액: {balance:,}원")

# 여러 계좌 생성 및 리스트 저장
accounts = []  # 계좌들을 저장할 리스트

# 3개의 계좌 생성 (금액 수정)
account1 = Account("천주호", 500000)
account2 = Account("김철수", 1500000)  # 100만원 이상
account3 = Account("이영희", 2000000)  # 100만원 이상

# 리스트에 계좌 추가
accounts.append(account1)
accounts.append(account2)
accounts.append(account3)

# 생성된 모든 계좌 정보 확인
print("=== 전체 계좌 목록 ===")
for account in accounts:
    print(account.display_info())

# 100만원 이상 고객 찾기
print("\n=== 100만원 이상 고객 목록 ===")
for account in accounts:
    if account.balance >= 1000000:
        print(account.display_info())

# 거래 내역 테스트
account1 = Account("천주호", 10000)
account1.deposit(5000)
account1.deposit(3000)
account1.withdraw(1000)
account1.deposit(2000)

# 거래 내역 조회
account1.show_deposit_history()
account1.show_withdraw_history()