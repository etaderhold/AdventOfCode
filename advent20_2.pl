#!/usr/bin/perl

my $PRESENTS_PER_ELF = 11;
my $GOAL = 36000000;

sub add_valid_products {
    my ($index, $valid_primes, $current_product, $house_num, $array) = (@_);
    
    # Base case: we have multiplied by each prime factor.
    # Return factor if the elf delivers to that house.
    if ($index == $valid_primes) {
        my $elf_num = $current_product / $PRESENTS_PER_ELF;
        if ($elf_num * 50 >= $house_num) {
            return $current_product;
        }
        else {
            return 0;
        }
    }

    # Recursive case: Multiply running product by each power of current prime factor, add them up.
    my $sum = 0;
    foreach my $prime_power (@{$$array[$index]}) {
        $sum += add_valid_products($index + 1, $valid_primes, $current_product * $prime_power, $house_num, $array);
    }

    return $sum;
}
    

my $max_prime = 1000000;

# Sieve of Eratosthenes.
# Generate an array of all primes less than $max_prime.
for my $i (2..$max_prime) {
    unless ($non_primes[$i]) {
        push @primes, $i;
        my $value = 2 * $i;
        while ($value <= $max_prime) {
            $non_primes[$value]++;
            $value += $i;
        }
    }
}

my $house_num = 0;
while (!$done) {
    # Find prime factorization of house number
    my $presents = 10;

    my $remaining_factor = $house_num;
    my $unique_primes = 0;
    my @prime_factor_powers;
    
    foreach my $prime (@primes) {
        last if $prime > $remaining_factor;
        my $divisions = 0;

        while ($remaining_factor % $prime == 0) {
            $remaining_factor /= $prime;
            $divisions++;
        }

        # Add powers of prime factors to a two-dimensional array.
        if ($divisions) {
            my $sum = 0;
            foreach my $i (0..$divisions) {
                $prime_factor_powers[$unique_primes][$i] = $prime ** $i;
            }
            $unique_primes++;
        }
    }

    # Recursively calculate number of presents for this house.
    my $presents = add_valid_products(0, $unique_primes, $PRESENTS_PER_ELF, $house_num, \@prime_factor_powers);

    if ($remaining_factor > 1) {
        push @primes, $remaining_factor;
    }

    if ($presents > $max_presents) {
        $max_presents = $presents;
        print "House $house_num has $presents presents.\n";
    }
    
    if ($presents >= $GOAL) {
        print "Done! House $house_num has $presents presents.\n";
        $done++;
    }
    
    # Dirty hack: after 3024, every successive best house seems to be a multiple of 10.
    # I have no idea why.
    $house_num += 10;
}
