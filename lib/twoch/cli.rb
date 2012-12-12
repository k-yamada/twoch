require 'thor'
require 'twoch/channel'

module Twoch
  class CLI < Thor

    desc "s [WORD1 WORD2]", "serach words"
    def s(*words)
      Channel.new.search(words)
    end

  end
end
