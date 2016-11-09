#!/usr/bin/ruby

require 'open-uri'
require 'pathname'
require 'uri'
require 'fileutils'

pn = Pathname('./')
pn.children.each { |file|
	next if file.extname() != '.json'
	IO.readlines(file).each { |line|
		urls = URI.extract(line, ['http', 'https'])
		urls.each { |url|
			filePath = File.expand_path('.' + URI(url).path)
			dir = File.dirname(filePath)
			FileUtils.mkdir_p(dir) 
			puts filePath
			IO.copy_stream(open(url), filePath)
		}
	}
}
