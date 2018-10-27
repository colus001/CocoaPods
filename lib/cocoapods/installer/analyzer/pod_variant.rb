module Pod
  class Installer
    class Analyzer
      # Bundles the information needed to setup a {PodTarget}.
      class PodVariant
        # @return [Array<Specification>] the spec and subspecs for the target
        #
        attr_reader :specs

        # @return [Array<Specification>] the test specs for the target
        #
        attr_reader :test_specs

        # @return [Array<Specification>] the app specs for the target
        #
        attr_reader :app_specs

        # @return [Platform] the platform
        #
        attr_reader :platform

        attr_reader :type

        # @return [Specification] the root specification
        #
        def root_spec
          specs.first.root
        end

        # Initialize a new instance from its attributes.
        #
        # @param [Array<Specification>] specs      @see #specs
        # @param [Array<Specification>] test_specs @see #test_specs
        # @param [Array<Specification>] app_specs  @see #app_specs
        # @param [Platform] platform               @see #platform
        # @param [Target::Type] typ                @see #type?
        #
        def initialize(specs, test_specs, app_specs, platform, type)
          @specs = specs
          @test_specs = test_specs
          @app_specs = app_specs
          @platform = platform
          @type = type
          @hash = [specs, platform, type].hash
        end

        # @note Test specs are intentionally not included as part of the equality for pod variants since a
        #       pod variant should not be affected by the number of test nor app specs included.
        #
        # @return [Bool] whether the {PodVariant} is equal to another taking all
        #         all their attributes into account
        #
        def ==(other)
          self.class == other.class &&
            type == other.type &&
            platform == other.platform &&
            specs == other.specs
        end
        alias_method :eql?, :==

        # Hashes the instance by all its attributes.
        #
        # This adds support to make instances usable as Hash keys.
        #
        # @!visibility private
        attr_reader :hash
      end
    end
  end
end
