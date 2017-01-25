namespace :download do
  desc '[count] archives'
  task :count, [:count, :url] => [:prepare] do |_, params|
    params.with_defaults count: 1
    params[:count].to_i.times do
      @page.downloaded = 0
      @page.download_one
    end
    puts 'Complete'
  end
end
