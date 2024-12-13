# Любое число при выполнении определенных манипуляций с ним рано или поздно сводится к единице:

# Берем любое натуральное число n. Если оно четное, делим его на 2. Если нечетное – умножаем на 3 
# и прибавляем 1. 
# Повторяем эту операцию с полученным числом до тех пор, пока в результате не получится 1.

def Collatz_conjecture(n, checked_numb) :
    if n == 1 :
        return n
    elif n in checked_numb :
        return 0
    elif n % 2 == 0 and n not in checked_numb:
        checked_numb.append(n)
        return Collatz_conjecture(n / 2, checked_numb) 
    elif n % 2 != 0 and n not in checked_numb:
        checked_numb.append(n)
        return Collatz_conjecture((n * 3) + 1, checked_numb)
    
n = int(input('Input your number for checking: '))

if Collatz_conjecture(n, []) == 0 :
    print(f'For {n} Collatz Conjecture is False')
else :
    print(f'For {n} Collatz Conjecture is True')