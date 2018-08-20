module Sevak
  module Autoscale
    Signal.trap('TERM') { Process.waitall; exit }
    Signal.trap('INT') { Process.waitall; exit  }

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
      begin
        pid = fork do
          trap('HUP') { stop }
          trap('TERM') { stop }
          trap('INT') { stop }

          self.class.new.start_worker
        end

        pids.push(pid)

      rescue => e
        log("Unable to fork process #{e.message}")
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

      begin
        Process.kill("HUP", pid)
        Process.wait
      rescue => e
        log("Unable to kill process #{e.message}")
      end
    end

    def process_count
      pids.size
    end

    def cleanup
      kill_all
      exit
    end

    def calculate_average_load
      ratio = begin
        message_count / process_count
      rescue ZeroDivisionError => e
        10
      end

      if ratio >= 10
        :high
      elsif ratio <= 2
        :low
      else
        :medium
      end
    end

    def start_master_worker
      fork_process

      loop do
        avg_load = calculate_average_load

        if (avg_load == :high) && (pids.size < config.max_process_limit)
          fork_process
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
