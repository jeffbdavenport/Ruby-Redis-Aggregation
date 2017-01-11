namespace :aggregate do
  desc 'Download, Extract, and insert into Redis, does not include file removal'
  task full: [:build_deps] do
  end
end
