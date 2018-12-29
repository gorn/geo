#!/usr/bin/ruby
require './geo/geo.rb'

l1 = Location.new(50.0961844, 14.3565472)  # kancl
l2 = Location.new(50.0958071, 14.3605685)  # čoko
l3 = Location.new(50.0867580, 14.4092038)  # Karlův most
l4 = Location.new(49.1922443, 16.6113382)  # Brno

raise unless l1.distance_to(l2) > 280
raise unless (l1-l2).abs < 300

la = LocationArray.new([l1,l2,l3,l4])
unless ( r = la.near(l1,800).size) == 2
  raise "Wrong number of near points #{r}"
end