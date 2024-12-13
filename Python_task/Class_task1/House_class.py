# 1) Создайте класс House
class House() :

    # 2) Создайте метод __init__() и определите внутри него два динамических свойства: _area и _price. 
    # Свои начальные значения они получают из параметров метода __init__()
    def __init__(self, area, price) :
        self._area = area
        self._price = price

    # 3) Создайте метод final_price(), который принимает в качестве параметра размер скидки и возвращает цену
    # с учетом данной скидки.
    def final_price(self, discount) :
        total_discount = (self._price * discount) / 100
        total_price = self._price - total_discount
        return total_price