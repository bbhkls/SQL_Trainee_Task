# 1. Создайте класс Alphabet
class Alphabet() :

    # 2. Создайте метод __init__(), внутри которого будут определены два динамических свойства: 
        # 1) lang - язык  
        # 2) letters - список букв. 
    # Начальные значения свойств берутся из входных параметров метода.
    def __init__(self, lang, letters) :
        letters = sorted(letters.upper())
        self.lang = lang
        self.letters = letters

    # 3. Создайте метод print(), который выведет в консоль буквы алфавита
    def print(self) :
        for i in self.letters :
            print(i, end = ' ')

    # 4. Создайте метод letters_num(), который вернет количество букв в алфавите
    def letters_num(self) :
        return len(self.letters)

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

# 1. Создайте объект класса EngAlphabet
#print('\nTask 1')
engAlphabet_obj = EngAlphabet()

# 2. Напечатайте буквы алфавита для этого объекта
print('\nTask 2')
engAlphabet_obj.print()
print()

# 3. Выведите количество букв в алфавите
print('\nTask 3')
print(engAlphabet_obj.letters_num())

# 4. Проверьте, относится ли буква F к английскому алфавиту
print('\nTask 4')
engAlphabet_obj.is_en_letter('F')

# 5. Проверьте, относится ли буква Щ к английскому алфавиту
print('\nTask 5')
engAlphabet_obj.is_en_letter('Щ')

# 6. Выведите пример текста на английском языке
print('\nTask 6')
print(engAlphabet_obj.example())