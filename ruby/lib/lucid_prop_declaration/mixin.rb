module LucidPropDeclaration
  module Mixin
    if RUBY_ENGINE == 'opal'
      def self.extended(base)

        def prop(prop_name, validate_hash = { required: true })
          validate_hash = validate_hash.to_h if validate_hash.class == Isomorfeus::Props::ValidateHashProxy
          if validate_hash.key?(:default)
            %x{
              if (base.lucid_react_component) {
                let react_prop_name = Opal.React.lower_camelize(prop_name);
                #{value = validate_hash[:default]}
                if (!base.lucid_react_component.defaultProps) { base.lucid_react_component.defaultProps = {}; }
                base.lucid_react_component.defaultProps[react_prop_name] = value;
                if (!base.lucid_react_component.propTypes) { base.lucid_react_component.propTypes = {}; }
                base.lucid_react_component.propTypes[react_prop_name] = base.lucid_react_component.prototype.validateProp;
              } else if (base.react_component) {
                let react_prop_name = Opal.React.lower_camelize(prop_name);
                #{value = validate_hash[:default]}
                if (!base.react_component.defaultProps) { base.react_component.defaultProps = {}; }
                base.react_component.defaultProps[react_prop_name] = value;
                if (!base.react_component.propTypes) { base.react_component.propTypes = {}; }
                base.react_component.propTypes[react_prop_name] = base.react_component.prototype.validateProp;
              }
            }
          end
          declared_props[prop_name.to_sym] = validate_hash
        end
      end

      def validate_function
        %x{
          if (typeof base.validate_function === 'undefined') {
            base.validate_function = function(props_object) {
              return base.$validate_props(`Opal.Hash.new(props_object)`)
            }
          }
          return base.validate_function;
        }
      end

      def validate_prop_function(prop)
        function_name = "validate_#{prop}_function"
        %x{
          if (typeof base[function_name] === 'undefined') {
            base[function_name] = function(value) {
              return base.$validate_prop(prop, value);
            }
          }
          return base[function_name];
        }
      end
    else
      def prop(prop_name, validate_hash = { required: true })
        validate_hash = validate_hash.to_h if validate_hash.class == Isomorfeus::Props::ValidateHashProxy
        declared_props[prop_name.to_sym] = validate_hash
      end
    end

    def declared_props
      @declared_props ||= {}
    end

    def validate
      Isomorfeus::Props::ValidateHashProxy.new
    end

    def validate_prop(prop, value)
      return false unless declared_props.key?(prop)
      validator = Isomorfeus::Props::Validator.new(self, prop, value, declared_props[prop])
      validator.validate!
      true
    end

    def validate_props(props)
      declared_props.each_key do |prop|
        if declared_props[prop].key?(:required) && declared_props[prop][:required] && !props.key?[prop]
          raise "Required prop #{prop} not given!"
        end
      end
      result = true
      props.each do |p, v|
        r = validate_prop(p, v)
        result = false unless r
      end
      result
    end
  end
end
