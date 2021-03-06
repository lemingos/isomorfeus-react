module React
  module Component
    class Location
      include ::Native::Wrapper

      def method_missing(prop, *args, &block)
        @native.JS[:props].JS[:location].JS[prop]
      end

      def to_n
        @native
      end
    end
  end
end
