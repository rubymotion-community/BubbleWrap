require 'bundler'
Bundler.require

task :clean do
  sh "rm _*.html"
end

task :pygmentize, [:file] => '/usr/local/bin/pygmentize' do |t,args|
  puts "Syntax highlighting #{args.file}"
  doc = Nokogiri::HTML(File.read(args.file))
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  File.open(args.file, 'w'){|f| f << doc.to_s}
end

task :template, [:source,:destination] => 'template.html' do |t,args|
  puts "Creating #{args.destination} from #{args.source}"
  template = File.read('template.html')
  contents = File.read(args.source)
  File.open(args.destination, 'w') do |file|
    content_pos = (template =~ /##CONTENTS##/)
    head = template[0...content_pos]
    tail = template[content_pos+12..-1]
    file.write head + contents + tail
  end
end

file '/usr/local/bin/pygmentize' do
  sh "sudo easy_install pygments"
end

task 'README.md' do
  sh "git checkout master README.md"
end

task 'HACKING.md' do
  sh "git checkout master HACKING.md"
end

task "GEM.md" do
  sh "git checkout master GEM.md"
end

file '_readme.html' => ['README.md'] do
  sh "github-markup README.md > _readme.html"
  Rake::Task['pygmentize'].invoke('_readme.html')
  Rake::Task['pygmentize'].reenable
end

file '_hacking.html' => ['HACKING.md'] do
  sh "github-markup HACKING.md > _hacking.html"
  Rake::Task['pygmentize'].invoke('_hacking.html')
  Rake::Task['pygmentize'].reenable
end

file '_gem.html' => ['GEM.md'] do
  sh "github-markup GEM.md > _gem.html"
  Rake::Task['pygmentize'].invoke('_gem.html')
  Rake::Task['pygmentize'].reenable
end

file 'index.html' => '_readme.html' do
  Rake::Task['template'].invoke('_readme.html', 'index.html')
  Rake::Task['template'].reenable
end

file 'hacking.html' => '_hacking.html' do
  Rake::Task['template'].invoke('_hacking.html', 'hacking.html')
  Rake::Task['template'].reenable
end

file 'gem.html' => '_gem.html' do
  Rake::Task['template'].invoke('_gem.html', 'gem.html')
  Rake::Task['template'].reenable
end

task :default => ['index.html', 'hacking.html', 'gem.html', :clean]
