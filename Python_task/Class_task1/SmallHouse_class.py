from House_class import House

# 1) Создайте класс SmallHouse, унаследовав его функционал от класса House
class SmallHouse(House) :

    # 2) Внутри класса SmallHouse переопределите метод __init__() так, чтобы он создавал объект 
    # с площадью 40м2
    default_area = 40

    def __init__(self, price) :
        super().__init__(SmallHouse.default_area, price)