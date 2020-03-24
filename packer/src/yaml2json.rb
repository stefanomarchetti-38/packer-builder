#yaml2json.rb
#this isn't used anymore as we are now creating templates which utilises yaml2json-template.rb
#does some hinky stuff to make packer json template files from more readable yaml files.
#Also smashes a bunch of defaults onto each of the yaml defintions.
# execute as ruby yaml2json.rb definition.yaml definition.json

require 'yaml'
require 'json'

fullary=Array.new()
out=Hash.new()
yaml = File.read ARGV[0]

data = YAML.load yaml

data['target'].each do |targets, value|

    tmpary=Array.new()
    data['target']["#{targets}"].merge!(data['defaults'])

    tmpary.push(data['target']["#{targets}"])
    fullary.push(tmpary)
end

out['post-processors'] = fullary

File.open("#{ARGV[1]}","w") do |f|
    f.write(JSON.pretty_generate(out))
end