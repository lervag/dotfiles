require 'rubygems'
require 'interactive_editor'
require 'irb/completion'
ARGV.concat [ "--readline", "--promt-mode", "simple" ]

# Improve the history log file
module Readline
  module History
    LOG = "#{ENV['HOME']}/.irb-history"

    def self.write_log(line)
      File.open(LOG, 'ab') {|f| f << "#{line}\n"}
    end

    def self.start_session_log
      write_log("# " + "-"*70)
      write_log("# Session start: #{Time.now}")
      write_log("# " + "-"*70)
      at_exit do
        write_log("# " + "-"*70)
        write_log("# Session stop: #{Time.now}")
        write_log("# " + "-"*70)
      end
    end
  end

  alias :old_readline :readline
  def readline(*args)
    ln = old_readline(*args)
    begin
      History.write_log(ln)
    rescue
    end
    ln
  end
end
Readline::History.start_session_log

# vim: ft=ruby
