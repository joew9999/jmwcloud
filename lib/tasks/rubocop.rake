begin
  require 'rubocop/rake_task'

  desc 'Run RuboCop on the lib directory'
  RuboCop::RakeTask.new(:rubocop) do |_task|
  end
rescue LoadError # rubocop:disable Lint/HandleExceptions
end
