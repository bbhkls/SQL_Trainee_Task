# поиск анаграмм
from collections import Counter

# Var1
# Dictionary

def dict_fun(word_1, word_2) :

    mas_w1 = {}

    for i in word_1:
        if i in mas_w1:
            mas_w1[i] += 1
        else :
            mas_w1[i] = 1

    mas_w2 = {}

    for i in word_2:
        if i in mas_w2:
            mas_w2[i] += 1
        else :
            mas_w2[i] = 1

    if mas_w2 == mas_w1: 
        print('Yes')
    else :
        print('No')

#Var2
# List

def list_fun(word_1, word_2) :

    mas_w1 = []
    mas_w2 = []

    for i in word_1:
        cnt_l = 0
        for j in word_1:
            if i == j:
                cnt_l += 1
        a = [i, cnt_l]
        if a not in mas_w1:
            mas_w1.append(a)

    for i in word_2:
        cnt_l = 0
        for j in word_2:
            if i == j:
                cnt_l += 1
        a = [i, cnt_l]
        if a not in mas_w2:
            mas_w2.append(a)

    f = 1
    for i in mas_w1:
        for j in mas_w2:
            if i not in mas_w2:
                f = 0
                break
            if j not in mas_w1:
                f = 0
                break

    if f == 1: 
        print('Yes')
    else :
        print('No')

#Var3
# Sort

def sort_fun(word_1, word_2) :
    if sorted(word_1) == sorted(word_2): 
        print('Yes')
    else :
        print('No')

#Var4
# Counter

def counter_fun(word_1, word_2) :
    if Counter(word_1) == Counter(word_2): 
        print('Yes')
    else :
        print('No')

word_1 = input('Введите 1ое слово: ')
print()
word_2 = input('Введите 2ое слово: ')
print('Выберите метод проверки: \n 1 - с помощью инициализации словаря \n 2 - с помощью инициализации списка')
print(' 3 - с помощью сортировки \n 4 - с помощью counter')
meth = int(input('Введите цифру от 1 до 4: '))

while meth < 1 or meth > 4 :
    meth = int(input('Введите цифру от 1 до 4: '))

match meth:
    case 1 : dict_fun(word_1, word_2) 
    case 2 : list_fun(word_1, word_2) 
    case 3 : sort_fun(word_1, word_2) 
    case 4 : counter_fun(word_1, word_2) 