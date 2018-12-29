#!/usr/bin/ruby

# postacka metrika na metry = alat*difflat+alon*difflon
$alat = 111194.8500267
$alon = 71413.161362

# represents collection of locations and provides methods for working with such a collection
class LocationArray < Array
  def self.read(filename); raise AbstractError end
  def near(aloc,diameter=50)
    self.select{ |pt| 
      (aloc.lat-diameter/$alat..aloc.lat+diameter/$alat).include?(pt.lat) and
      (aloc.lon-diameter/$alon..aloc.lon+diameter/$alon).include?(pt.lon)
    }
  end
end

class Location
  attr_accessor :lat,:lon
  @@PRAGUE = [50.0961844, 14.3565472]

  # vzdálenost bodů v metrech
  # lineární aproximace distance_bak1 - rozdíl od distance_exact je v ČR menší než desetina promile
  def self.distance(l1, l2)
    l1 = coerce(l1); l2 = coerce(l2)
    return nil if l1.nil? or l2.nil?
    begin
      a = l2.lon-l1.lon; b = l2.lat+l1.lat; c = l2.lat-l1.lat
    # rescue
    #   raise ArgumentError, l1.inspect+', '+l2.inspect
    end
    6371000 * Math.sqrt(a*a*(0.000523782 + (-0.000005340525438000032 + 0.000000013613111728122937 * b) * b) + 0.000304617 * c * c )
  end

  def -(other)
    other = Location.coerce(other)
    return Location.new(self.lat-other.lat,self.lon-other.lon)
  end

  def +(other)
    other = Location.coerce(other)
    return Location.new(self.lat+other.lat,self.lon+other.lon)
  end

  # ppormans distance
  def abs
    Location.distance(self+@@PRAGUE, @@PRAGUE)
  end

  def distance_to(other)
    Location.distance(self,other)
  end

  def inspect
    "<#{lat}, #{lon}>"
  end

## technické metody
  # TODO: intialize a coerce používají obdobnou logiku
  def initialize(alat,alon)
    @lat = alat
    @lon = alon
  end

  # převádí location v různých formátech na Location
  def self.coerce(data)
    case data                   # Location(50.0961, 14.3565)
      when Location then data
      when Hash                 # {lat:50.0961, lon:14.3565}
        lat = data[:lat] || data[:latitude]
        lon = data[:lon] || data[:longitude]
        raise if lat.nil? or lon.nil?
        Location.new(lat,lon)
      when Array                # [50.0961, 14.3565]
        raise if data.size != 2
        Location.new(data[0],data[1])
    end
  end
end
