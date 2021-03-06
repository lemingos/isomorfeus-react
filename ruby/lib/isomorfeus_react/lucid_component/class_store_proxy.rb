module LucidComponent
  class ClassStoreProxy
    def initialize(component_instance)
      @native = component_instance.to_n
      @component_instance = component_instance
      @component_name = component_instance.class.to_s
    end

    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set class state, simply a dispatch
        action = { type: 'COMPONENT_CLASS_STATE', class: @component_name, name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.dispatch(action)
      else
        # get class state
        # check if we have a component local state value
        if @native.JS[:props].JS[:store]
          if @native.JS[:props].JS[:store].JS[:component_class_state] &&
              @native.JS[:props].JS[:store].JS[:component_class_state].JS[@component_name] &&
              @native.JS[:props].JS[:store].JS[:component_class_state].JS[@component_name].JS.hasOwnProperty(key)
            return @native.JS[:props].JS[:store].JS[:component_class_state].JS[@component_name].JS[key]
          end
        else
          a_state = Isomorfeus.store.get_state
          if a_state.key?(:component_class_state) && a_state[:component_class_state].key?(key)
            return a_state[:component_class_state][key]
          end
        end
        if @component_instance.class.default_class_store_defined && @component_instance.class.class_store.to_h.key?(key)
          # check if a default value was given
          return @component_instance.class.class_store.to_h[key]
        end
        # otherwise return nil
        return nil
      end
    end

    def dispatch(action)
      Isomorfeus.store.dispatch(action)
    end

    def subscribe(&block)
      Isomorfeus.store.subscribe(&block)
    end

    def unsubscribe(unsubscriber)
      `unsubscriber()`
    end
  end
end
