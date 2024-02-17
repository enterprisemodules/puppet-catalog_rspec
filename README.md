# Create Specs from your existing Puppet Catalog

[![Enterprise Modules](https://raw.githubusercontent.com/enterprisemodules/public_images/master/banner1.jpg)](https://www.enterprisemodules.com)

Writing tests greatly enhances the quality and stability of your code in general. The same also goes for Puppet code. Puppet has a great tool for writing unit tests for Puppet code [rspec-puppet](http://rspec-puppet.com/). 

But writing unit tests is not always easy. Sometimes it is hard to get visualize what your catalog looks like when a certain combination of facts and properties is passed to your code.

This Gem can help you. It allows you to dump the Puppet catalog as `puppet-rspec` code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puppet-catalog_rspec'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install puppet-catalog_rspec
```
## Usage

To use the gem, put the next line in your `spec_helper.rb`:

```
require 'puppet-catalog_rspec'
```

Now we are ready to roll.

## Workflow

There is no one single workflow that works, but this is what we use. In your spec file create the state you want to build the test code for by using the correct facts and params. Then use the next statement in your spec file:

```
it { dump_catalog }
```

This will dump the full current catalog as rspec-code to standard output. Here is an example:

```
it {
  is_expected.to contain_archive('/install/p17572726_1036_Generic.zip')
    .that_requires('File[/opt/oracle/middleware/utils/bsu/cache_dir]')
    .with(
      path:    '/install/p17572726_1036_Generic.zip',
      ensure:  'present',
      cleanup: 'false',
      extract: 'false',
      source:  'puppet:///middleware/p17572726_1036_Generic.zip',
      user:    'oracle',
      group:   'dba',
    )
}

it {
  is_expected.to contain_exec('patch policy for p17572726_1036_Generic.zip')
    .that_requires('Bsu_patch[FCX7]')
    .with(
      command:   "bash -c \"{ echo 'grant codeBase \\\"file:/opt/oracle/middleware/patch_wls1036/patch_jars/-\\\" {'; echo '      permission java.security.AllPermission;'; echo '};'; } >> /opt/oracle/middleware/wlserver/server/lib/weblogic.policy\"",
      unless:    "grep 'file:/opt/oracle/middleware/patch_wls1036/patch_jars/-' /opt/oracle/middleware/wlserver/server/lib/weblogic.policy",
      path:      '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/java/jdk1.7.0_45/bin',
      user:      'oracle',
      group:     'dba',
      logoutput' 'on_failure',
    )
}
```

Alternatively, instead of dumping to standard output, use the following to save the generated rspec:

```
it { rspec_catalog('generated_rspec_catalog.rb') }
```


Now copy and paste the parts that you want to check in your manifest into your rspec-code and voila.
## Development


To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/enterprisemodules/puppet-catalog_rspec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
