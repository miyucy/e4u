require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "e4u"
    gem.summary = %Q{Emoji4Unicode for Ruby}
    gem.description = %Q{Emoji4Unicode for Ruby}
    gem.email = "fistfvck@gmail.com"
    gem.homepage = "http://github.com/fistfvck/e4u"
    gem.authors = ["fistfvck"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "e4u #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Download xml"
task :data => [:data_directories,
               'data/emoji4unicode.xml',
               'data/docomo/carrier_data.xml',
               'data/kddi/carrier_data.xml',
               'data/softbank/carrier_data.xml']

task :data_directories do
  FileUtils.mkdir_p 'data'
  FileUtils.mkdir_p 'data/docomo'
  FileUtils.mkdir_p 'data/kddi'
  FileUtils.mkdir_p 'data/softbank'
end

file 'data/emoji4unicode.xml' do
  require 'open-uri'
  File.open('data/emoji4unicode.xml','wb') do |out|
    out.print open('http://emoji4unicode.googlecode.com/svn/trunk/data/emoji4unicode.xml').read
  end
end

file 'data/docomo/carrier_data.xml' do
  require 'open-uri'
  File.open('data/docomo/carrier_data.xml','wb') do |out|
    out.print open('http://emoji4unicode.googlecode.com/svn/trunk/data/docomo/carrier_data.xml').read
  end
end

file 'data/kddi/carrier_data.xml' do
  require 'open-uri'
  File.open('data/kddi/carrier_data.xml','wb') do |out|
    out.print open('http://emoji4unicode.googlecode.com/svn/trunk/data/kddi/carrier_data.xml').read
  end
end

file 'data/softbank/carrier_data.xml' do
  require 'open-uri'
  File.open('data/softbank/carrier_data.xml','wb') do |out|
    out.print open('http://emoji4unicode.googlecode.com/svn/trunk/data/softbank/carrier_data.xml').read
  end
end
