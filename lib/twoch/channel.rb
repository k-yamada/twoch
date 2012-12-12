require 'thor'
require 'mechanize'
require 'pp'
module Twoch; module Channel
  class << self

    def search(words) #:nodoc:
      @agent.get(make_uri_from_words(words))
      @words = words
      result = ""
      get_search_assistances.each do |assistance|
        result << set_color(assistance, :green) + "\n"
      end
  
      meanings = get_meanings
      get_titles.each_with_index do |title, index|
        result << set_color(title, :yellow) + "\n"
        result << set_color(meanings[index]) + "\n"
      end
      result
    end

    def set_color(str, color)
      Thor::Shell::Color.new.set_color(str, color)
    end

  
    def search_board(words)
      url = "http://www2.2ch.net/bbsmenu.html"
      a = Mechanize.new
      a.get(url)
      boards = []
      a.page.search('a').map do |e|
        if words == [] || match_search_condition?(e.inner_text, words)
          boards << {:title => e.inner_text, :url => e[:href]}
        end
      end

      boards.each_with_index do |board, i|
        puts "#{i} : #{board[:title]}(#{board[:url]})"
      end

      print "input board no >"
      no = STDIN.gets.to_i
      show_thread_list(boards[no][:url])
    end

    def show_thread_list(board_url)
      thread_list_url = board_url + "subback.html"
      a = Mechanize.new
      a.get(thread_list_url)
      threads = []
      a.page.search('a').map do |e|
        /\d+:\s+(.*)$/ =~ e.inner_text
        title = $1
        pp e
        threads << {:title => title, :url => e[:href]}
      end

      threads.each_with_index do |thread, i|
        puts "#{i} : #{thread[:title]}(#{thread[:url]})"
      end

      print "input thread no >"
      no = STDIN.gets.to_i
      thread_url = make_thread_url(board_url, threads[no][:url])
      show_thread(thread_url)
    end

    def make_thread_url(board_url, thread_id)
      m = /http:\/\/.*?\//.match board_url
      board_url.dup.insert(m[0].length, "bbs/read.cgi/") + thread_id
    end

    def show_thread(thread_url)
      puts thread_url
      a = Mechanize.new
      a.get(thread_url)
      comments = []
      a.page.search('dt').map do |dt|
        dttext = dt.inner_text.gsub(/\n/, "")
        puts set_color(dttext, :yellow) 
        dd = dt.next
        puts dd.inner_text
        puts
      end

    end
  
    def match_search_condition?(text, search_words)
      search_words.each do |word|
        return true if text =~ /#{word}/
      end
      false
    end
  
    def make_uri_from_words(words) #:nodoc:
      return BASE_URI + make_query_from_words(words) + CHAR_CODE
    end
  
    def make_query_from_words(words) #:nodoc:
      return words.map { |param| URI.encode(param) }.join('+')
    end
  
    def get_search_assistances #:nodoc:
      assistances = []
      @agent.page.search('div.sas strong').map do |h|
        assistances << h.inner_text.chomp("\t\t\t\t\t\t")
      end
      assistances
    end
  
    def get_titles #:nodoc:
      return @agent.page.search('li span.midashi').map do |midashi|
        inner_text = midashi.inner_text
      end
    end
  
    def get_meanings #:nodoc:
      meanings = Array.new
      @agent.page.search('li div').each do |div|
        lis = div.search('li')
        if lis.size != 0
          meanings << lis.inject('') { |text, li| text + "  " + li.inner_text + "\n" }
        else
          meanings << "  " + div.inner_text
        end
      end
      return meanings
    end

  end
  end
end
