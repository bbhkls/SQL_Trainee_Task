from Alphabet_class import Alphabet

# 1. Создайте класс EngAlphabet путем наследования от класса Alphabet
class EngAlphabet(Alphabet) :

    # 2. Создайте метод __init__(), внутри которого будет вызываться родительский метод __init__(). 
    # В качестве параметров ему будут передаваться обозначение языка(например, 'En') и строка, состоящая 
    # из всех букв алфавита(можно воспользоваться свойством ascii_uppercase из модуля string).
    def __init__(self) :
        Alphabet.__init__(self, 'En', 'qwertyuiopasdfghjklzxcvbnm')
        

    # 3. Добавьте приватное статическое свойство __letters_num, которое будет хранить количество букв
    # в алфавите.
        self.__letters_num = len(self.letters)

    # 4. Создайте метод is_en_letter(), который будет принимать букву в качестве параметра и определять, 
    # относится ли эта буква к английскому алфавиту.
    def is_en_letter(self, letter) :
        print('Your letter is eng: ', letter in self.letters)

    # 5. Переопределите метод letters_num() пусть в текущем классе классе он будет возвращать значение 
    # свойства __letters_num.
    def letters_num(self) :
        return self.__letters_num

    # 6. Создайте статический метод example(), который будет возвращать пример текста на английском языке.
    @staticmethod
    def example() :
        return 'The rose is red, the violets blue, \nThe honeys sweet, and so are you.'