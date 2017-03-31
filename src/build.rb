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

extras = IO.read(__dir__ + '/extras.xml') # extra panels

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
           .gsub(/<\/ul><\/li>\Z/m, extras) # append extras

doc = Nokogiri::HTML html
doc.at_css('.menu-root > li:nth-child(13)').add_next_sibling("
<li class='directives hooks'><a>Directives <small>Hooks</small></a>
  <ul>
    <li><a href='https://vuejs.org/v2/guide/custom-directive.html#Hook-Functions'>bind</a></li>
    <li><a href='https://vuejs.org/v2/guide/custom-directive.html#Hook-Functions'>inserted</a></li>
    <li><a href='https://vuejs.org/v2/guide/custom-directive.html#Hook-Functions'>update</a></li>
    <li><a href='https://vuejs.org/v2/guide/custom-directive.html#Hook-Functions'>componentUpdated</a></li>
    <li><a href='https://vuejs.org/v2/guide/custom-directive.html#Hook-Functions'>unbind</a></li>
  </ul>
</li>
")
# move "instance properties" after "Lifecycle Methods"
doc.at_css('.menu-root > li:nth-child(12)').add_next_sibling(doc.at_css('.menu-root > li:nth-child(9)').remove)
doc.at_css('.menu-root > li:nth-child(2)').add_next_sibling(doc.at_css('.menu-root > li:nth-child(5)').remove)
html = doc.to_s

style = File.read(__dir__ + '/style.css')
script = File.read(__dir__ + '/script.js')
body = ''
REXML::Document.new(html).write(body, 2)

IO.write __dir__ + '/../index.html', ERB.new(File.read(__dir__ + '/template.erb')).result
