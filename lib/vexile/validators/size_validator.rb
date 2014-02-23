class SizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    real_value = record.__send__(attribute)
    if real_value.respond_to? :size
      if @options[:with] and (real_value.size != @options[:with].to_i)
        record.errors.add attribute, I18n.translate('errors.messages.incorrect_count', :count => @options[:with])
      else
        if @options[:min] and (real_value.size < @options[:min].to_i)
          record.errors.add attribute, I18n.translate('errors.messages.too_few', :count => @options[:min])
        end
        if @options[:max] and (real_value.size > @options[:max].to_i)
          record.errors.add attribute, I18n.translate('errors.messages.too_many', :count => @options[:max])
        end
      end
    else
      if (@options[:with] and (@options[:with].to_i != 0)) || @options[:min]
        record.errors.add attribute, I18n.translate('errors.messages.uncountable')
      end
    end
  end
end