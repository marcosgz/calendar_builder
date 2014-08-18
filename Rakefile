#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/calendar_builder/**/*_spec.rb"
end


task :default => :spec
task :test => :spec

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -I  extra -r calendar_builder.rb"
end
