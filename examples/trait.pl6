#!/usr/bin/env perl6

use v6;

# This is called when 'is memoized' is added to a routine that returns a result
multi sub trait_mod:<is>(Routine $r, :$memoized!) is export {
  my %cache;
  my Int $cache_size = $memoized<cache_size> // -1;
  my Str $cache_strategy = $memoized<cache_strategy> // "LRU";
  my Bool $debug = $memoized<debug> // False;

  # Wrap the routine in a block that..
  $r.wrap(-> $arg {

    # looks up the argument in the cache
    my $result;
    if %cache{$arg}:exists {
      # On cache hit, returns the routine result
      my $o = %cache{$arg};
      $result = $o<result>;
      $o<count>++;
    } else {
      # On cache miss, it calls the original routine
      say sprintf("Cache miss on '%s'!", $arg);

      $result = callwith($arg);
      %cache{$arg} = %(
        :result($result),
        :count(0)
      );

      if %cache.elems >= $cache_size {
        # Evict least recent used (LRU) element
        my @values = %cache.sort( { $^a.value<count> cmp $^b.value<count> } );
        my $lru = @values[0];
        say sprintf("Evicting %s\('%s') used only %d time(s), cache_size=%d ", $r.name, $lru.key, $lru.value<count>, $cache_size) if $debug;
        %cache{$lru.key}:delete;
      }
    }

    $result;
  });
}

sub factorial(Int $n where $_ > 0) is memoized{:cache_size(1000), :cache_strategy("LRU"), :debug} {
  return 1 if $n <= 1;
  return factorial($n - 1) * $n;
}

say (sprintf("factorial of %s is %s\n", $_, factorial($_))) for 1..1000;
