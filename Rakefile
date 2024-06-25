Rake::FileUtilsExt.verbose_flag = false

task :run do
  sh 'ruby lib/olgerd.rb'
end

namespace :heilsubrunnr do
  name = 'heilsubrunnr'

  task :config do
    sh "ruby scripts/setup_#{name}.rb"
    Rake::Task["#{name}:validate"].invoke
  end

  task :run do
    Rake::Task["#{name}:validate"].invoke
    sh "haproxy -f #{name}/#{name}.cfg -db"
  end

  task :validate do
    sh "haproxy -c -f #{name}/#{name}.cfg"
  end
end
