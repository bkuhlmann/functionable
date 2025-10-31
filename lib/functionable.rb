# frozen_string_literal: true

# Main namespace.
module Functionable
  @mutex = Mutex.new

  def self.extended descendant
    descendant.singleton_class.class_eval do
      def extended(*) = fail NoMethodError, "Module extend is disabled."

      def included(*) = fail NoMethodError, "Module include is disabled."

      def prepended(*) = fail NoMethodError, "Module prepend is disabled."

      def module_function(*) = fail NoMethodError, "Module function behavior is disabled."

      def public(*) = fail NoMethodError, "Public visibility is disabled."

      def protected(*) = fail NoMethodError, "Protected visibility is disabled."

      def private(*) = fail NoMethodError, "Private visibility is disabled, use conceal instead."

      def conceal(*) = private_class_method(*)

      def alias_method to, from
        fail NoMethodError, "Aliasing #{from.inspect} as #{to.inspect} is disabled."
      end

      def class_variable_set(name, ...)
        fail NoMethodError, "Setting class variable #{name.inspect} is disabled."
      end

      def class_variable_get name
        fail NoMethodError, "Getting class variable #{name.inspect} is disabled."
      end

      def const_set(name, ...) = fail NoMethodError, "Setting constant #{name.inspect} is disabled."

      def define_method(name, ...)
        fail NoMethodError, "Defining method #{name.inspect} is disabled."
      end

      def remove_method name
        return super if instance_variable_get :@functionable

        fail NoMethodError, "Removing method #{name.inspect} is disabled."
      end

      def undef_method(name) = fail NoMethodError, "Undefining method #{name.inspect} is disabled."

      def singleton_method_added name, allowed: %i[method_added singleton_method_added].freeze
        return super(name) if allowed.include?(name) || instance_variable_get(:@functionable)

        fail NoMethodError,
             "Avoid defining #{name.inspect} as a class method because the method will be " \
             "automatically converted to a class method for you."
      end

      def method_added name
        unbound = instance_method name

        instance_variable_set :@functionable, true
        remove_method name
        define_singleton_method name, unbound
        instance_variable_set :@functionable, false

        super
      ensure
        instance_variable_set :@functionable, false
      end
    end
  end

  def self.included(*) = fail NoMethodError, "Module include is disabled, use extend instead."

  def self.prepended(*) = fail NoMethodError, "Module prepend is disabled, use extend instead."
end
