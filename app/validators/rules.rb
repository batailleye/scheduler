class Rules < ActiveModel::Validator

    def validate(record)
        unless is_week?(record)
            record.errors[:end_at] << 'Treat yourself. Take more vacation days'
        end

        unless up_to_4_segs?(record)
            record.errors[:segs] << 'You have more than 4 segments. Please add vacation days to an existing segment'
        end

        unless less_than_allowed?(record)
            record.errors[:allowed] << 'You have selected more vacation days than you have accrued'
        end
    end

    # at least one week
    def is_week?(record)
        return calculate_length(record) >= 7
    end

    # not more than 4 segments
    def up_to_4_segs?(record)
        events = Event.find_all_by_nurse_id(record.nurse_id) # the current one is #4
        if not events
          return true
        else
          return events.length <= 3
        end
    end

     # no more weeks than allowed
     def less_than_allowed?(record)
         num_days_total = record.nurse.num_weeks_off * 7
         num_days_taken = 0
         events = Event.find_all_by_nurse_id(record.nurse_id)
         events.each do |event|
             num_days_taken += calculate_length(event)
         end
         num_days_taken += calculate_length(record)
         return num_days_taken < num_days_total
     end

     def calculate_length (event)
        start_at = event.start_at.to_date
        end_at = event.end_at.to_date
        return days_total = end_at - start_at
    end
end
