#!/usr/bin/perl
# test script to test subroutines in CustomersInvitation.pm 
use Test::More;
use Test::Exception;
use CustomersInvitation;

#  Test for non existent file
dies_ok{parse("notexistentfile")}, 'expecting to die';

#  Test when single customer present.
$customer = {
    name => "Christina McArdle",
    user_id => 12,
    latitude =>"52.986375",
    longitude =>"-6.043701"
};
my @customer_array = ($customer);
my $invited_customers = find_customers_to_be_invited(\@customer_array,100 );
is($$invited_customers{12},$$customer{'name'});

# Test for customer invited withion 20 km.
$filepath = "gistfile1.txt";
my @customers = parse($filepath);
my $invited_customers1 = invite_within_kms(\@customers, 20);
$customer = {
    name => "Ian Kehoe",
    user_id => 5,
    latitude =>"53.2451022",
    longitude =>"-6.238335"
};
is($$invited_customers1{4}, "Ian Kehoe");

# verify that the number of customers returned is correct
$filepath = "gistfile1.txt";
my $invited_customers1 = invite_within_kms(\@customers, 100);
is(scalar(keys %$invited_customers1), 17);

# Test for distance_calculator 
$distance = distance_calculator("53.3381985", "-6.2592576", "53.2451022", "-6.238335");
is($distance,10.39);
print 123;
