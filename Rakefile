require 'bundler/gem_tasks'
require 'sevak'

# run tests by running command `rake test`
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.verbose = true
  t.test_files = FileList['test/**/*_spec.rb']
  t.warning = false
end

# Load all rake tasks in the tasks folder

tasks = FileList["tasks/**/*.rake"]
tasks.each { |task| load(task) }
