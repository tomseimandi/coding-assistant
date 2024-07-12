"""
This file implements a simple class, with a method to add and a method to substract two numbers.
"""


class SimpleClass():
    """
    A simple class that performs basic arithmetic operations on two numbers.

    Attributes:
        a (int): The first number.
        b (int): The second number.

    Methods:
        add(): Adds the two numbers and returns the result.
        subst(): Subtracts the second number from the first and returns the result.
    """
    def __init__(self, a, b) -> None:
        self.a = a
        self.b = b

    def add(self) -> int:
        return self.a + self.b
    
    def subst(self)  -> int:
        return self.a - self.b


# Another class which does the same thing but for 3 numbers.
class SimpleClass3():

    def __init__(self, a, b, c) -> None:
        self.a = a
        self.b = b
        self.c = c

    def add(self)  -> int:
        return self.a + self.b + self.c
