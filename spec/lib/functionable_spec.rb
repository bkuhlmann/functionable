# frozen_string_literal: true

require "spec_helper"

RSpec.describe Functionable do
  subject(:functionable) { described_class }

  describe ".extended" do
    let(:namespace) { Module.new.extend described_class }

    it "fails when extending itself" do
      expectation = proc { Module.new.extend namespace }
      expect(&expectation).to raise_error(NoMethodError, "Module extend is disabled.")
    end

    it "fails when including itself" do
      expectation = proc { Module.new.include namespace }
      expect(&expectation).to raise_error(NoMethodError, "Module include is disabled.")
    end

    it "fails when prepending itself" do
      expectation = proc { Module.new.prepend namespace }
      expect(&expectation).to raise_error(NoMethodError, "Module prepend is disabled.")
    end

    it "fails when specifying module function behavior" do
      expectation = proc do
        Module.new do
          extend Functionable

          module_function

          def test = :test
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Module function behavior is disabled.")
    end

    it "fails when specifying public visibility" do
      expectation = proc do
        Module.new do
          extend Functionable

          public

          def test = :test
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Public visibility is disabled.")
    end

    it "fails when specifying protected visibility" do
      expectation = proc do
        Module.new do
          extend Functionable

          protected

          def test = :test
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Protected visibility is disabled.")
    end

    it "fails when specifying private visibility" do
      expectation = proc do
        Module.new do
          extend Functionable

          private

          def test = :test
        end
      end

      message = "Private visibility is disabled, use conceal instead."

      expect(&expectation).to raise_error(NoMethodError, message)
    end

    it "conceals single private class method" do
      implementation = Module.new do
        extend Functionable

        def test = :test

        conceal :test
      end

      expectation = proc { implementation.test }

      expect(&expectation).to raise_error(NoMethodError, /private method 'test' called/)
    end

    it "conceals multiple arguments as private class methods" do
      implementation = Module.new do
        extend Functionable

        def one = :one

        def two = :two

        conceal :one, :two
      end

      expectation = proc { implementation.two }

      expect(&expectation).to raise_error(NoMethodError, /private method 'two' called/)
    end

    it "conceals an array as private class methods" do
      implementation = Module.new do
        extend Functionable

        def one = :one

        def two = :two

        conceal %i[one two]
      end

      expectation = proc { implementation.two }

      expect(&expectation).to raise_error(NoMethodError, /private method 'two' called/)
    end

    it "fails when aliasing a method" do
      expectation = proc do
        Module.new do
          extend Functionable

          def one = 1
          alias_method :one, :two
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Aliasing :two as :one is disabled.")
    end

    it "fails when setting a class variable" do
      implementation = Module.new do
        extend Functionable

        def test = class_variable_set :@@test, "test"
      end

      expectation = proc { implementation.test }

      expect(&expectation).to raise_error(
        NoMethodError,
        "Setting class variable :@@test is disabled."
      )
    end

    it "fails when getting a class variable" do
      implementation = Module.new do
        extend Functionable

        def test = class_variable_get :@@test
      end

      expectation = proc { implementation.test }

      expect(&expectation).to raise_error(
        NoMethodError,
        "Getting class variable :@@test is disabled."
      )
    end

    it "fails when setting a constant" do
      implementation = Module.new do
        extend Functionable

        def test = const_set :TEST, "test"
      end

      expectation = proc { implementation.test }

      expect(&expectation).to raise_error(NoMethodError, "Setting constant :TEST is disabled.")
    end

    it "fails when defining a method" do
      expectation = proc do
        Module.new do
          extend Functionable

          define_method :test, "test"
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Defining method :test is disabled.")
    end

    it "fails when removing a method" do
      expectation = proc do
        Module.new do
          extend Functionable

          def test = :test

          remove_method :test
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Removing method :test is disabled.")
    end

    it "fails when undefining a method" do
      expectation = proc do
        Module.new do
          extend Functionable

          undef_method :test
        end
      end

      expect(&expectation).to raise_error(NoMethodError, "Undefining method :test is disabled.")
    end

    it "fails when adding class methods" do
      expectation = proc do
        Module.new do
          extend Functionable

          def self.test = "A test."
        end
      end

      expect(&expectation).to raise_error(NoMethodError, /Avoid defining :test as a class method/)
    end

    it "ensures instance methods are class methods" do
      namespace = Module.new do
        extend Functionable

        def test = "A test."
      end

      expect(namespace.test).to eq("A test.")
    end
  end

  describe ".included" do
    it "fails when being included" do
      expectation = proc { Module.new.include described_class }

      expect(&expectation).to raise_error(
        NoMethodError,
        "Module include is disabled, use extend instead."
      )
    end
  end

  describe ".prepended" do
    it "fails when being prepended" do
      expectation = proc { Module.new.prepend described_class }

      expect(&expectation).to raise_error(
        NoMethodError,
        "Module prepend is disabled, use extend instead."
      )
    end
  end
end
