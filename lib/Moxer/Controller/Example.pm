package Moxer::Controller::Example;
use Moxer::Base 'Moxer::Controller';

# This action will render a template
sub welcome ($c) {
   my $foo = [1, 2, 3];
   $c->log->info(join ', ', $foo->@*);

   # Render template "example/welcome.html.ep" with message
   $c->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

1;
