# Строка с множеством скобок, проверить корректность
str = input('Введите строку: ')

# Tests
#str = '([{{[][]}}])'
#str = '([{{[][]}}])(('
#str = '([{{[][]}}])))'
#str = '(({)})'
print()

#check = {'{' : '}', '[' : ']', '(' : ')'}
check = {'}' : '{', ']' : '[', ')' : '('}
#print(check)

save_s = []
f = 1
for i in str :
    if i in check.values() :
        save_s.append(i)
    elif i in check.keys() :
        if len(save_s) == 0 or save_s.pop() != check[i] :
        #print('else')
        #print(i)
        #print(save_s)
        #print(save_s.pop())
            f = 0
    # print()
    # print(i)
    # print(save_s)

print(f == 1 and len(save_s) == 0)