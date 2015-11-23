require_dependency 'query'
require_dependency 'issue_query'

class Query
  unless instance_methods.include?(:validate_query_filters_with_datetime_custom_field)
    def validate_query_filters_with_datetime_custom_field
      filters.each_key do |field|
        if values_for(field)
          case type_for(field)
            when :integer
              add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^[+-]?\d+$/) }
            when :float
              add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^[+-]?\d+(\.\d*)?$/) }
            when :date, :date_past
              case operator_for(field)
                when "=", ">=", "<=", "><"
                  add_filter_error(field, :invalid) if values_for(field).detect {|v|

                    ### CUSTOM BEGIN
                    # add new valid date format
                    v.present? && ((!v.match(/\A\d{4}-\d{2}-\d{2}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/) && !v.match(/\A\d{2}\/\d{2}\/\d{4}(T\d{2}((:)?\d{2}){0,2}(Z|\d{2}:?\d{2})?)?\z/)) || parse_date(v).nil?)
                    ### CUSTOM END

                  }
                when ">t-", "<t-", "t-", ">t+", "<t+", "t+", "><t+", "><t-"
                  add_filter_error(field, :invalid) if values_for(field).detect {|v| v.present? && !v.match(/^\d+$/) }
              end
          end
        end

        add_filter_error(field, :blank) unless
            # filter requires one or more values
            (values_for(field) and !values_for(field).first.blank?) or
                # filter doesn't require any value
                ["o", "c", "!*", "*", "t", "ld", "w", "lw", "l2w", "m", "lm", "y"].include? operator_for(field)
      end if filters
    end
    alias_method_chain :validate_query_filters, :datetime_custom_field
  end
end
