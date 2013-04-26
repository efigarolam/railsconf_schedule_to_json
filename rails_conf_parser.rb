require 'nokogiri'
require 'open-uri'

html = open("http://www.railsconf.com/2013/talks")
doc = Nokogiri::HTML(html.read)
doc.encoding = 'utf-8'

talks = doc.css('.block .talk')

File.open('output/talks.json', 'w+') do |f|
  iterator = 1
  f.puts("{\n")
  f.puts("\ttalks: [\n")
  talks.each do |talk|
    f.puts("\t{\n")
    f.puts("\t\tid: #{iterator},\n")
    f.puts("\t\ttitle: \"#{talk.at_css('h4').text.gsub(/"/, "'")}\",\n")
    f.puts("\t\tspeaker: \"#{talk.at_css('h6').text.gsub(/"/, "'")}\",\n")
    f.puts("\t\tdescription: \"#{talk.css('p').text.gsub(/"/, "'")}\",\n")
    f.puts("\t},\n")
    iterator += 1
  end
  f.puts("\t]\n")
  f.puts("}")
end

html = open("http://www.railsconf.com/2013/speakers")
doc = Nokogiri::HTML(html.read)
doc.encoding = 'utf-8'

speakers = doc.css('.block .speaker')

File.open('output/speakers.json', 'w+') do |f|
  iterator = 1
  f.puts("{\n")
  f.puts("\tspeakers: [\n")
  speakers.each do |speaker|
    f.puts("\t{\n")
    f.puts("\t\tid: #{iterator},\n")
    f.puts("\t\tname: \"#{speaker.at_css('h4').text.gsub(/"/, "'")}\",\n")
    f.puts("\t\ttalk: \"#{speaker.at_css('h6').text.gsub(/"/, "'")}\",\n")
    f.puts("\t\tbio: \"#{speaker.css('p').text.gsub(/"/, "'")}\",\n")
    f.puts("\t},\n")
    iterator += 1
  end
  f.puts("\t]\n")
  f.puts("}")
end

html = open("http://www.railsconf.com/2013/keynotes")
doc = Nokogiri::HTML(html.read)
doc.encoding = 'utf-8'

keynotes = doc.css('.block .speaker')

File.open('output/keynotes.json', 'w+') do |f|
  iterator = 1
  f.puts("{\n")
  f.puts("\tkeynotes: [\n")
  keynotes.each do |keynote|
    f.puts("\t{\n")
    f.puts("\t\tid: #{iterator},\n")
    f.puts("\t\tspeaker: \"#{keynote.at_css('h4').text.gsub(/"/, "'")}\",\n")
    f.puts("\t\tpicture: \"http://www.railsconf.com#{keynote.at_css('img')["src"]}\",\n")
    f.puts("\t\tbio: \"#{keynote.css('p').text.gsub(/"/, "'")}\",\n")
    f.puts("\t},\n")
    iterator += 1
  end
  f.puts("\t]\n")
  f.puts("}")
end

4.times do |i|
  html = File.open("sources/day#{i+1}.html", 'r+')
  doc = Nokogiri::HTML(html.read)
  doc.encoding = 'utf-8'

  schedule_rows = doc.css('.row')

  File.open("output/schedule#{i+1}.json", 'w+') do |f|
    iterator = 1
    f.puts("{\n")
    f.puts("\tschedule: [\n")
    schedule_rows.each do |schedule_row|
      events = schedule_row.css('.talkgroup .slot')

      f.puts("\t{\n")
      f.puts("\t\tid: #{iterator},\n")
      f.puts("\t\tevent_type: \"#{schedule_row.at_css('.timeslot h3').text.gsub(/"/, "'")}\",\n")
      f.puts("\t\ttime: \"#{schedule_row.at_css('.timeslot p').text.gsub(/"/, "'")}\",\n")
      f.puts("\t\tevents: [\n") 
      
      events.each do |event|
        f.puts("\t\t\t{\n")
        f.puts("\t\t\t\tplace: \"#{event.at_css('h4').text.gsub(/"/, "'")}\",\n") if event.at_css('h4')
        f.puts("\t\t\t\tevent: \"#{event.at_css('h5').text.gsub(/"/, "'")}\",\n") if event.at_css('h5')
        f.puts("\t\t\t\tspeaker: \"#{event.at_css('p').text.gsub(/"/, "'")}\",\n") if event.at_css('p')
        f.puts("\t\t\t},\n")
      end
      f.puts("\t\t],")
      f.puts("\t},\n")
      iterator += 1
    end
    f.puts("\t]\n")
    f.puts("}")
  end
end