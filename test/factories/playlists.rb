Factory.define :playlist do |f|
  f.name "Classical Music"
  f.description "Only the best from the last 10 centuries."
end

Factory.define :rock_n_roll, :parent => :playlist do |f|
  f.name "Rock-n-Roll!"
  f.description "From the Beatles to the Roll the Dice!"
end