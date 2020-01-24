module React
  # language=JS
  %x{
    self.render_buffer = [];

    self.set_validate_prop = function(component, prop_name) {
      let core = component.react_component;
      if (typeof core.propTypes == "undefined") {
        core.propTypes = {};
        core.propValidations = {};
        core.propValidations[prop_name] = {};
      }
      core.propTypes[prop_name] = core.prototype.validateProp;
    };

    self.lower_camelize = function(snake_cased_word) {
      let parts = snake_cased_word.split('_');
      let res = parts[0];
      for (let i = 1; i < parts.length; i++) {
        res += parts[i][0].toUpperCase() + parts[i].slice(1);
      }
      return res;
    };

    self.native_element_or_component_to_ruby = function (element) {
      if (typeof element.__ruby_instance !== 'undefined') { return element.__ruby_instance }
      if (element instanceof Element || element instanceof Node) { return #{Browser::Element.new(`element`)} }
      return element;
    };

    self.to_native_react_props = function(ruby_style_props) {
      let result = {};
      let keys = ruby_style_props.$keys();
      let keys_length = keys.length;
      let key = '';
      for (let i = 0; i < keys_length; i++) {
        key = keys[i];
        if (key[0] === 'o' && key[1] === 'n' && key[2] === '_') {
          let handler = ruby_style_props['$[]'](key);
          let type = typeof handler;
          if (type === "function") {
            let active_c = self.active_component();
            result[Opal.React.lower_camelize(key)] = function(event, info) {
              let ruby_event;
              if (typeof event === "object") { #{ruby_event = ::React::SyntheticEvent.new(`event`)}; }
              else { ruby_event = event; }
              #{`active_c.__ruby_instance`.instance_exec(ruby_event, `info`, &`handler`)};
            }
          } else if (type === "object" && typeof handler.$call === "function" ) {
            if (!handler.react_event_handler_function) {
              handler.react_event_handler_function = function(event, info) {
                let ruby_event;
                if (typeof event === "object") { #{ruby_event = ::React::SyntheticEvent.new(`event`)}; }
                else { ruby_event = event; }
                handler.$call(ruby_event, `info`)
              };
            }
            result[Opal.React.lower_camelize(key)] = handler.react_event_handler_function;
          } else if (type === "string" ) {
            let active_component = Opal.React.active_component();
            let method_ref;
            let method_name = '$' + handler;
            if (typeof active_component[method_name] === "function") {
              // got a ruby instance
              if (active_component.native && active_component.native.method_refs && active_component.native.method_refs[handler]) { method_ref = active_component.native.method_refs[handler]; } // ruby instance with native
              else if (active_component.method_refs && active_component.method_refs[handler]) { method_ref = active_component.method_refs[handler]; } // ruby function component
              else { method_ref = active_component.$method_ref(handler); } // create the ref
            } else if (typeof active_component.__ruby_instance[method_name] === "function") {
              // got a native instance
              if (active_component.method_refs && active_component.method_refs[handler]) { method_ref = active_component.method_refs[handler]; }
              else { method_ref = active_component.__ruby_instance.$method_ref(handler); } // create ref for native
            }
            if (method_ref === undefined) {
              console.error("Undefined method " + handler + ", please use \"method_ref\" to pass methods within the components.", self.active_component());
            } else {
              if (!method_ref.react_event_handler_function) {
                method_ref.react_event_handler_function = function(event, info) {
                  let ruby_event;
                  if (typeof event === "object") { #{ruby_event = ::React::SyntheticEvent.new(`event`)}; }
                  else { ruby_event = event; }
                  method_ref.$call(ruby_event, `info`)
                };
              }
              result[Opal.React.lower_camelize(key)] = method_ref.react_event_handler_function;
            }
          } else {
            console.error("Received invalid value for " + key + " event handler:", handler, "(", type, ") within component:", self.active_component());
          }
        } else if (key[0] === 'a' && key.startsWith("aria_")) {
          result[key.replace("_", "-")] = ruby_style_props['$[]'](key);
        } else if (key === "style") {
          let val = ruby_style_props['$[]'](key);
          if (typeof val.$to_n === "function") { val = val.$to_n() }
          result["style"] = val;
        } else {
          result[key.indexOf('_') > 0 ? Opal.React.lower_camelize(key) : key] = ruby_style_props['$[]'](key);
        }
      }
      return result;
    };

    self.internal_prepare_args_and_render = function(component, args, block) {
      const operain = Opal.React.internal_render;
      if (args.length > 0) {
        let last_arg = args[args.length - 1];
        if (last_arg && last_arg.constructor === String) {
          if (args.length === 1) { return operain(component, null, last_arg, null); }
          else { operain(component, args[0], last_arg, null); }
        } else { operain(component, args[0], null, block); }
      } else { operain(component, null, null, block); }
    };

    self.internal_render = function(component, props, string_child, block) {
      const operabu = Opal.React.render_buffer;
      let children;
      let native_props = null;
      if (string_child) {
        children = [string_child];
      } else if (block && block !== nil) {
        operabu.push([]);
        // console.log("internal_render pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        let block_result = block.$call();
        if (block_result && (block_result.constructor === String || block_result.constructor === Number)) {
          operabu[operabu.length - 1].push(block_result);
        }
        // console.log("internal_render popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        children = operabu.pop();
      }
      if (props && props !== nil) { native_props = Opal.React.to_native_react_props(props); }
      operabu[operabu.length - 1].push(Opal.global.React.createElement.apply(this, [component, native_props].concat(children)));
    };

    self.active_components = [];

    self.active_component = function() {
      let length = Opal.React.active_components.length;
      if (length === 0) { return null; };
      return Opal.React.active_components[length-1];
    };

    self.active_redux_components = [];

    self.active_redux_component = function() {
      let length = Opal.React.active_redux_components.length;
      if (length === 0) { return null; };
      return Opal.React.active_redux_components[length-1];
    };
  }

  def self.clone_element(ruby_react_element, props = nil, children = nil, &block)
    block_result = `null`
    if block_given?
      block_result = block.call
      block_result = `null` unless block_result
    end
    native_props = props ? `Opal.React.to_native_react_props(props)` : `null`
    `Opal.global.React.cloneElement(ruby_react_element.$to_n(), native_props, block_result)`
  end

  def self.create_context(const_name, default_value)
    %x{
      Opal.global[const_name] = Opal.global.React.createContext(default_value);
      var new_const = #{React::ContextWrapper.new(`Opal.global[const_name]`)};
      #{Object.const_set(const_name, `new_const`)};
      return new_const;
    }
  end

  def self.create_element(type, props = nil, children = nil, &block)
    %x{
      const operabu = Opal.React.render_buffer;
      let component = null;
      let native_props = null;
      if (typeof type.react_component !== 'undefined') { component = type.react_component; }
      else { component = type; }
      if (block !== nil) {
        operabu.push([]);
        // console.log("create_element pushed", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        let block_result = block.$call();
        if (block_result && (block_result.constructor === String || block_result.constructor === Number)) {
          operabu[operabu.length - 1].push(block_result);
        }
        // console.log("create_element popping", Opal.React.render_buffer, Opal.React.render_buffer.toString());
        children = operabu.pop();
      } else if (children === nil) { children = []; }
      else if (typeof children === 'string') { children = [children]; }
      if (props && props !== nil) { native_props = Opal.React.to_native_react_props(props); }
      return Opal.global.React.createElement.apply(this, [component, native_props].concat(children));
    }
  end

  def self.create_factory(type)
    native_function = `Opal.global.React.createFactory(type)`
    proc { `native_function.call()` }
  end

  def self.create_ref
    React::Ref.new(`Opal.global.React.createRef()`)
  end

  def self.forwardRef(&block)
    # TODO whats the return here? A React:Element?, doc says a React node, whats that?
    `Opal.global.React.forwardRef( function(props, ref) { return block.$call().$to_n(); })`
  end

  def self.is_valid_element(react_element)
    `Opal.global.React.isValidElement(react_element)`
  end

  def self.lazy(import_statement_function)
    `Opal.global.React.lazy(import_statement_function)`
  end

  def self.memo(function_component, &block)
    if block_given?
      %x{
        var fun = function(prev_props, next_props) {
          return #{block.call(::React::Component::Props.new(`{props: prev_props}`), ::React::Component::Props.new(`{props: next_props}`))};
        }
        return Opal.global.React.memo(function_component, fun);
      }
    else
      `Opal.global.React.memo(function_component)`
    end
  end
end
