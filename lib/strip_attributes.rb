require "active_model"

module ActiveModel::Validations::HelperMethods
  # Strips whitespace from model fields and converts blank values to nil.
  def strip_attributes(options = {})
    before_validation do |record|
      attributes = StripAttributes.narrow(record.attributes, options)
      attributes.each do |attr, value|
        if value.respond_to?(:strip)
          record[attr] = (value.blank? && !options[:allow_blank]) ? nil : value.mb_chars.strip.normalize.strip.to_s
        end
      end
    end
  end

  # <b>DEPRECATED:</b> Please use <tt>strip_attributes</tt> (non-bang method)
  # instead.
  def strip_attributes!(options = {})
    warn "[DEPRECATION] `strip_attributes!` is deprecated.  Please use `strip_attributes` (non-bang method) instead."
    strip_attributes(options)
  end
end

module StripAttributes
  # Necessary because Rails has removed the narrowing of attributes using :only
  # and :except on Base#attributes
  def self.narrow(attributes, options)
    if except = options[:except]
      except = Array(except).collect { |attribute| attribute.to_s }
      attributes.except(*except)
    elsif only = options[:only]
      only = Array(only).collect { |attribute| attribute.to_s }
      attributes.slice(*only)
    elsif options.empty? || options[:allow_blank]
      attributes
    else
      raise ArgumentError, "Options does not specify :except, :only, or :allow_blank (#{options.keys.inspect})"
    end
  end
end
