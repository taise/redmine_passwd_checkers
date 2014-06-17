ENV['RAILS_ENV'] ||= 'test'

begin
  require 'rubygems'
rescue LoadError
end

begin
  require File.expand_path('../../../../spec/spec_helper', __FILE__)
  require File.expand_path('../../app/models/last_passwd', __FILE__)
rescue LoadError => error
  puts <<-EOS

    You need to install rspec in your Redmine project.
    Please execute the following code:

      gem install rspec-rails
      script/generate rspec

  EOS
  raise error
end

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

fixtures_path = File.expand_path('../../spec/fixtures', __FILE__)
ActiveRecord::Fixtures.create_fixtures(fixtures_path, 'users')
require File.join(File.dirname(__FILE__), '..', 'init.rb')
