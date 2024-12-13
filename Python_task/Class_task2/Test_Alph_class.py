from EngAlphabet_class import EngAlphabet

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