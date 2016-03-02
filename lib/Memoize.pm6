
use v6;

unit module Memoize;

# This is called when 'is memoized' is added to a routine that returns a result
multi sub trait_mod:<is>(Routine $r, :$memoized!) is export {
  my %cache;
  # Wrap the routine in a block that..
  $r.wrap(-> $arg {
    # looks up the argument in the cache
    %cache{$arg}:exists
      # On cache hit, returns the routine result
      ?? %cache{$arg}
      # On cache miss, it calls the original routine
      !! (%cache{$arg} = callwith($arg))
    }
  );
}