# time-series

This library provides a basic data structure that can represent time series data. It is originally designed for the representation of stock market data, but it is suitable (and extensible) for other purposes.

It keeps data points in a Hash and requires Ruby version >= 1.9.2, as it turns out in Ruby 1.9, a Hash is also a [doubly-circular linked list](http://www.igvita.com/2009/02/04/ruby-19-internals-ordered-hash/).
