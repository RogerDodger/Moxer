package Moxer;
use Moxer::Base 'Mojolicious';

use Mojo::Pg;

# This method will run once at server start
sub startup ($self) {
   $self->moniker('moxer');

   $self->plugin('Moxer::Config');
   $self->plugin('PlainRoutes', { autoname => 1 });

   my $dbc = $self->config('db');

   $self->helper(pg => sub {
      state $pg = Mojo::Pg->new
         ->dsn("dbi:Pg:db=$dbc->{name};host=$dbc->{host};port=$dbc->{port}")
         ->username($dbc->{username})
         ->password($dbc->{password});
   });
}

1;
