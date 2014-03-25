require 'bundler/setup'
require 'rake'
require 'rspec/core/rake_task'
require 'foodcritic'
require 'rubocop/rake_task'

task :default => [:test]

RSpec::Core::RakeTask.new(:spec)
FoodCritic::Rake::LintTask.new do |t|
  t.options = {:fail_tags => ['any'], :tags => ['~FC023']}
end

desc "Run all tests"
task :test do
  [ :foodcritic, :spec ].each do |task|
    Rake::Task[task].invoke
  end
end

desc "Run tests kitchen"
task :test_kitchen do
  sh  "kitchen test"
end
