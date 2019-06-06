module React
  module Component
    module Initializer
      def initialize(native_component)
        @native = native_component
        @props = `Opal.React.Component.Props.$new(#@native.props)`
        @state = `Opal.React.Component.State.$new(#@native)`
      end
    end
  end
end
