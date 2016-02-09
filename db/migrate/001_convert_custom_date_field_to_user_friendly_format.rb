class ConvertCustomDateFieldToUserFriendlyFormat < ActiveRecord::Migration
  def self.up
    cfs = CustomField.where(:field_format => "date", type: "IssueCustomField")
    cfs.each do |cf|
      cf.custom_values.each do |cv|
        if cv.value.present? && cv.value.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
          date = cv.value.to_datetime
          cv.value = date.strftime("%d/%m/%Y %H:%M")
          cv.save
        end
      end
    end
  end

  def self.down
    cfs = CustomField.where(:field_format => "date", type: "IssueCustomField")
    cfs.each do |cf|
      cf.custom_values.each do |cv|
        if cv.value.present? && cv.value.match(/\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}/)
          date = cv.value.to_datetime
          cv.value = date.strftime("%Y-%m-%d %H:%M")
          cv.save
        end
      end
    end
  end
end
