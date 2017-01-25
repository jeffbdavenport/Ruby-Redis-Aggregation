# Rake Helper methods
class RakeHelper
  LOC = LOC.en.rake
  INFO = <<"EOF".freeze
In all tasks, aggregated files will be added to a list,
so that they will not be downloaded or aggregated twice

Defaults:
  [url]   = #{CONF.download.url}
  [count] = 1

Namespace descriptions:
  aggregate - Reads archive without extracting, always removes aggregated files
  download  - Only download
  extract   - Only extract
  push      - Only aggregate
  removes   - Only remove files
  test      - Run rspec tests

Task descriptions:
  :archive[zip_file] - uses specified [zip_file] - argument required
  :file[xml_file]    - uses specified [xml_file] - argument required
  :xmls              - uses all xml files
  :zips              - uses all zip files
  :all               - uses all xml and zip files

Only aggregate namespace combines multiple tasks
All other tasks have one specific task
EOF

  def self.info
    INFO
  end

  def self.check_params(params, key)
    raise LOC.argument if params[key].nil?
  end

  def self.remove_file(file)
    file = Aggregate::TmpFile.new file: file
    raise format LOC.missing path: file.path unless file.exist?
    file.rm
    puts format LOC.removed path: file.path
  end

  def self.remove_files(array, type, path)
    count = array.count
    array.each(&:rm)
    puts format LOC.removed_files, count: count, type: type, path: path,
                                   plural: ('s' unless count == 1).to_s
  end
end
