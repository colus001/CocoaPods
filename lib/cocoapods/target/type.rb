module Pod
  class Target
    class Type
      TYPE_METHODS = [] # rubocop:disable Style/MutableConstant

      KNOWN_PACKAGING_OPTIONS = %i(library framework).freeze
      KNOWN_LINKAGE_OPTIONS = %i(static dynamic).freeze

      KNOWN_PACKAGING_OPTIONS.each do |packaging|
        method_name = :"#{packaging}?"
        TYPE_METHODS << method_name
        define_method(method_name) { self.packaging == packaging }

        KNOWN_LINKAGE_OPTIONS.each do |linkage|
          method_name = :"#{linkage}_#{packaging}?"
          TYPE_METHODS << method_name
          define_method(method_name) { self.packaging == packaging && self.linkage == linkage }
        end
      end

      KNOWN_LINKAGE_OPTIONS.each do |linkage|
        method_name = :"#{linkage}?"
        TYPE_METHODS << method_name
        define_method(method_name) { self.linkage == linkage }
      end

      TYPE_METHODS.freeze

      attr_reader :packaging
      attr_reader :linkage

      def initialize(linkage: :static, packaging: :library)
        raise ArgumentError, "Invalid linkage option #{linkage.inspect}, valid options are #{KNOWN_LINKAGE_OPTIONS.inspect}" unless KNOWN_LINKAGE_OPTIONS.include?(linkage)
        raise ArgumentError, "Invalid packaging option #{packaging.inspect}, valid options are #{KNOWN_PACKAGING_OPTIONS.inspect}" unless KNOWN_PACKAGING_OPTIONS.include?(packaging)
        @packaging = packaging
        @linkage = linkage
        @hash = packaging.hash ^ linkage.hash
      end

      def self.infer_from_spec(spec, host_requires_frameworks: false)
        if host_requires_frameworks
          root_spec = spec && spec.root
          if root_spec && root_spec.static_framework
            static_framework
          else
            dynamic_framework
          end
        else
          static_library
        end
      end

      def self.static_library
        new(:linkage => :static, :packaging => :library)
      end

      def self.dynamic_framework
        new(:linkage => :dynamic, :packaging => :framework)
      end

      def self.static_framework
        new(:linkage => :static, :packaging => :framework)
      end

      attr_reader :hash

      def to_s
        "#{linkage} #{packaging}"
      end

      def inspect
        "#<#{self.class} linkage=#{linkage} packaging=#{packaging}>"
      end

      def ==(other)
        linkage == other.linkage &&
            packaging == other.packaging
      end
    end
  end
end
