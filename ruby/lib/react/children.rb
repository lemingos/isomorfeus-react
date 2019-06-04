module React
  module Children
    class << self
      def count(children)
        `Opal.global.React.Children.count(children)`
      end

      def for_each(children, &block)
        %x{
          var fun = function(this_arg) {
            return #{block.call(this_arg)};
          }
          return Opal.global.React.Children.forEach(children, fun);
        }
      end

      def map(children, &block)
        %x{
          var fun = function(this_arg) {
            return #{block.call(this_arg)};
          }
          return Opal.global.React.Children.map(children, fun);
        }
      end

      def only(children)
        `Opal.global.React.Children.only(children)`
      end

      def to_array(children)
        `Opal.global.React.Children.toArray(children)`
      end
    end
  end
end