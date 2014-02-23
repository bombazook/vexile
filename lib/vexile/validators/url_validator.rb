require "addressable/uri"
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      uri = ::Addressable::URI.parse(value)
      if !uri or !["http","https","ftp", "riak"].include?(uri.scheme)
        raise ::Addressable::URI::InvalidURIError
      end
    rescue ::Addressable::URI::InvalidURIError
      record.errors[attribute] << I18n.translate('errors.messages.invalid_url')
    end
  end
end