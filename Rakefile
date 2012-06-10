require 'bundler'
Bundler.require

task :clean do
  sh "rm *.fragment *.md"
end

task :pygmentize, [:file] => '/usr/local/bin/pygmentize' do |t,args|
  puts "Syntax highlighting #{args.file}"
  doc = Nokogiri::HTML(File.read(args.file))
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  File.open(args.file, 'w'){|f| f << doc.to_s}
end

task :template, [:source,:destination] => 'main.template' do |t,args|
  puts "Creating #{args.destination} from #{args.source}"
  template = File.read('main.template')
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

rule '.md' do |t|
  git_name = t.name.split('.')
  git_name.first.upcase!
  git_name = git_name.join('.')
  sh "git checkout master #{git_name}"
  sh "mv #{git_name} #{t.name}"
end

rule '.fragment' => '.md' do |t|
  sh "github-markup #{t.sources.first} > #{t.name}"
  Rake::Task['pygmentize'].invoke(t.name)
  Rake::Task['pygmentize'].reenable
end

rule '.html' => '.fragment' do |t|
  puts "Creating #{t.name} with template."
  Rake::Task['template'].invoke(t.source, t.name)
  Rake::Task['template'].reenable
end

file 'index.html' => 'readme.html' do
  sh "mv readme.html index.html"
end

task :default => ['index.html', 'hacking.html', 'gem.html', 'getting_started.html', :clean]
