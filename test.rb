require 'bitcoin'

u = Bitcoin::URI.new
u.decode("test:?&&x=y&z")
m = u.decode_query

p m
p m.end
p m.begin
p m.begin.value
