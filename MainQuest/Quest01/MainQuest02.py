import random

class Character:
    def __init__(self, name, level=1, hp=100, attack=10, defense=5):
        self.name = name            # 이름
        self.level = level          # 레벨
        self.max_hp = hp           # 최대 체력
        self.current_hp = hp       # 현재 체력
        self.attack = attack       # 공격력
        self.defense = defense     # 방어력
        self.exp = 0              # 경험치 추가
        self.max_exp = 100        # 레벨업에 필요한 경험치
    
    def is_alive(self):
        return self.current_hp > 0
    
    def take_damage(self, damage):
        # 실제 데미지 계산 (방어력이 더 크면 데미지는 0)
        actual_damage = max(0, damage - self.defense)
        self.current_hp = max(0, self.current_hp - actual_damage)
        return actual_damage
    
    def attack_target(self, target):
        if self.is_alive():
            # 1부터 공격력까지의 랜덤 데미지
            damage = random.randint(1, self.attack)
            actual_damage = target.take_damage(damage)
            return actual_damage
        return 0
    
    def gain_exp(self, amount):
        self.exp += amount
        print(f"{amount}의 경험치를 획득했습니다!")
        self.level_up()
    
    def level_up(self):
        while self.exp >= self.max_exp:
            self.level += 1
            self.exp -= self.max_exp
            self.max_exp = self.level * 100  # 레벨이 올라갈수록 필요 경험치 증가
            
            # 레벨업 보상: 능력치 증가
            self.max_hp += 50
            self.current_hp = self.max_hp  # 체력 회복
            self.attack += 5
            self.defense += 3
            
            print(f"\n레벨업! 현재 레벨: {self.level}")
            print(f"최대 체력: {self.max_hp}")
            print(f"공격력: {self.attack}")
            print(f"방어력: {self.defense}")

def battle(player, monster):
    print(f"\n{player.name} VS {monster.name} 전투 시작!")
    
    while True:
        # 플레이어의 공격
        damage = player.attack_target(monster)
        print(f"{player.name}의 공격! {monster.name}에게 {damage}의 데미지!")
        print(f"{monster.name}의 남은 체력: {monster.current_hp}")
        
        if not monster.is_alive():
            exp_gain = monster.level * 20
            player.gain_exp(exp_gain)
            print("전투 승리!")
            return True
        
        # 몬스터의 공격
        damage = monster.attack_target(player)
        print(f"{monster.name}의 공격! {player.name}에게 {damage}의 데미지!")
        print(f"{player.name}의 남은 체력: {player.current_hp}")
        
        if not player.is_alive():
            print("전투 패배...")
            return False

# 테스트
if __name__ == "__main__":
    player = Character("용사", level=1, hp=100, attack=20, defense=5)
    monster = Character("슬라임", level=1, hp=50, attack=10, defense=2)
    
    battle(player, monster)
