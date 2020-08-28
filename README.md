## Installation

`gem 'insee_api', github: '9troisquarts/insee_api', :branch => 'master'`

## Configuration
    
This gem searches the following locations for credentials

- `ENV['INSEE_ACCESS_ID']` and `ENV['INSEE_ACCESS_SECRET_KEY']`

## Usage

```
require 'insee_api'
client = InseeApi::Client.new(access_id, secret_key)
```


## Retrieve legal unit informations from the api

```
siren_search = InseeApi::Siren.search(search: { name: "9troisquarts", postcode: "59650", active: true, date: "2020-08-27" })
```

## Build the gem

```
gem build insee_api.gemspec
sudo gem install insee_api-{{version}}.gem
```