def add_three_numbers(a, b, c):
    return a + b + c

# Test the above function
print(add_three_numbers(1, 2, 3))

# Function that adds 2 numbers
def add_two_numbers(x, y):
    return x + y

# Test the above function
print(add_two_numbers(4, 5))

# Function that divides a number by another one
def divide_two_numbers(x, y):
    """
    This function divides a number 'x' by another number 'y'.

    Parameters:
    x (int or float): The dividend.
    y (int or float): The divisor.

    Returns:
    int or float: The quotient of the division. If y is zero, it returns an error message.
    """
    if y == 0:
        return "Error! Division by zero is not allowed."
    else:
        return x / y

# Test the above function
print(divide_two_numbers(10, 2))

def test_function(a):
    """
    Add 2 to argument a.
    """
    return a + 2

# Function that adds 2 numbers
def new_function(x, y):
    """
    This function adds 2 numbers.
    """
    return x + y