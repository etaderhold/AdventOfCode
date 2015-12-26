#!/usr/bin/perl

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

my $PRESENTS_PER_ELF = 10;
my $GOAL = 36000000;

my $house_num = 0;
while (!$done) {
    # Find prime factorization of house number
    my $presents = $PRESENTS_PER_ELF;

    my $remaining_factor = $house_num;
    foreach my $prime (@primes) {
        last if $prime > $remaining_factor;
        my $divisions = 0;

        while ($remaining_factor % $prime == 0) {
            $remaining_factor /= $prime;
            $divisions++;
        }

        if ($divisions) {
            my $sum = 0;
            foreach my $i (0..$divisions) {
                $sum += $prime ** $i;
            }
            $presents *= $sum;
        }
    }

    if ($remaining_factor > 1) {
        print "Calculate more primes. House $house_num has $remaining_factor left over!\n";
    }

    if ($presents > $max_presents) {
        $max_presents = $presents;
        print "House $house_num has $presents presents.\n";
    }
    
    if ($presents > $GOAL) {
        print "Done! House $house_num has $presents presents.\n";
        $done++;
    }
    
    # Dirty hack: after 3024, every successive best house seems to be a multiple of 10.
    # I have no idea why.
    $house_num += 10;
}
