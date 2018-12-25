print ("eryaswa")

name = input()
print(f'hello, {name}!')

#variables
i = 28
print(f"i is {i}")
f = 2.8
print(f"f is {f}")
b = False
print(f"b is {b}")
n = None
print(f"n is {n}")

#conditions
x = 28
if x > 0:
    print('x is positive')
elif x < 0:
    print('x is negative')  
else:
    print('x is zero')

#sequences
name = 'alice'
coordinates = (10.0, 20.0)
names = ['alice', 'bob', 'charlie']    

#loops
for i in range(5):
    print(i)
names = ['alice', 'bob', 'charlie']
for name in names:
    print(name)

#sets
s = set()
s.add(1)
s.add(3)    
s.add(5)
s.add(3)
print(s)

#dictionaries
ages = {'alice': 22, 'bob': 27}
ages['charlie'] = 30
ages['alice'] += 1
print(ages)

#functions
def square(x):
    return x * x
for i in range(10):
    print('{} squared is {}'.format(i, square(i)))
    
#modules
from functions import square
print(square(10))

#classes
class point:
    def __init__(self, x, y):
        self.x = x
        self.y = y
p = point(3, 5)
print(p.x)
print(p.y)        

   

