module Sevak
  module Autoscale
    Signal.trap("TERM") { Process.waitall; exit }
    Signal.trap("INT") { Process.waitall; exit  }

    def pids
      @pids ||= []
    end

    def save_pid
      @pids
    end

    def stop
      exit
    end

    def fork_process
      print "Forking process ..."

      begin
        pid = fork do
          trap('HUP') { stop }
          trap('TERM') { stop }
          trap('INT') { stop }

          Consumer.new.start_worker
        end

        pids.push(pid)

        print "\b\b\b#{pid}. Process count #{pids.size} \n"
      rescue => e
        puts "Unable to fork process #{e.message}"
      end
    end

    def kill_all
      pids.each do |pid|
        kill_process(pid)
      end
      pids = []
    end

    def kill_process(pid)
      return if pid.nil?
      print "Killing #{pid} ..."

      begin
        Process.kill("HUP", pid)
        Process.wait
      rescue => e
        puts "Unable to kill process #{e.message}"
      end

      print "\b\b\bDone \n"
    end

    def process_count
      pids.size
    end

    def cleanup
      kill_all
      exit
    end

    def start_master_worker
      loop do
        avg_load = [:low, :medium, :high][rand(0..2)]

        if (avg_load == :high) && (pids.size < config.max_process_limit)
          pid = fork_process
        elsif (avg_load == :low) && (process_count > config.min_process_limit)
          pid = pids.shift
          kill_process(pid) if pid
        else
        end
        sleep 5
      end
    rescue => e
      cleanup
    ensure
      cleanup
    end
  end
end
