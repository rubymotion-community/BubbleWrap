# gem install 'github-markdown'
require 'github/markdown'

task 'README.md' do
  sh "git checkout master README.md"
end

file '_readme.html' => 'README.md' do
  File.open('_readme.html', 'w') do |file|
    file.write GitHub::Markdown.render_gfm File.read('README.md')
  end
end

file 'index.html' => [ '_index.html', '_readme.html' ] do
  template = File.read('_index.html')
  contents = File.read('_readme.html')
  File.open('index.html', 'w') do |file|
    file.write template.gsub('##README##', contents)
  end
end

task :default => 'index.html'
