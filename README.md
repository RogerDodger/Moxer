Dependencies
============

- Perl 5.22
- PostgreSQL 9.5 (lower may work)

Installation
============

Ensure that you have a postgres user with permissions to create databases.

   $ perl Makefile.PL
   $ createdb moxer
   $ ./script/moxer deploy
