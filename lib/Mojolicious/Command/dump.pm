package Mojolicious::Command::dump;

use Moxer::Base 'Mojolicious::Command';

sub run ($self) {
   my $conf = $self->app->config;
   qx{
      pg_dump -a -t sets -t cards -t prints -t rulings $conf{db}{name} > $conf{cdfn}
   }
}

1;
