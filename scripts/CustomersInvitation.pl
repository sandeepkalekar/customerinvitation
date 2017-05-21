use CustomersInvitation;
#Driver script to invoke the subroutine invite_within_kms

$filepath = "gistfile1.txt";
my @customers = parse($filepath);
my $invited_customers = invite_within_kms(\@customers, 100);
&output($invited_customers);

