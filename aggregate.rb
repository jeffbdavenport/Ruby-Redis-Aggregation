# frozen_string_literal: true
$LOAD_PATH.unshift Dir.pwd
$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')
loc = Locale.new 'locale/'
p loc.en.starting_download
download = Download.new loc.download.url
