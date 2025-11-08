import math
from hashlib import shake_256

class ExampleClass:
    def __init__(self, p, Fp, m, capacity, N):
        self.p = p
        self.Fp = Fp
        self.m = m
        self.capacity = capacity
        self.N = N
    
    def _get_round_constants(self):
        bytes_per_int = math.ceil(len(bin(self.p)[2:]) / 8) + 1
        num_bytes = bytes_per_int * 3 * self.m * self.N
        seed_string = f"XHash({self.p},{self.m},{self.capacity})"
        byte_string = shake_256(bytes(seed_string, "ascii")).digest(num_bytes)
        round_constants = []
        for i in range(3 * self.m * self.N):
            chunk = byte_string[bytes_per_int * i : bytes_per_int * (i + 1)]
            integer = sum((256**j) * chunk[j] for j in range(len(chunk)))
            round_constants.append(self.Fp(integer))
        return round_constants

# Example usage
if __name__ == "__main__":
    # Define parameters
    p = 2^31-1  
    Fp = lambda x: x % p  # Fp is the field of integers modulo p
    m = 24
    capacity = 8  
    N = 7
    example_instance = ExampleClass(p, Fp, m, capacity, N)
    round_constants = example_instance._get_round_constants()

    print(round_constants)
