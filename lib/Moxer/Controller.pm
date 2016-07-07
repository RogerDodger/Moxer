package Moxer::Controller;
use Moxer::Base 'Mojolicious::Controller';

sub log ($self) {
   $self->app->log;
}

1;
