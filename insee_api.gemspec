require_relative "lib/insee_api/version"

Gem::Specification.new do |s|
  s.name = "insee_api"
  s.version = InseeApi::VERSION
  s.date = "2024-07-05"
  s.author = "9troisquarts"
  s.add_runtime_dependency 'rest-client', '>= 2.0.2'
  s.add_runtime_dependency 'json', '>= 2.1.0'
  s.summary = "Ruby gem allowing to fetch company informations from insee api V3"
  s.files = [
    "lib/insee_api.rb",
    "lib/insee_api/client.rb",
    "lib/insee_api/siren.rb",
    "lib/insee_api/legal_unit.rb"
  ]
  s.require_paths = ["lib"]
end
