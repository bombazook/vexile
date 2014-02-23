class RecursiveValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    param_proxy = record.__send__(attribute)
    if param_proxy
      if param_proxy.respond_to? :each
        param_proxy.each do |sub_proxy|
          if !sub_proxy.valid?
            message = I18n.translate('errors.messages.recursively_invalid', :in => sub_proxy, :messages => sub_proxy.errors.messages)
            record.errors.add attribute, message
          end
        end
      else
        if !param_proxy.valid?
          message = I18n.translate('errors.messages.recursively_invalid', :in => param_proxy, :messages => param_proxy.errors.messages)
          record.errors.add attribute, message
        end
      end
    end
  end
end