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