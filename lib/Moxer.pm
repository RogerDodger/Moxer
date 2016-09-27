package Moxer;
use Moxer::Base 'Mojolicious';

use Mojo::Pg;

# This method will run once at server start
sub startup ($self) {
   $self->moniker('moxer');

   $self->plugin('Moxer::Config');
   $self->plugin('PlainRoutes', { autoname => 1 });

   $self->plugin(EPRenderer => {
      name     => 'epm',
      template => {
         tag_start => '{{',
         tag_end   => '}}',
      },
   });

   my $dbc = $self->config('db');

   $self->helper(pg => sub {
      state $pg = Mojo::Pg->new
         ->dsn("dbi:Pg:db=$dbc->{name};host=$dbc->{host};port=$dbc->{port}")
         ->username($dbc->{username})
         ->password($dbc->{password});
   });

   $self->helper(cardurl => sub {
      "//gatherer.wizards.com/Handlers/Image.ashx?multiverseid=$_[1]&type=card";
   });

   $self->helper(db => sub { $self->pg->db });
}

1;
