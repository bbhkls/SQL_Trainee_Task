# Палиндром — это последовательность символов, которая одинаково читается в обоих направлениях.

# Реализуйте функцию is_palindrome, осуществляющую проверку, является ли переданная строка str 
# палиндромом и возвращающую True или False соответственно.
# Функция должна быть регистронезависимой по отношению к символам переданной строки.

# срез, не учитывая пробелы
def is_palindrome(str) :
    print(str, ' is palindrome: ', str.lower() == str.lower()[::-1])

# срез, учитывая пробелы
def is_palindrome_s(str) :
    n_str = ''
    for i in str.lower():
        if i != ' ' :
            n_str += i
    print(str, ' is palindrome: ', n_str == n_str[::-1])

#str = input('Input your string: ')
#is_palindrome(str)
#is_palindrome_s(str)
print('Without spaces')
is_palindrome('Это просто строка') # False
is_palindrome('Мороженое') # False
is_palindrome('РА Дар') # False
is_palindrome('МАдам') # True

print('\nWith spaces')
is_palindrome_s('Это просто строка') # False
is_palindrome_s('Мороженое') # False
is_palindrome_s('РА Дар') # True
is_palindrome_s('МАдам') # True