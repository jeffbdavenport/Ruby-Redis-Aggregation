namespace :remove do
  desc 'Remove all files'
  task all: [:remove_zips, :remove_xmls]
end
