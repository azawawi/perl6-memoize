# Memoize
Make subroutines and methods faster by trading space for time

This is a totally-experimental-at-the-moment module to create a subroutine trait
similar to the currently experimental `is cached`.

## Plan

- I think I will begin working on an `is memoized` module
- Next step is a default LRU cache eviction strategy.
- Later I will add a pluggable architecture to cache expiry.
- Determine tunable cache size statistics

## Example

```Perl6
use v6;
use Memoize;

sub get-slowed-result(Int $n where $_ >= 0) is memoized {
  sleep $n / 10;
  return 1 if $n <= 1;
  return get-slowed-result($n - 1) * $n;
}

say sprintf("get-slowed-result(%d) is %d", $_, get-slowed-result($_)) for 0..10;
```

## Memoize vs `is-cached`

- `is-cached` is currently marked as experimental as per a [#perl6 discussion](
http://irclog.perlgeek.de/perl6/2016-02-28#i_12114511).

Here is an example for `is cached` for the sake of completeness:

```Perl6
#!/usr/bin/env perl6

use v6;
use experimental :cached;

sub get-slowed-result(Int $n where $_ >= 0) is cached {
  sleep $n / 10;
  return 1 if $n <= 1;
  return get-slowed-result($n - 1) * $n;
}

say sprintf("get-slowed-result(%d) is %d", $_, get-slowed-result($_)) for 0..10;
```

## Previous Totally Awesome Work and References
- [Add memoize to Perl 6 Most Wanted](https://github.com/perl6/perl6-most-wanted/pull/20)
- [Memoize (CPAN)](https://metacpan.org/pod/Memoize)
- [Memoize::ExpireLRU (CPAN)](https://metacpan.org/pod/Memoize::ExpireLRU)
- [Perl 6 RFC 228 - Add memoize into the standard library](http://perl6.org/archive/rfc/228.html)
- [Design specification for `is cached` subroutine trait](http://design.perl6.org/S06.html#is_cached)
- [Perl 6 documentation for `is cached` subroutine trait](http://doc.perl6.org/routine/is%20cached)
- [Memoization on Wikipedia](https://en.wikipedia.org/wiki/Memoization)
