#!/usr/bin/ruby

a=ARGV
sets=[]
while (i=a.index('--'))
  sets.push(a[0..i-1])
  a=a[i+1..-1]
end
sets.push(a)
puts sets.inspect

files=sets.shift
run=sets.pop

stats=[]

pid=nil

while sleep 1 do

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
      puts "Kill #{pid}..."
      Process.kill "INT", pid
      Process.wait pid
      pid=nil
    end
    stats=nstat
    if sets.all? do |c|
        puts "Build [#{c.join ' '}]..."
        system([c[0],c[0]],*c[1..-1])
      end
      puts "Run [#{run.join ' '}]..."
      pid=Process.spawn([run[0],run[0]],*run[1..-1])
    else
      puts "Failed..."
    end
  end
end
