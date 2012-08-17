politickin
==========

To populate opensecret data 190 people at a time in rails console (since API limit is 200 calls per day):
array_of_arrays_of_190_congressmen = Congressman.all.each_slice(190).to_a
array_of_arrays_of_190_congressmen[0].each do |congressman|
    congressman.gather_information
end
