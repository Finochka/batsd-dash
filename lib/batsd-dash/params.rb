# helpers for processing params and validating input
module BatsdDash
  module ParamsHelper
    def parse_statistics
      Hash.new { |hash,key| hash[key] = [] }.tap do |stats|
        %w[ counters gauges timers ].each do |datatype|
          list = params[datatype]

          list = [list] unless Array === list
          list.reject! { |m| m.nil? || m.empty? }

					stats[datatype] = list unless list.empty?
        end
      end
    end

    def parse_time_range
      start, stop = params[:start], params[:stop]

      if start.nil? && stop.nil?
        now = Time.now.to_i

        # 1 hr range
        # TODO make this setting?
        [ now - 1800, now ]

      else
        [start.to_i, stop.to_i].tap do |range|
          if range[0] <= 0 || range[1] <= 0 || range[0] >= range[1]
            return nil
          end
        end
      end
    end
  end
end
