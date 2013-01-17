class SizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    real_value = record.__send__(attribute)
    if real_value.respond_to? :size
      if @options[:with] and (real_value.size != @options[:with].to_i)
        record.errors.add attribute, "should have #{@options[:with]} element(s)"
      else
        if @options[:min] and (real_value.size < @options[:min].to_i)
          record.errors.add attribute, "should be bigger than #{@options[:min]} element(s)"
        end
        if @options[:max] and (real_value.size > @options[:max].to_i)
          record.errors.add attribute, "should be shorter than #{@options[:max]} element(s)"
        end
      end
    else
      if (@options[:with] and (@options[:with].to_i != 0)) || @options[:min]
        record.errors.add attribute, "is blank or could not be counted"
      end
    end
  end
end