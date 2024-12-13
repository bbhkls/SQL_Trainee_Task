# Напишите программу, которая посчитает факториал от заданного числа 

# через рекурсию
def factorial_recursiv(n) :
    if n == 1 :
        return n
    else :
        return n * factorial_recursiv(n - 1)

# не через рекурсию
# Var 1
def factorial_non_recursiv1(n) :
    product = 1
    while n != 0 :
        product *= n
        n -= 1
    return product

# Var 2
def factorial_non_recursiv2(n) :
    product = 1
    for i in range(1, n + 1):
        product *= i
    return product

n = int(input('Input your number for factorial: '))
print(f'Your factorian from number {n} is:')
print('With recursive: ', factorial_recursiv(n))
print('Without recursive (while): ', factorial_non_recursiv1(n))
print('With recursive (for): ', factorial_non_recursiv2(n))
