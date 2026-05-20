#!/usr/bin/ruby

require 'yaml'
require 'base64'

def dumpcerts(s, file)
  certs = s.scan(
    /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m
  )

  if certs.empty?
    d=YAML.load(s)
    s=Base64.decode64(d['data']['tls.crt'])
    certs = s.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m
    )
    if certs.empty?
      warn "No certificates found in #{file}"
      return
    end
  end

  certs.each_with_index do |cert, i|
    puts "\n#{'=' * 80}"
    puts "Certificate #{i + 1} of #{certs.length}"
    puts "#{'=' * 80}"

    IO.popen(["openssl", "x509", "-text", "-noout"], "w") do |io|
      io.write(cert)
      io.close_write
    end

    unless $?.success?
      warn "openssl failed for certificate #{i + 1} with exit #{$?.exitstatus}"
    end
  end
end

any=false
ARGV.each do |a|
  case a
  when /\A-/
    warn "bad opt #{a.inspect}"
  else
    any=true
    dumpcerts(File.read(a),a)
  end
end

unless any
  dumpcerts(STDIN.read, '-')
end
