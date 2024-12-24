require_dependency 'query'
require_dependency 'issue_query'

module RedmineDatetimeCustomField::QueryPatch
end

class Query

  def validate_query_filters
    filters.each_key do |field|
      if values_for(field)
        case type_for(field)
        when :integer
          add_filter_error(field, :invalid) if values_for(field).detect { |v| v.present? && !/\A[+-]?\d+(,[+-]?\d+)*\z/.match?(v) }
        when :float
          add_filter_error(field, :invalid) if values_for(field).detect { |v| v.present? && !/\A[+-]?\d+(\.\d*)?\z/.match?(v) }
        when :date, :date_past
          case operator_for(field)
          when "=", ">=", "<=", "><"
            add_filter_error(field, :invalid) if values_for(field).detect { |v|
              ### CUSTOM BEGIN
              # add new valid date format
              v.present? &&
                (!/\A\d{4}-\d{2}-\d{2}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/.match?(v) &&
                  !v.match(/\A\d{2}\/\d{2}\/\d{4}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/)) ||
                parse_date(v).nil?
              ### CUSTOM END
            }
          when ">t-", "<t-", "t-", ">t+", "<t+", "t+", "><t+", "><t-"
            add_filter_error(field, :invalid) if values_for(field).detect { |v| v.present? && !/^\d+$/.match?(v) }
          end
        end
      end

      add_filter_error(field, :blank) unless
        # filter requires one or more values
        (values_for(field) and !values_for(field).first.blank?) or
          # filter doesn't require any value
          ["o", "c", "!*", "*", "nd", "t", "ld", "nw", "w", "lw", "l2w", "nm", "m", "lm", "y", "*o", "!o"].include? operator_for(field)
    end if filters
  end

  def quoted_time(time, is_custom_filter)
    if is_custom_filter
      # Custom field values are stored as strings in the DB
      # using this format that does not depend on DB date representation
      if Rails.env.test?
        time.strftime("%Y-%m-%d %H:%M:%S")
      else
        time.strftime("%d/%m/%Y %H:%M") # Custom format
      end
    else
      self.class.connection.quoted_date(time)
    end
  end

  # Returns a SQL clause for a date or datetime field.
  def date_clause(table, field, from, to, is_custom_filter)
    s = []
    if from
      if from.is_a?(Date)
        from = date_for_user_time_zone(from.year, from.month, from.day).yesterday.end_of_day
      else
        from = from - 1 # second
      end
      if ActiveRecord.default_timezone == :utc
        from = from.utc
      end

      ### Patch Start
      if is_custom_filter && self.class.connection.adapter_name.downcase.to_sym == :postgresql && !Rails.env.test?
        s << ("to_timestamp(#{table}.#{field},'DD/MM/YYYY HH24:MI') > to_timestamp('%s','DD/MM/YYYY HH24:MI')" % [quoted_time(from, is_custom_filter)])
      else
        if Rails.env.test? || table.classify.constantize.columns_hash[field].type == :date || table.classify.constantize.columns_hash[field].type == :datetime
          s << ("#{table}.#{field} > '%s'" % [quoted_time(from, is_custom_filter)])
        else
          s << ("STR_TO_DATE(#{table}.#{field},'%d/%m/%Y') > STR_TO_DATE('" + quoted_time(from, is_custom_filter) + "','%d/%m/%Y')")
        end
      end
      ### Patch End

    end
    if to
      if to.is_a?(Date)
        to = date_for_user_time_zone(to.year, to.month, to.day).end_of_day
      end
      if ActiveRecord.default_timezone == :utc
        to = to.utc
      end

      ### Patch Start
      if is_custom_filter && self.class.connection.adapter_name.downcase.to_sym == :postgresql && !Rails.env.test?
        s << ("to_timestamp(#{table}.#{field},'DD/MM/YYYY HH24:MI') <= to_timestamp('%s','DD/MM/YYYY HH24:MI')" % [quoted_time(to, is_custom_filter)])
      else
        if Rails.env.test? || table.classify.constantize.columns_hash[field].type == :date || table.classify.constantize.columns_hash[field].type == :datetime
          s << ("#{table}.#{field} <= '%s'" % [quoted_time(to, is_custom_filter)])
        else
          s << ("STR_TO_DATE(#{table}.#{field},'%d/%m/%Y') <= STR_TO_DATE('" + quoted_time(to, is_custom_filter) + "','%d/%m/%Y')")
        end
      end
      ### Patch End

    end
    s.join(' AND ')
  end
end
