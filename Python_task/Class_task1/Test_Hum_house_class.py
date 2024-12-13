from Human_class import Human
from House_class import House
from SmallHouse_class import SmallHouse

# 1) Вызовите справочный метод default_info()  для класса  Human
print('\nTask 1')
Human.default_info()

# 2) Создайте объект класса Human
#print('\nTask 2')
human_object = Human('Simon', 56)

# 3) Выведите справочную информацию о созданном объекте (вызовите метод  info()).
print('\nTask 3')
human_object.info()

# 4) Создайте объект класса SmallHouse
#print('\nTask 4')
smallHouse_object = SmallHouse(12499)

# 5) Попробуйте купить созданный дом, убедитесь в получении предупреждения.
print('\nTask 5')
human_object.buy_house(smallHouse_object, 5)

# 6) Поправьте финансовое положение объекта - вызовите метод earn_money()
#print('\nTask 6')
human_object.earn_money(15000)

# 7) Снова попробуйте купить дом
#print('\nTask 7')
human_object.buy_house(smallHouse_object, 5)

# 8) Посмотрите, как изменилось состояние объекта класса Human
print('\nTask 8')
human_object.info()