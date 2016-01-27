desc "Install all dependencies"
task :bootstrap do
  if system("which bundle")
    sh "bundle install"
    # sh "git submodule update --init"
  else
    $stderr.puts "\033[0;31m[!] Please install the bundler gem manually: $ [sudo] gem install bundler\e[0m"
    exit 1
  end
end

begin
  require "bundler/gem_tasks"

  desc "Generate documentation"
  task :doc do
    sh "yard doc"
  end

  desc "Run rubocop"
  task :rubocop do
    sh "rubocop"
  end

  require "rake/testtask"
  Rake::TestTask.new(:test) do |t|
    t.options = "--verbose"
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/**/*_test.rb"]
  end

  task :default => [:test, :rubocop]

rescue LoadError
  $stderr.puts "\033[0;33m[!] Disabling rake tasks because the environment couldn’t be loaded. Be sure to run `rake " \
               "bootstrap` first.\e[0m"
end

