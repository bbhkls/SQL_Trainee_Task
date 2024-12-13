# Напишите программу, которая проверяет, является ли число числом Армстронга. 
# Число Армстронга — натуральное число, которое в данной системе счисления равно сумме своих цифр, 
# возведённых в степень, равную количеству его цифр. 

# Пример: 3**3 + 7**3 + 1**3 = 371

def Armstrong_num (n) :
    sum = 0
    length = len(str(n))
    for i in str(n):
        sum += int(i)**length
    return sum

n = int(input('Input your number: '))
print(f'Number {n} is Armstrong number:', Armstrong_num(n) == n)