package Moxer;
use Moxer::Base 'Mojolicious';

# This method will run once at server start
sub startup ($self) {
   # Router
   my $r = $self->routes;

   # Normal route to controller
   $r->get('/')->to('example#welcome');
}

1;
