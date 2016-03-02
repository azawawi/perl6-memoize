#perl6

use v6;

# This is called when 'is memoized' is added to a routine that returns a result
multi sub trait_mod:<is>(Routine $r, :$memoized!) is export {
  my %cache;
  my $cache_size = $memoized<cache_size> || -1;
  my $cache_strategy = $memoized<cache_strategy> || "LRU";

  # Wrap the routine in a block that..
  $r.wrap(-> $arg {
    say sprintf("Got '%s'", $arg);

    #say $memoized.perl;
    #warn "cache_size = $cache_size";
    #warn "cache_size = $cache_strategy";

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
      if %cache.elems == $cache_size {
        say "Cache exceeded $cache_size. Evicting one element";

        #TODO evict LRU
      }

      my $result = callwith($arg);
      %cache{$arg} = %(
        :result($result),
        :count(0)
      );
      
    }

    $result;
  });
}

sub factorial(Int $n where $_ > 0) is memoized{:cache_size(3), :cache_strategy("LRU")} {
  return 1 if $n <= 1;
  return factorial($n - 1) * $n;
}

say factorial($_) for 1..10;

