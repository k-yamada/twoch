require 'thor'
require 'twoch/channel'

module Twoch
  class CLI < Thor

    desc "bs [WORD1 WORD2]", "board search"
    def bs(*word)
      Channel.search_board(word)
    end

    desc "bl", "board list"
    def bl
      Channel.show_board_list(word)
    end

    desc "ts [WORD1 WORD2]", "thread search"
    def ts(*words)
      Channel.search_thread(words)
    end

    desc "tl <thread_list_url>", "thread list"
    def tl(thread_list_url)
      Channel.show_thread_list(thread_list_url)
    end

    desc "tb <thread_url>", "thread browse"
    def tb(thread_url)
      Channel.show_thread(thread_url)
    end
  end
end
