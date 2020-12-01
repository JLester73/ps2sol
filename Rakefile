require 'rake/packagetask'
require 'rake/clean'

ADMIN = 'nwfall20'
SCHOOLS = %w{ 1030 1040 1050 1060 40 1110 1090 620 8000}

STUDENT_SRC = SCHOOLS.collect {|s| s + "-students.csv"}

desc "Runs Courses task"
task :default => [:courses]

desc 'Build all School Sections by Course Number'
task :courses => STUDENT_SRC

rule(/^[0-9]+-students\.csv$/ => [
  proc { |targ| targ.sub(/([0-9]+)-students\.csv/, '\1.csv') }
]) do |t|
  match = t.name.match(/^([0-9]+)/)
  sh "./ps2sol --school #{match[1]} --in #{t.source} --type course --admin #{ADMIN}"
end

desc "Clean out this project for a fresh build"
task :clean do
  rm FileList['*-students.csv','*.log']
end
