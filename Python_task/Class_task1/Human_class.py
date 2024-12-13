from House_class import House

# 1) Создайте класс Human.
class Human:

    # 2) Определите для него два статических поля: default_name и default_age.
    default_name = 'Noname'
    default_age = 0

    # Создайте метод __init__(), который помимо self принимает еще два параметра: name и age. 
    # Для этих параметров задайте значения по умолчанию, используя свойства default_name и default_age. 
    # В методе __init__() определите четыре свойства: Публичные - name и age. Приватные - money и house.
    def __init__(self, name = default_name, age = default_age) :
        self.name = name
        self.age = age
        self.__money = 0
        self.__house = None

    # 4) Реализуйте справочный метод info(), который будет выводить поля name, age, house и money.
    def info(self) :
        print(f'Name is {self.name} \nAge is {self.age} y.o.')
        print(f'The house {self.__house} \nYou have {self.__money} dollars')

    # 5) Реализуйте справочный статический метод default_info(), 
    # который будет выводить статические поля default_name и default_age.
    @staticmethod
    def default_info():
        print(f'default name is {Human.default_name}')
        print(f'default age is {Human.default_age}')

    # 6) Реализуйте приватный метод make_deal(), который будет отвечать за техническую реализацию 
    # покупки дома: уменьшать количество денег на счету и присваивать ссылку на только что купленный дом. 
    # В качестве аргументов данный метод принимает объект дома и его цену.
    def __make_deal(self, house, price) :
        self.__money -= price
        self.__house = house

    # 7) Реализуйте метод earn_money(), увеличивающий значение свойства money.
    def earn_money(self, add_money) :
        self.__money += add_money

    # 8) Реализуйте метод buy_house(), который будет проверять, что у человека достаточно денег для покупки, и совершать сделку. 
    # Если денег слишком мало - нужно вывести предупреждение в консоль. 
    # Параметры метода: ссылка на дом и размер скидки.
    def buy_house(self, house, discount) :
        price = house.final_price(discount)
        if price >= self.__money :
            print('Not enough money =( ')
        else :
            self.__make_deal(house, price)