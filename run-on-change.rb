#!/usr/bin/ruby

require 'time'

def timstr
  Time.now.to_datetime.strftime "%H:%M:%S"
end

a=ARGV

do_kill=true
do_abs=false

while true
  case a[0]
  when '--no-kill'
    do_kill=false
    a.shift
  when '--abs'
    do_abs=true
    a.shift
  else
    break
  end
end

if a.size == 1
  n=0
  fn=a[0]
  File.readlines(fn).each do |l|
    if l =~ /\brun-on-change\s/
      if do_abs
        a=$'.gsub('%') { fn }.split
      else
        a=$'.gsub('%') { fn.gsub(/.*\//,'') }.split
      end
      break
    end
    n+=1
    if n > 10
      puts "No run-on-change line found in #{a[0]}"
      exit
    end
  end

  Dir.chdir(File.dirname(fn)) unless do_abs
end

sets=[]
while (i=a.index('--'))
  sets.push(a[0..i-1])
  a=a[i+1..-1]
end
sets.push(a)
sets.map! do |s|
  s.map! {|x| x.sub(/^---/,'--') }
end
puts sets.inspect

files=sets.shift.map {|x| Dir.glob(x) }.flatten
run=sets.pop

stats=[]

pid=nil
start=nil

while sleep 1 do

  if pid
    r=Process.wait pid, Process::WNOHANG
    if r == pid
      s=$?
      pid=nil
      if s.exitstatus == 0
        t=((Time.now.to_f-start)*10).to_i
        w="Run ok (#{t/10}.#{t%10}s)"
      else
        w="Run terminated #{$?.inspect}"
      end
      w+=' ' while w.length < 25
      puts "#{w} [#{timstr}]"
    elsif r
      puts "? wait undone: #{r.inspect}"
    end
  end

  nstat=files.map do |f|
    begin
      s=File::Stat.new(f)
      s=[s.mtime,s.size]
    rescue => e
      s=e.inspect
    end
  end
  if nstat != stats
    if pid
      if do_kill
        puts "Kill #{pid}..."
        Process.kill "INT", pid
        Process.wait pid
        pid=nil
      else
        puts "Not killing #{pid}..."
      end
    end
    stats=nstat
    if sets.all? do |c|
        puts "Build [#{c.join ' '}]..."
        system([c[0],c[0]],*c[1..-1])
      end
      puts '---------------------------------------------------'
      puts "Run [#{run.join ' '}]..."
      pid=Process.spawn([run[0],run[0]],*run[1..-1])
      start=Time.now.to_f
    else
      puts "Failed..."
    end
  end
end
