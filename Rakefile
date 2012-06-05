require 'bundler'
Bundler.require

file '/usr/local/bin/pygmentize' do
  sh "sudo easy_install pygments"
end

task 'README.md' do
  sh "git checkout master README.md"
end

file '_readme.html' => ['README.md', '/usr/local/bin/pygmentize' ] do
  sh "github-markup README.md > _readme.html"
  doc = Nokogiri::HTML(File.read('_readme.html'))
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  File.write('_readme.html', doc.to_s)
end

file 'index.html' => [ 'template.html', '_readme.html' ] do
  template = File.read('template.html')
  contents = File.read('_readme.html')
  File.open('index.html', 'w') do |file|
    readme_pos = (template =~ /##README##/)
    head = template[0...readme_pos]
    tail = template[readme_pos+10..-1]
    file.write head + contents + tail
  end
end

task :default => 'index.html'
