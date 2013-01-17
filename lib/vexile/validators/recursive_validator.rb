class RecursiveValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    param_proxy = record.__send__(attribute)
    if param_proxy
      if param_proxy.respond_to? :each
        param_proxy.each do |sub_proxy|
          record.errors.add attribute, "is invalid in #{sub_proxy} : #{sub_proxy.errors.messages}" if !sub_proxy.valid?
        end
      else
        record.errors.add attribute, "is invalid in #{param_proxy} : #{param_proxy.errors.messages}" if !param_proxy.valid?
      end
    end
  end
end