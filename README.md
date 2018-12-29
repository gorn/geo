# geo

Geo library for Ruby for working with maps, locations, distances and more. 

## state of the project
Currently I am trying to determine most practical naming and syntax for objects. Please let me know in issues of a message if you have suggestions on that

## naming

`Location` object represents a point on Earth. I have also considered naming it `Point` or `Position`

````
p1 = Point(55.1234,14,748923)
p2 = Point(55.432,14,543)

(p1-p2).to_m          # => distance in meters
Geo.distance(p1,p2)   # => distance in meters
