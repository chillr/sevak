require 'rails'

module Sevak
  class Railtie < Rails::Railtie
    railtie_name :sevak

    rake_tasks do
      path = File.join(File.expand_path('../..', __dir__), 'tasks/**/*.rake')
      tasks = FileList[path]
      tasks.each { |task| load(task) }
    end
  end
end
