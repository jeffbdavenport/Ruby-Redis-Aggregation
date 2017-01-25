namespace :push do
  task all: [@archive_path, @xml_path, 'extract:prepare'] do |_, params|
  end
end
