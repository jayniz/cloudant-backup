# CloudantBackup

Easily backup a cloudant db using replication. This gem wraps
the two http requests you need to make to backup a cloudant db
(1. create a new db, 2. backup/replicate your main db to it)

## Installation

Add this line to your application's Gemfile:

    gem 'cloudant_backup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudant_backup

## Usage

Most simple case: replicate your production db to one automatically
named backup db on cloudant:

```ruby
  cb          = CloudantBackup.new
  cb.user     = 'username'
  cb.password = 'password'
  cb.source   = 'my_production_db'

  cb.replicate  # Backup my_production_db to my_production_db_backup_2013_09_10
```

Create only one db per month (you can still update it daily):

```ruby
  cb = CloudantBackup.new
  [...]
  cb.date_pattern = '%Y_%m'  # Any strftime string works

  cb.replicate
```

Choose the target db name yourself:

```ruby
  cb = CloudantBackup.new
  [...]
  cb.target = 'custom_target_db_name'

  cb.replicate
```

Use another user instead of your cloudant main user:

```ruby
  cb = CloudantBackup.new
  [...]
  cb.user = 'generated_api_key'
  cb.cloudant_host = 'mainuser'

  cb.replicate
```

Don't use cloudant at all, just copy one couchdb over to another:

```ruby
  cb = CloudantBackup.new
  [...]
  cb.host = 'my-couchdb-instance.com'

  cb.replicate
```

Thank you for your business!

![](https://dl.dropboxusercontent.com/u/1953503/gifs/5eNxg9u.jpg)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
