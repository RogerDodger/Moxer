#/usr/bin/env perl

use 5.022;
use Getopt::Long;

GetOptions(\my %opt, 'devel|development');

my @production = qw/
	Mojolicious
	Mojolicious::Plugin::PlainRoutes
	Mojo::Pg
	IO::Socket::SSL
	Bytes::Random::Secure
	Crypt::Eksblowfish::Bcrypt
	IO::Prompt
	LWP::UserAgent::ProgressBar
/;

my @development = qw/
	Text::Lorem::More
/;

if (eval { require App::cpanminus; 1; }) {
	*install = sub { system 'cpanm', @_ };
}
else {
	require CPAN;
	CPAN->import;
}

say "Installing production dependencies...";
install(@production);

if ($opt{devel}) {
	say "Installing development dependencies...";
	install(@development);
}
