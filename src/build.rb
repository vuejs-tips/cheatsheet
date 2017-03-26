#!/usr/bin/env ruby

require 'nokogiri'
require "rexml/document"
require 'erb'

# can't download directly, have to open https://vuejs.org/v2/api/,
# and copy <ul class="menu-root"> to downloaded-menu.html
doc = Nokogiri::HTML open(__dir__ + '/downloaded-menu.html')
root = doc.at_css('.menu-root')

root.css('li:last-child').last.remove # remove the last two li
root.css('li:last-child').last.remove

modifiers = IO.read(__dir__ + '/modifiers.xml') # extra panels

html = root.to_s
html = html.gsub(/<\/li>\s+<ul/m, "\n<ul") # remove closing li
           .gsub(/<\/ul>/, "</ul></li>") # and move after </ul>
           .gsub('Options / ', '<small>Options</small> ')
           .gsub('Instance Methods / ', '<small>Methods</small> ')
           .gsub('Instance ', '<small>Instance</small> ')
           .gsub('Global ', '<small>Global</small> ')
           .gsub('Built-In ', '<small>Built-In</small> ')
           .gsub('Special ', '<small>html</small> ')
           .gsub('>Directives<', '><small>html</small> Directives<')
           .gsub(/>(renderError|model|productionTip|performance|provide \/ inject|vm\.\$props)</, '>\\1 <var>2.2</var><')
           .gsub(/>(v-else-if|vm\.\$scopedSlots)</, '>\\1 <var>2.1</var><')
           .gsub(/<\/ul><\/li>\Z/m, modifiers) # append modifiers

style = File.read(__dir__ + '/style.css')
script = File.read(__dir__ + '/script.js')
body = ''
REXML::Document.new(html).write(body, 2)

IO.write __dir__ + '/../index.html', ERB.new(File.read(__dir__ + '/template.erb')).result
