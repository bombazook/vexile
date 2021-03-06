require "vexile/version"
require "active_model"
require "vexile/validators/recursive_validator"
require "vexile/validators/size_validator"
require "vexile/validators/url_validator"
require 'active_support/inflector'
require 'active_support/concern'
require 'i18n'
require 'bzproxies'

I18n.load_path += Dir.glob( File.dirname(__FILE__) + "/locales/*.{rb,yml}" ) 

module Vexile
  class << self
    attr_accessor :klasses
  end

  class VexileProxy < Proxy
    def __setobj__ value
      klass = @options[:owner_class].vexile_const_lookup(@options[:class_name])
      raise "#{@options[:class_name]} is not a vexile class" unless klass
      @target = klass.new
      load_params value
    end
  end

  module DSL

    extend ActiveSupport::Concern

    included do
      attr_reader :__source__
      Vexile.klasses ||= []
      Vexile.klasses << self
      include ActiveModel::Validations

      def load_params hsh
        if hsh.kind_of? Hash
          hsh.each do |key, value|
            if self.respond_to? "#{key}="
              self.__send__("#{key}=", value)
            end
          end
        end
        @__source__ = hsh
      end
    end

    module ClassMethods
      def vexile_const_lookup const
        namespaced = [self, self.parents].flatten.map{|i| [i, const.to_s].join "::"}.push(const.to_s).sort{|a,b| b.length <=> a.length}
        vexile_class = namespaced.detect{|i| Vexile.klasses.map(&:name).include?(i)}
        vexile_class && vexile_class.constantize
      end

      def has_many *attribute_names
        if attribute_names.last.kind_of? Hash
          options = attribute_names.pop
        else
          options = {}
        end
        attribute_names.each do |name|
          klass_name = (options[:class_name] || name.to_s.underscore).singularize.classify
          proxy_accessor name.to_s.underscore, :proxy => [ArrayProxy, VexileProxy], :class_name => klass_name, :owner_class => self
        end
      end
      
      def has_one *attribute_names
        if attribute_names.last.kind_of? Hash
          options = attribute_names.pop
        else
          options = {}
        end
        attribute_names.each do |name|
          class_name = (options[:class_name] || name.to_s.underscore).singularize.classify
          proxy_accessor name.to_s.underscore, :proxy => VexileProxy, :class_name => class_name, :owner_class => self
        end
      end
    end
  end
end


