use v6;

use Test;
use lib 'lib';

plan 4;

use Memoize;
ok 1, "'use Memoize' worked!";

{
  sub get-slowed-result(Int $n where $_ >= 0) is memoized {
    sleep $n / 50;
    return 1 if $n <= 1;
    return get-slowed-result($n - 1) * $n;
  }

  say sprintf("get-slowed-result(%d) is %d", $_, get-slowed-result($_)) for 0..10;

  ok 1, "'is memoized' worked!";
}

{
  sub get-slowed-result(Int $n where $_ >= 0) is memoized() {
    sleep $n / 50;
    return 1 if $n <= 1;
    return get-slowed-result($n - 1) * $n;
  }
  say sprintf("get-slowed-result(%d) is %d", $_, get-slowed-result($_)) for 0..10;

  ok 1, "'is memoized()' worked!"
}

{
  sub get-slowed-result(Int $n where $_ >= 0)
    is memoized(:cache_size(5), :cache_strategy("LRU"), :debug)
  {
    sleep $n / 50;
    return 1 if $n <= 1;
    return get-slowed-result($n - 1) * $n;
  }
  say sprintf("get-slowed-result(%d) is %d", $_, get-slowed-result($_)) for 0..10;

  ok 1, "'is memoized(...)' worked!";
}
