#!/usr/bin/perl
package CustomersInvitation;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(parse find_customers_to_be_invited invite_within_kms output distance_calculator);
use Math::Trig;
use JSON qw( decode_json );

$base_latitude="53.3381985";
$base_longitude="-6.2592576";
@base_latitude = $base_latitude ;
@base_longitude = $base_longitude ;

# Subroutine: This subroutine would parse the json file 
# Input: json file path(string)
# Output: List of customers 
sub parse
{
    my $filepath = shift; 
    open FH, $filepath or die "File not found";
    while (<FH>)
    {
        push @customers,decode_json($_); 
    }
    return @customers;
}

# Subroutine: This subroutine would go through the list of customers and find the customers to be invited
# Input: list of customers(array), distance of customer within which invitation to be sent(number)
# Output: List of customers to be invited(array)
sub find_customers_to_be_invited
{
    my $customers = shift ;
    my $invitation_radius_in_km = shift;
    #my @invited_customers ;
    my $invited_customers = {} ;
    foreach $customer (@$customers)
    {
       $distance = distance_calculator(@base_latitude, @base_longitude, $$customer{"latitude"}, $$customer{"longitude"}) ;
       if ($distance <= $invitation_radius_in_km)
       {
            $$invited_customers{$$customer{"user_id"}} = $$customer{"name"};
       }
    }
    return $invited_customers;
}

# Subroutine: This subroutine would invoke find_customers_to_be_invited 
# Input: list of customers(array), distance of customer within which invitation to be sent(number)
# Output: List of customers to be invited(array)
sub invite_within_kms 
{
    my $customers = shift ;
    my $invitation_radius_in_km = shift;
    my $invited_customers = find_customers_to_be_invited($customers, $invitation_radius_in_km);
    return $invited_customers;
}

# Subroutine: This subroutine would display the list of customers to be invited
# Input: list of customers(array)
# Output: 
sub output 
{
    my $invited_customers = shift ;
    foreach $invited_customer (sort {$a <=> $b} keys %$invited_customers)
    {
        print "\n". $invited_customer ,  " " , $$invited_customers{$invited_customer};
    }
}

# Subroutine: This subroutine would take the pair of latitude, longitude and output the distance
# Input: pair of latitude, longitude(number)
# Output: distance(number)
sub distance_calculator
{
    my $latitude_1 = shift;
    my $longitude_1 = shift;
    my $latitude_2 = shift;
    my $longitude_2 = shift;
    $latitude_diff  = ($latitude_1 - $latitude_2) * (pi / 180.0);
    $longitude_diff = ($longitude_1 - $longitude_2) * (pi / 180.0);

    $a = asin($latitude_diff/2)**2 + acos(($latitude_1 * (pi / 180.0))) * acos(($latitude_2 * (pi / 180.0))) * asin($longitude_diff/2) ** 2;
    $c = 2 * tan(sqrt($a), sqrt(1-$a));
 
    my $distance = sprintf "%.2f", ($c * 6371.00);
    return $distance; # 6371.00 is Earth's radius in kms

}
