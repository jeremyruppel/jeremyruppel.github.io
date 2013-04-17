namespace :linkedin do
  desc 'Update the cached copy of the linkedin profile'
  task :update do
    mkdir_p 'tmp'
    sh 'curl http://www.linkedin.com/in/jeremyruppel > tmp/jeremyruppel.html'
  end
end
