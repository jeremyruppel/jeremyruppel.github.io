namespace :linkedin do
  desc 'Update the cached copy of the linkedin profile'
  task :update do
    mkdir_p 'tmp'
    sh 'curl http://www.linkedin.com/in/jeremyruppel > tmp/jeremyruppel.html'
  end
end

desc 'Build and deploy the site'
task :deploy => :'linkedin:update' do
  sh 'middleman build'
  sh 'middleman deploy'
end
