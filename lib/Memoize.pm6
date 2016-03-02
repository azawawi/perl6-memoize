
use v6;

unit module Memoize;

# This is called when 'is memoized' is added to a routine that returns a result
multi sub trait_mod:<is>(Routine $r, :$memoized!) is export {
  my %cache;
  my $options            = $memoized.hash if $memoized ~~ List;
  $options               = $options                 // {};
  my Int $cache_size     = $options<cache_size>     // 1000;
  my Str $cache_strategy = $options<cache_strategy> // "LRU";
  my Bool $debug         = $options<debug>          // False;

  die if $cache_strategy ne "LRU";

  # Wrap the routine in a block that..
  $r.wrap(-> $arg {

    # looks up the argument in the cache
    my $result;
    if %cache{$arg}:exists {
      # On cache hit, returns the routine result
      say sprintf("Cache hit on '%s'!", $arg) if $debug;

      my $o = %cache{$arg};
      $result = $o<result>;
      $o<count>++;

    } else {
      # On cache miss, it calls the original routine
      say sprintf("Cache miss on '%s'!", $arg) if $debug;

      $result = callwith($arg);
      %cache{$arg} = %(
        :result($result),
        :count(0)
      );

      if %cache.elems >= $cache_size {
        # Evict least recent used (LRU) element
        #TODO Eviction should be done if needed in another thread every N seconds
        my @results = %cache.sort( { $^a.value<count> cmp $^b.value<count> } );
        my $lru = @results[0];
        say sprintf("Evicting %s\('%s') used only %d time(s), cache_size=%d ", $r.name, $lru.key, $lru.value<count>, $cache_size) if $debug;
        %cache{$lru.key}:delete;
      }
    }

    $result;
  });
}
